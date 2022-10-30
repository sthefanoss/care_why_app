import 'package:flutter/foundation.dart';

@immutable
class Profile {
  final int id;
  final String nickname;
  final String? imageUrl;

  const Profile({
    required this.id,
    required this.nickname,
    required this.imageUrl,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      nickname: map['nickname'],
      imageUrl: map['imageUrl'],
    );
  }
}
