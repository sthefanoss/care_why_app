import 'dart:developer';

import 'package:care_why_app/models/user.dart';
import 'package:flutter/foundation.dart';

import '../services/http_client.dart';

class CollegesProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final _colleges = <User>[];

  List<User> get colleges => [..._colleges];

  Future<void> getCollegesFromApi() async {
    final response = await HttpClient().get(
      'http://carewhyapp.kinghost.net/users',
    );

    final data = response.data as List;
    _colleges.clear();
    _colleges.addAll(data.map((e) => User.fromMap(e)));
    notifyListeners();
  }

  Future<void> makeUser({required String username}) async {
    try {
      await HttpClient().post(
        'http://carewhyapp.kinghost.net/auth/user',
        queryParameters: {'username': username},
      );
    } catch (e) {
      log(e.toString(), name: 'error on makeUser');
      rethrow;
    }
  }

  Future<void> deleteUser({required String username}) async {
    try {
      await HttpClient().post(
        'http://carewhyapp.kinghost.net/auth/delete-user',
        queryParameters: {'username': username},
      );
    } catch (e) {
      log(e.toString(), name: 'error on deleteUser');
      rethrow;
    }
  }

  Future<void> resetUserPassword({required String username}) async {
    try {
      await HttpClient().post(
        'http://carewhyapp.kinghost.net/auth/users-password',
        queryParameters: {'username': username},
      );
    } catch (e) {
      log(e.toString(), name: 'error on resetUserPassword');
      rethrow;
    }
  }
}
