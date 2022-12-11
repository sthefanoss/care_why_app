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
    final data = response.data['users'] as Iterable;
    _colleges.clear();
    _colleges.addAll(data.map((e) => User.fromMap(e)));
    _colleges.sort((a, b) => (a.nickname ?? 'z') //
        .toLowerCase()
        .compareTo((b.nickname ?? 'z')));
    notifyListeners();
  }

  Future<void> makeUser({required String username}) async {
    try {
      await HttpClient().post(
        'http://carewhyapp.kinghost.net/admin/user',
        data: {'username': username},
      );
    } catch (e) {
      log(e.toString(), name: 'error on makeUser');
      rethrow;
    }
  }

  Future<void> deleteUser({required String username}) async {
    try {
      await HttpClient().delete(
        'http://carewhyapp.kinghost.net/admin/user',
        data: {'username': username},
      );
    } catch (e) {
      log(e.toString(), name: 'error on deleteUser');
      rethrow;
    }
  }

  Future<void> managerToggle({required String username, required bool value}) async {
    try {
      await HttpClient().post(
        'http://carewhyapp.kinghost.net/admin/set-manager',
        data: {'username': username, 'isManager': value},
      );
    } catch (e) {
      log(e.toString(), name: 'error on resetUserPassword');
      rethrow;
    }
  }
}
