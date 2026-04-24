import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/models/chat_message.dart';
import 'package:chat_app/models/contact.dart';
import 'package:chat_app/models/friend_request.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRepository {
  ChatRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  User get _currentUser {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('You must be signed in to use MadaniChat.');
    }
    return user;
  }

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _friendRequests =>
      _firestore.collection('friendRequests');

  CollectionReference<Map<String, dynamic>> get _chats =>
      _firestore.collection('chats');

  Future<void> ensureCurrentUserProfile({String? displayName}) async {
    final user = _currentUser;
    final userRef = _users.doc(user.uid);
    final snapshot = await userRef.get();
    final email = user.email ?? '';
    final cleanDisplayName = (displayName ?? user.displayName ?? '').trim();

    final data = {
      'uid': user.uid,
      'displayName': cleanDisplayName.isNotEmpty
          ? cleanDisplayName
          : email.split('@').first,
      'email': email,
      'emailLower': email.toLowerCase(),
      'about': 'Hello! Catch me on MadaniChat',
      'photoPath': 'lib/assets/avatar.jpg',
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (snapshot.exists) {
      await userRef.set(data, SetOptions(merge: true));
      return;
    }

    await userRef.set({...data, 'createdAt': FieldValue.serverTimestamp()});
  }

  Stream<List<Contact>> watchContacts() {
    final uid = _currentUser.uid;

    return _users.doc(uid).collection('contacts').snapshots().map((snapshot) {
      final contacts = snapshot.docs.map((doc) {
        final data = doc.data();
        final createdAt = data['createdAt'];

        return Contact(
          id: doc.id,
          imagePath: (data['photoPath'] as String?) ?? 'lib/assets/avatar.jpg',
          username: (data['displayName'] as String?) ?? 'Unknown user',
          email: (data['email'] as String?) ?? '',
          about: (data['about'] as String?) ?? 'Hello! Catch me on MadaniChat',
          createdAt: createdAt is Timestamp
              ? createdAt.toDate()
              : DateTime.now(),
        );
      }).toList();

      contacts.sort((a, b) => a.username.compareTo(b.username));
      return contacts;
    });
  }

  Stream<List<FriendRequest>> watchIncomingFriendRequests() {
    final uid = _currentUser.uid;

    return _friendRequests
        .where('toUid', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
          final requests = snapshot.docs
              .map((doc) => FriendRequest.fromSnapshot(doc))
              .toList();

          requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return requests;
        });
  }

  Stream<List<Message>> watchChatSummaries() {
    final uid = _currentUser.uid;

    return _chats.where('participantIds', arrayContains: uid).snapshots().map((
      snapshot,
    ) {
      final chats = snapshot.docs.where((doc) {
        return doc.data()['hasMessages'] == true;
      }).map((doc) {
        final data = doc.data();
        final participantNames = Map<String, dynamic>.from(
          data['participantNames'] ?? {},
        );
        final participantEmails = Map<String, dynamic>.from(
          data['participantEmails'] ?? {},
        );
        final participantPhotos = Map<String, dynamic>.from(
          data['participantPhotos'] ?? {},
        );
        final unreadCounts = Map<String, dynamic>.from(
          data['unreadCounts'] ?? {},
        );
        final updatedAt = data['updatedAt'];
        final friendId = (data['participantIds'] as List<dynamic>? ?? [])
            .whereType<String>()
            .firstWhere((id) => id != uid, orElse: () => '');

        return Message(
          chatId: doc.id,
          contactId: friendId,
          contactEmail: (participantEmails[friendId] as String?) ?? '',
          imagePath:
              (participantPhotos[friendId] as String?) ??
              'lib/assets/avatar.jpg',
          username: (participantNames[friendId] as String?) ?? 'Unknown user',
          currentMessage: (data['lastMessage'] as String?) ?? 'No messages yet',
          dateTime: updatedAt is Timestamp
              ? updatedAt.toDate()
              : DateTime.now(),
          badgeCount: (unreadCounts[uid] as num?)?.toInt() ?? 0,
        );
      }).toList();

      chats.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return chats;
    });
  }

  Stream<List<ChatMessage>> watchMessages(String chatId) {
    return _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatMessage.fromSnapshot(doc)).toList());
  }

  Future<String> openChatWithContact(Contact contact) async {
    final currentUser = _currentUser;
    await ensureCurrentUserProfile();

    final currentUserSnapshot = await _users.doc(currentUser.uid).get();
    final currentAppUser = AppUser.fromSnapshot(currentUserSnapshot);
    final chatId = _chatId(currentUser.uid, contact.id);
    final chatRef = _chats.doc(chatId);

    await _firestore.runTransaction((transaction) async {
      final chatSnapshot = await transaction.get(chatRef);

      if (chatSnapshot.exists) {
        return;
      }

      transaction.set(chatRef, {
        'participantIds': [currentAppUser.id, contact.id]..sort(),
        'participantEmails': {
          currentAppUser.id: currentAppUser.email,
          contact.id: contact.email,
        },
        'participantNames': {
          currentAppUser.id: currentAppUser.displayName,
          contact.id: contact.username,
        },
        'participantPhotos': {
          currentAppUser.id: currentAppUser.photoPath,
          contact.id: contact.imagePath,
        },
        'unreadCounts': {
          currentAppUser.id: 0,
          contact.id: 0,
        },
        'hasMessages': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });

    return chatId;
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final sender = _currentUser;
    final cleanText = text.trim();

    if (cleanText.isEmpty) {
      throw ArgumentError('Message cannot be empty.');
    }

    final chatRef = _chats.doc(chatId);
    final messageRef = chatRef.collection('messages').doc();

    await _firestore.runTransaction((transaction) async {
      final chatSnapshot = await transaction.get(chatRef);
      final participantIds =
          (chatSnapshot.data()?['participantIds'] as List<dynamic>? ?? [])
              .whereType<String>()
              .toList();
      final recipientIds = participantIds.where((id) => id != sender.uid);

      transaction.set(messageRef, {
        'senderId': sender.uid,
        'text': cleanText,
        'createdAt': FieldValue.serverTimestamp(),
      });
      final updateData = <String, dynamic>{
        'hasMessages': true,
        'lastMessage': cleanText,
        'lastMessageSenderId': sender.uid,
        'updatedAt': FieldValue.serverTimestamp(),
        'unreadCounts.${sender.uid}': 0,
      };

      for (final recipientId in recipientIds) {
        updateData['unreadCounts.$recipientId'] = FieldValue.increment(1);
      }

      transaction.update(chatRef, updateData);
    });
  }

  Future<void> markChatAsRead(String chatId) async {
    final uid = _currentUser.uid;
    await _chats.doc(chatId).set(
      {
        'unreadCounts': {uid: 0},
      },
      SetOptions(merge: true),
    );
  }

  Future<void> sendFriendRequest(String email) async {
    final sender = _currentUser;
    final targetEmail = email.trim().toLowerCase();

    if (targetEmail.isEmpty) {
      throw ArgumentError('Enter a friend email address.');
    }

    if (targetEmail == (sender.email ?? '').toLowerCase()) {
      throw ArgumentError('You cannot add yourself as a friend.');
    }

    await ensureCurrentUserProfile();

    final targetSnapshot = await _users
        .where('emailLower', isEqualTo: targetEmail)
        .limit(1)
        .get();

    if (targetSnapshot.docs.isEmpty) {
      throw ArgumentError('No MadaniChat user found with that email.');
    }

    final targetUser = AppUser.fromSnapshot(targetSnapshot.docs.first);
    final contactSnapshot = await _users
        .doc(sender.uid)
        .collection('contacts')
        .doc(targetUser.id)
        .get();

    if (contactSnapshot.exists) {
      throw ArgumentError('This user is already in your contacts.');
    }

    final requestId = _friendRequestId(sender.uid, targetUser.id);
    final reverseRequestId = _friendRequestId(targetUser.id, sender.uid);
    final requestSnapshot = await _friendRequests.doc(requestId).get();
    final reverseRequestSnapshot = await _friendRequests
        .doc(reverseRequestId)
        .get();

    if (requestSnapshot.exists &&
        requestSnapshot.data()?['status'] == 'pending') {
      throw ArgumentError('A friend request is already pending.');
    }

    if (reverseRequestSnapshot.exists &&
        reverseRequestSnapshot.data()?['status'] == 'pending') {
      throw ArgumentError('This user already sent you a friend request.');
    }

    final senderProfile = await _users.doc(sender.uid).get();
    final senderUser = AppUser.fromSnapshot(senderProfile);

    await _friendRequests.doc(requestId).set({
      'fromUid': sender.uid,
      'fromEmail': sender.email,
      'fromDisplayName': senderUser.displayName,
      'toUid': targetUser.id,
      'toEmail': targetUser.email,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptFriendRequest(FriendRequest request) async {
    final receiver = _currentUser;
    if (request.toUid != receiver.uid) {
      throw StateError('This request does not belong to the current user.');
    }

    final requestRef = _friendRequests.doc(request.id);
    final receiverRef = _users.doc(receiver.uid);
    final senderRef = _users.doc(request.fromUid);

    await _firestore.runTransaction((transaction) async {
      final requestSnapshot = await transaction.get(requestRef);
      if (!requestSnapshot.exists ||
          requestSnapshot.data()?['status'] != 'pending') {
        return;
      }

      final receiverSnapshot = await transaction.get(receiverRef);
      final senderSnapshot = await transaction.get(senderRef);

      if (!receiverSnapshot.exists || !senderSnapshot.exists) {
        throw StateError('One of the users no longer exists.');
      }

      final receiverUser = AppUser.fromSnapshot(receiverSnapshot);
      final senderUser = AppUser.fromSnapshot(senderSnapshot);

      transaction.set(
        receiverRef.collection('contacts').doc(senderUser.id),
        _contactMap(senderUser),
      );
      transaction.set(
        senderRef.collection('contacts').doc(receiverUser.id),
        _contactMap(receiverUser),
      );
      transaction.update(requestRef, {
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> declineFriendRequest(FriendRequest request) async {
    final receiver = _currentUser;
    if (request.toUid != receiver.uid) {
      throw StateError('This request does not belong to the current user.');
    }

    await _friendRequests.doc(request.id).delete();
  }

  Map<String, dynamic> _contactMap(AppUser user) {
    return {
      'uid': user.id,
      'displayName': user.displayName,
      'email': user.email,
      'emailLower': user.emailLower,
      'about': user.about,
      'photoPath': user.photoPath,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  String _friendRequestId(String fromUid, String toUid) {
    return '${fromUid}_$toUid';
  }

  String _chatId(String firstUid, String secondUid) {
    final ids = [firstUid, secondUid]..sort();
    return ids.join('_');
  }
}
