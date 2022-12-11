import 'package:flutter/foundation.dart';

@immutable
class User {
  final int id;
  final String username;
  final bool isAdmin;
  final bool isManager;
  final int coins;
  final String? nickname;
  final String? imageUrl;

  const User({
    required this.id,
    required this.username,
    required this.isAdmin,
    required this.isManager,
    required this.coins,
    required this.nickname,
    required this.imageUrl,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      isAdmin: map['isAdmin'],
      isManager: map['isManager'],
      coins: map['coins'],
      nickname: map['nickname'],
      imageUrl: map['imageUrl'],
    );
  }

  bool get canMakeLups => !isAdmin && !isManager;

  bool get canManageLeaderAccounts => isAdmin;

  bool get canManageWorkersAccounts => isAdmin || isManager;

  bool get canManageExchanges => isAdmin || isManager;
}
