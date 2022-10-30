import 'dart:developer';

import 'package:care_why_app/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../services/local_storage.dart';
import '../services/http_client.dart';

class AuthProvider with ChangeNotifier, DiagnosticableTreeMixin {
  User? _authUser;

  User? get authUser => _authUser;

  bool get hasAuth => _authUser != null;

  Future<void> updateProfile({
    required String nickname,
    required Uint8List? image,
  }) async {
    try {
      final formData = FormData();
      if (image != null) {
        formData.files.add(
          MapEntry(
            'image',
            MultipartFile.fromBytes(
              image,
              filename: 'image.jpg',
            ),
          ),
        );
      }

      final response = await HttpClient().post(
        'http://carewhyapp.kinghost.net/profile',
        queryParameters: {'nickname': nickname},
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      _authUser = User.fromMap(response.data['user']);
      notifyListeners();
    } catch (e) {
      log(e.toString(), name: 'error on updateProfile');
      rethrow;
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await HttpClient().get(
        'http://carewhyapp.kinghost.net/login',
        queryParameters: {'username': username, 'password': password},
      );
      final token = response.data['token'];
      _authUser = User.fromMap(response.data['user']);
      LocalStorage.set(LocalStorageKey.token, token);
      HttpClient.setToken(token);
      notifyListeners();
    } catch (e) {
      log(e.toString(), name: 'error on login');
      rethrow;
    }
  }

  Future<void> signup({
    required String username,
    required String password,
  }) async {
    try {
      final response = await HttpClient().post(
        'http://carewhyapp.kinghost.net/signup',
        queryParameters: {'username': username, 'password': password},
      );
      final token = response.data['token'];
      _authUser = User.fromMap(response.data['user']);
      LocalStorage.set(LocalStorageKey.token, token);
      HttpClient.setToken(token);
      notifyListeners();
    } catch (e) {
      log(e.toString(), name: 'error on signup');
      rethrow;
    }
  }

  Future<void> logout() async {
    _authUser = null;
    await LocalStorage.delete(LocalStorageKey.token);
    HttpClient.setToken(null);
    notifyListeners();
  }

  Future<void> getUserFromToken() async {
    final authToken = await LocalStorage.get(LocalStorageKey.token);
    if (authToken == null) {
      return;
    }

    try {
      HttpClient.setToken(authToken);
      final response = await HttpClient().get(
        'http://carewhyapp.kinghost.net/user-data',
      );
      _authUser = User.fromMap(response.data);
      notifyListeners();
    } catch (e) {
      HttpClient.setToken(null);
      await LocalStorage.delete(LocalStorageKey.token);
      log(e.toString(), name: 'error on getUserFromToken');
      rethrow;
    }
  }
}
