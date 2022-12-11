import 'package:flutter/cupertino.dart';

@immutable
class Exchange {
  final int id;
  final String reason;
  final int coins;
  final int sellerId;
  final int buyerId;
  final DateTime createdAt;

  const Exchange({
    required this.id,
    required this.reason,
    required this.coins,
    required this.sellerId,
    required this.buyerId,
    required this.createdAt,
  });

  factory Exchange.fromMap(Map<String, dynamic> map) {
    return Exchange(
      id: map['id'],
      reason: map['reason'],
      coins: map['coins'],
      sellerId: map['sellerId'],
      buyerId: map['buyerId'],
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}
