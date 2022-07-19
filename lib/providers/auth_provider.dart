import 'dart:typed_data';

import 'package:care_why_app/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../services/local_storage.dart';
import '../services/http_client.dart';

class AuthProvider with ChangeNotifier, DiagnosticableTreeMixin {
  User? _authUser;

  User? get authUser => _authUser;

  bool get hasAuth => _authUser != null;

  Future<void> signUp({required String name, required Uint8List image}) async {
    final data = FormData();
    data.files.add(MapEntry(
      'image',
      MultipartFile.fromBytes(image, filename: 'image.jpg'),
    ));

    final response = await HttpClient().post(
      'http://carewhyapp.kinghost.net/users',
      queryParameters: {'name': name},
      data: data,
      options: Options(contentType: 'multipart/form-data'),
    );
    _authUser = User.fromMap(response.data);
    await _saveUserInStorage();
    HttpClient.setToken(_authUser!.id.toString());
    notifyListeners();
  }

  Future<void> logout() async {
    _authUser = null;
    await LocalStorage().delete('user');
    HttpClient.setToken(null);
    notifyListeners();
  }

  Future<bool> checkUserData() async {
    final localUserData = await _getUserFromStorage();
    if (localUserData == null) {
      return false;
    }

    try {
      final remoteUserData = await HttpClient().get(
        'http://carewhyapp.kinghost.net/users/${localUserData.id}',
      );
      _authUser = User.fromMap(remoteUserData.data);
      _saveUserInStorage();
      HttpClient.setToken(_authUser!.id.toString());
      notifyListeners();
      return true;
    } catch (e) {
      await LocalStorage().delete('user');
      return false;
    }
  }

  Future<User?> _getUserFromStorage() {
    return LocalStorage().getObject<User>(
      'user',
      decoder: User.fromMap,
    );
  }

  Future<void> _saveUserInStorage() {
    return LocalStorage().saveObject<User>(
      'user',
      _authUser!,
      encoder: (data) => data.toMap(),
    );
  }
}
