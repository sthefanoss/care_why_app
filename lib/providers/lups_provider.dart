import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/lup.dart';
import '../models/user.dart';
import '../services/http_client.dart';

class LupsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final _lups = <Lup>[];
  final _users = <int, User>{};

  List<Lup> get lups => [..._lups];

  User getUserById(int id) => _users[id]!;

  Future<void> getLupsFromApi() async {
    final response = await HttpClient().get(
      'http://carewhyapp.kinghost.net/lups',
    );
    log(response.toString());
    _lups.clear();
    _lups.addAll((response.data['lups'] as Iterable).map((e) {
      return Lup.fromMap(e);
    }));
    _users.clear();
    _users.addEntries(
      (response.data['users'] as Iterable).map((map) => MapEntry(map['id'], User.fromMap(map))),
    );
    notifyListeners();
  }

  Future<void> createLup({
    required String title,
    required String description,
    required Uint8List image,
  }) async {
    final data = FormData();
    data.fields.add(MapEntry('title', title));
    data.fields.add(MapEntry('description', description));
    data.files.add(MapEntry(
      'image',
      MultipartFile.fromBytes(image, filename: 'image'),
    ));

    final response = await HttpClient().post(
      'http://carewhyapp.kinghost.net/lups',
      data: data,
      options: Options(contentType: 'multipart/form-data'),
    );
    final lup = Lup.fromMap(response.data['lup']);
    final author = User.fromMap(response.data['author']);
    _users[author.id] = author;
    _lups.insert(0, lup);
    notifyListeners();
  }
}
