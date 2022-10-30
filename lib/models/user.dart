import 'package:flutter/foundation.dart';
import 'profile.dart';

@immutable
class User {
  final int id;
  final String username;
  final bool isAdmin;
  final Profile? profile;

  const User({
    required this.id,
    required this.username,
    required this.isAdmin,
    required this.profile,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      isAdmin: map['isAdmin'] ?? false,
      profile: map['profile'] != null ? Profile.fromMap(map['profile']) : null,
    );
  }
}
