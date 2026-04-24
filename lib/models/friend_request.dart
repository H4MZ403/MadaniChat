import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  final String id;
  final String fromUid;
  final String fromEmail;
  final String fromDisplayName;
  final String toUid;
  final String toEmail;
  final DateTime createdAt;

  const FriendRequest({
    required this.id,
    required this.fromUid,
    required this.fromEmail,
    required this.fromDisplayName,
    required this.toUid,
    required this.toEmail,
    required this.createdAt,
  });

  factory FriendRequest.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    final createdAt = data['createdAt'];

    return FriendRequest(
      id: snapshot.id,
      fromUid: (data['fromUid'] as String?) ?? '',
      fromEmail: (data['fromEmail'] as String?) ?? '',
      fromDisplayName: (data['fromDisplayName'] as String?) ?? 'Unknown user',
      toUid: (data['toUid'] as String?) ?? '',
      toEmail: (data['toEmail'] as String?) ?? '',
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
    );
  }
}
