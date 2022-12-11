import 'package:flutter/cupertino.dart';

@immutable
class Exchange {
  final int id;
  final String reason;
  final int coins;
  final int sellerId;
  final int buyerId;

  const Exchange({
    required this.id,
    required this.reason,
    required this.coins,
    required this.sellerId,
    required this.buyerId,
  });

  factory Exchange.fromMap(Map<String, dynamic> map) {
    return Exchange(
      id: map['id'],
      reason: map['reason'],
      coins: map['coins'],
      sellerId: map['sellerId'],
      buyerId: map['buyerId'],
    );
  }
}
