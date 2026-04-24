import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String displayName;
  final String email;
  final String emailLower;
  final String about;
  final String phoneNumber;
  final String photoPath;

  const AppUser({
    required this.id,
    required this.displayName,
    required this.email,
    required this.emailLower,
    required this.about,
    required this.phoneNumber,
    required this.photoPath,
  });

  factory AppUser.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    final email = (data['email'] as String?) ?? '';

    return AppUser(
      id: snapshot.id,
      displayName: (data['displayName'] as String?) ?? email.split('@').first,
      email: email,
      emailLower: (data['emailLower'] as String?) ?? email.toLowerCase(),
      about: (data['about'] as String?) ?? 'Hello! Catch me on MadaniChat',
      phoneNumber: (data['phoneNumber'] as String?) ?? '',
      photoPath: (data['photoPath'] as String?) ?? 'lib/assets/avatar.jpg',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'displayName': displayName,
      'email': email,
      'emailLower': emailLower,
      'about': about,
      'phoneNumber': phoneNumber,
      'photoPath': photoPath,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
