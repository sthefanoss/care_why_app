import 'dart:developer';

import 'package:care_why_app/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/exchange.dart';
import '../services/local_storage.dart';
import '../services/http_client.dart';

class ExchangesProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final _exchanges = <Exchange>[];

  List<Exchange> get exchanges => [..._exchanges];

  Future<void> getExchangesFromApi() async {
    final response = await HttpClient().get(
      'http://carewhyapp.kinghost.net/exchanges',
    );

    final data = response.data['exchanges'] as Iterable;
    _exchanges.clear();
    _exchanges.addAll(data.map((e) => Exchange.fromMap(e)));
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

  // Future<void> deleteUser({required String username}) async {
  //   try {
  //     await HttpClient().post(
  //       'http://carewhyapp.kinghost.net/auth/delete-user',
  //       queryParameters: {'username': username},
  //     );
  //   } catch (e) {
  //     log(e.toString(), name: 'error on deleteUser');
  //     rethrow;
  //   }
  // }
}
