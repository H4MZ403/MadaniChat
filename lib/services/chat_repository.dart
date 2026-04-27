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

    final baseData = {
      'uid': user.uid,
      'displayName': cleanDisplayName.isNotEmpty
          ? cleanDisplayName
          : email.split('@').first,
      'email': email,
      'emailLower': email.toLowerCase(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (snapshot.exists) {
      await userRef.set(baseData, SetOptions(merge: true));
      return;
    }

    await userRef.set({
      ...baseData,
      'about': 'Hello! Catch me on MadaniChat',
      'phoneNumber': '',
      'photoPath': 'lib/assets/avatar.jpg',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<AppUser> watchCurrentUserProfile() {
    final uid = _currentUser.uid;
    return _users.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return AppUser(
          id: uid,
          displayName:
              _currentUser.displayName ??
              (_currentUser.email ?? 'User').split('@').first,
          email: _currentUser.email ?? '',
          emailLower: (_currentUser.email ?? '').toLowerCase(),
          about: 'Hello! Catch me on MadaniChat',
          phoneNumber: '',
          photoPath: 'lib/assets/avatar.jpg',
        );
      }

      return AppUser.fromSnapshot(snapshot);
    });
  }

  Future<void> updateProfile({
    required String displayName,
    required String about,
  }) async {
    final user = _currentUser;
    final cleanDisplayName = displayName.trim();
    final cleanAbout = about.trim();

    if (cleanDisplayName.isEmpty) {
      throw ArgumentError('Name cannot be empty.');
    }

    await user.updateDisplayName(cleanDisplayName);

    await _users.doc(user.uid).set({
      'displayName': cleanDisplayName,
      'about': cleanAbout.isEmpty
          ? 'Hello! Catch me on MadaniChat'
          : cleanAbout,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _syncUserDenormalizedFields(
      displayName: cleanDisplayName,
      about: cleanAbout.isEmpty ? 'Hello! Catch me on MadaniChat' : cleanAbout,
    );
  }

  Future<void> updateEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    final user = _currentUser;
    final cleanEmail = newEmail.trim().toLowerCase();

    if (cleanEmail.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }

    await _reauthenticateWithPassword(currentPassword);
    await user.updateEmail(cleanEmail);

    await _users.doc(user.uid).set({
      'email': cleanEmail,
      'emailLower': cleanEmail,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _syncUserDenormalizedFields(email: cleanEmail);
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final cleanPassword = newPassword.trim();

    if (cleanPassword.length < 6) {
      throw ArgumentError('Password must be at least 6 characters.');
    }

    await _reauthenticateWithPassword(currentPassword);
    await _currentUser.updatePassword(cleanPassword);
  }

  Future<void> updatePhoneNumber({
    required String phoneNumber,
    required String currentPassword,
  }) async {
    final cleanPhone = phoneNumber.trim();
    await _reauthenticateWithPassword(currentPassword);

    await _users.doc(_currentUser.uid).set({
      'phoneNumber': cleanPhone,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateSecuritySettings({
    required String currentPassword,
    required String email,
    required String phoneNumber,
    String? newPassword,
  }) async {
    final user = _currentUser;
    final cleanEmail = email.trim().toLowerCase();
    final cleanPhone = phoneNumber.trim();
    final cleanPassword = newPassword?.trim() ?? '';

    if (cleanEmail.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }

    if (cleanPassword.isNotEmpty && cleanPassword.length < 6) {
      throw ArgumentError('Password must be at least 6 characters.');
    }

    await _reauthenticateWithPassword(currentPassword);

    final oldEmail = user.email?.toLowerCase() ?? '';
    if (cleanEmail != oldEmail) {
      await user.updateEmail(cleanEmail);
    }

    if (cleanPassword.isNotEmpty) {
      await user.updatePassword(cleanPassword);
    }

    await _users.doc(user.uid).set({
      'email': cleanEmail,
      'emailLower': cleanEmail,
      'phoneNumber': cleanPhone,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (cleanEmail != oldEmail) {
      await _syncUserDenormalizedFields(email: cleanEmail);
    }
  }

  Future<void> verifyCurrentPassword(String currentPassword) async {
    await _reauthenticateWithPassword(currentPassword);
  }

  Future<void> deleteCurrentAccount({required String currentPassword}) async {
    final user = _currentUser;
    final uid = user.uid;

    await _reauthenticateWithPassword(currentPassword);

    final contactsSnapshot = await _users.doc(uid).collection('contacts').get();
    final outgoingRequests = await _friendRequests
        .where('fromUid', isEqualTo: uid)
        .get();
    final incomingRequests = await _friendRequests
        .where('toUid', isEqualTo: uid)
        .get();
    final userChats = await _chats
        .where('participantIds', arrayContains: uid)
        .get();

    var batch = _firestore.batch();
    var operationCount = 0;

    Future<void> commitIfNeeded({bool force = false}) async {
      if (operationCount == 0 || (!force && operationCount < 450)) {
        return;
      }

      await batch.commit();
      batch = _firestore.batch();
      operationCount = 0;
    }

    Future<void> queueDelete(DocumentReference reference) async {
      batch.delete(reference);
      operationCount++;
      await commitIfNeeded();
    }

    for (final contact in contactsSnapshot.docs) {
      await queueDelete(contact.reference);
      await queueDelete(_users.doc(contact.id).collection('contacts').doc(uid));
    }

    for (final request in outgoingRequests.docs) {
      await queueDelete(request.reference);
    }

    for (final request in incomingRequests.docs) {
      await queueDelete(request.reference);
    }

    for (final chat in userChats.docs) {
      final messages = await chat.reference.collection('messages').get();
      for (final message in messages.docs) {
        await queueDelete(message.reference);
      }
      await queueDelete(chat.reference);
    }

    await queueDelete(_users.doc(uid));
    await commitIfNeeded(force: true);

    await user.delete();
  }

  Future<void> _reauthenticateWithPassword(String currentPassword) async {
    final user = _currentUser;
    final email = user.email;

    if (email == null || email.isEmpty) {
      throw StateError('Current account does not have an email login.');
    }

    if (currentPassword.isEmpty) {
      throw ArgumentError('Current password is required.');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
  }

  Future<void> _syncUserDenormalizedFields({
    String? displayName,
    String? about,
    String? email,
  }) async {
    final uid = _currentUser.uid;
    final batch = _firestore.batch();

    if (displayName != null || email != null || about != null) {
      final contacts = await _users.doc(uid).collection('contacts').get();

      for (final contact in contacts.docs) {
        final data = <String, dynamic>{
          'updatedAt': FieldValue.serverTimestamp(),
        };
        if (displayName != null) data['displayName'] = displayName;
        if (email != null) {
          data['email'] = email;
          data['emailLower'] = email.toLowerCase();
        }
        if (about != null) data['about'] = about;
        batch.set(
          _users.doc(contact.id).collection('contacts').doc(uid),
          data,
          SetOptions(merge: true),
        );
      }
    }

    if (displayName != null || email != null) {
      final chats = await _chats
          .where('participantIds', arrayContains: uid)
          .get();
      for (final chat in chats.docs) {
        final data = <String, dynamic>{
          'updatedAt': FieldValue.serverTimestamp(),
        };
        if (displayName != null) data['participantNames.$uid'] = displayName;
        if (email != null) data['participantEmails.$uid'] = email;
        batch.set(chat.reference, data, SetOptions(merge: true));
      }
    }

    await batch.commit();
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

  Stream<int> watchIncomingFriendRequestCount() {
    final uid = _currentUser.uid;

    return _friendRequests
        .where('toUid', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<Message>> watchChatSummaries() {
    final uid = _currentUser.uid;

    return _chats.where('participantIds', arrayContains: uid).snapshots().map((
      snapshot,
    ) {
      final chats = snapshot.docs
          .where((doc) {
            return doc.data()['hasMessages'] == true;
          })
          .map((doc) {
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
              username:
                  (participantNames[friendId] as String?) ?? 'Unknown user',
              currentMessage:
                  (data['lastMessage'] as String?) ?? 'No messages yet',
              dateTime: updatedAt is Timestamp
                  ? updatedAt.toDate()
                  : DateTime.now(),
              badgeCount: (unreadCounts[uid] as num?)?.toInt() ?? 0,
            );
          })
          .toList();

      chats.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return chats;
    });
  }

  Stream<int> watchUnreadMessageCount() {
    final uid = _currentUser.uid;

    return _chats.where('participantIds', arrayContains: uid).snapshots().map((
      snapshot,
    ) {
      var total = 0;

      for (final chat in snapshot.docs) {
        final data = chat.data();
        final unreadCounts = Map<String, dynamic>.from(
          data['unreadCounts'] ?? {},
        );
        total += (unreadCounts[uid] as num?)?.toInt() ?? 0;
      }

      return total;
    });
  }

  Stream<List<ChatMessage>> watchMessages(String chatId) {
    return _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromSnapshot(doc))
              .toList(),
        );
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
        'unreadCounts': {currentAppUser.id: 0, contact.id: 0},
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
    await _chats.doc(chatId).set({
      'unreadCounts': {uid: 0},
    }, SetOptions(merge: true));
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
      transaction.delete(requestRef);
    });
  }

  Future<void> declineFriendRequest(FriendRequest request) async {
    final receiver = _currentUser;
    if (request.toUid != receiver.uid) {
      throw StateError('This request does not belong to the current user.');
    }

    await _friendRequests.doc(request.id).delete();
  }

  Future<void> deleteContact(Contact contact) async {
    final uid = _currentUser.uid;
    final currentContactRef = _users
        .doc(uid)
        .collection('contacts')
        .doc(contact.id);
    final friendContactRef = _users
        .doc(contact.id)
        .collection('contacts')
        .doc(uid);

    await _firestore.runTransaction((transaction) async {
      transaction.delete(currentContactRef);
      transaction.delete(friendContactRef);
    });
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
