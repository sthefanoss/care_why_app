import 'package:flutter/foundation.dart';
import 'profile.dart';

@immutable
class User {
  final int id;
  final String username;
  final bool isAdmin;
  final Profile? profile;
  final int nextLevelExperience;
  final int experience;
  final int level;

  const User({
    required this.id,
    required this.username,
    required this.isAdmin,
    required this.profile,
    required this.nextLevelExperience,
    required this.experience,
    required this.level,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      isAdmin: map['isAdmin'] ?? false,
      profile: map['profile'] != null ? Profile.fromMap(map['profile']) : null,
      nextLevelExperience: map['nextLevelExperience'] ?? 1,
      experience: map['experience'] ?? 0,
      level: map['level'] ?? 0,
    );
  }
}
