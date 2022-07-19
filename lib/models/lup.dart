import 'package:care_why_app/models/user.dart';

class LUP {
  final String title;
  final String description;
  final User author;
  final List<User> collaborators;
  final String imageUrl;

  const LUP({
    required this.title,
    required this.description,
    required this.author,
    required this.collaborators,
    required this.imageUrl,
  });

  LUP.fromMap(Map<String, dynamic> map, [User? author])
      : title = map['title'],
        description = map['description'],
        author = author ?? User.fromMap(map['author']),
        collaborators = (map['collaborators'] as List).map<User>((u) => User.fromMap(u)).toList(),
        imageUrl = map['imageUrl'];
}
