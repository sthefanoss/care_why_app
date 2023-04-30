import 'package:flutter/cupertino.dart';

const lupTypes = <int, String>{
  1: "Operação",
  2: "Organização",
  3: "Meio ambiente",
  4: "Qualidade",
  5: "Segurança",
};

@immutable
class Lup {
  final int id;
  final String title;
  final int typeId;
  final int authorId;
  final String imageUrl;
  final DateTime createdAt;

  const Lup({
    required this.id,
    required this.title,
    required this.typeId,
    required this.authorId,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Lup.fromMap(Map<String, dynamic> map) {
    int? typeId;
    if (map['typeId'] is int) {
      typeId = map['typeId'];
    } else if (map['typeId'] is String) {
      typeId = int.tryParse(map['typeId']);
    }

    return Lup(
      id: map['id'],
      title: map['title'],
      typeId: typeId ?? -1,
      authorId: map['authorId'],
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }

  String get type => lupTypes[typeId] ?? '';
}
