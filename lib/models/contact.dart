class Contact {
  final String id;
  final String imagePath;
  final String username;
  final String email;
  final String about;
  final DateTime createdAt;

  const Contact({
    required this.id,
    required this.imagePath,
    required this.username,
    required this.email,
    required this.about,
    required this.createdAt,
  });
}
