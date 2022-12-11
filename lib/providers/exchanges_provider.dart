import 'dart:developer';

import 'package:care_why_app/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/exchange.dart';
import '../services/local_storage.dart';
import '../services/http_client.dart';

class ExchangesProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final _exchanges = <Exchange>[];
  final _users = <int, User>{};

  List<Exchange> get exchanges => [..._exchanges];

  User getUserById(int id) => _users[id]!;

  Future<void> getExchangesFromApi() async {
    final response = await HttpClient().get(
      'http://carewhyapp.kinghost.net/exchanges',
    );

    final data = response.data['exchanges'] as Iterable;
    _exchanges.clear();
    _exchanges.addAll(data.map((e) => Exchange.fromMap(e)));
    _users.clear();
    _users.addEntries(
      (response.data['users'] as Iterable).map((map) => MapEntry(map['id'], User.fromMap(map))),
    );
    notifyListeners();
  }

  Future<void> makeExchange({
    required String username,
    required int coins,
    required String reason,
  }) async {
    try {
      await HttpClient().post(
        'http://carewhyapp.kinghost.net/admin/exchanges',
        data: {
          'username': username,
          'reason': reason,
          'coins': coins,
        },
      );
    } catch (e) {
      log(e.toString(), name: 'error on makeExchange');
      rethrow;
    }
  }
}
