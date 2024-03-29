import 'package:flutter/cupertino.dart';

@immutable
class Lup {
  final int id;
  final String title;
  final String description;
  final int authorId;
  final String imageUrl;
  final DateTime createdAt;

  const Lup({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Lup.fromMap(Map<String, dynamic> map) {
    return Lup(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      authorId: map['authorId'],
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}
