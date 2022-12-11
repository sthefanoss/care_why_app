import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/lup.dart';
import '../services/http_client.dart';

class LupsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final _lups = <Lup>[];

  List<Lup> get lups => [..._lups];

  Future<void> getLupsFromApi() async {
    final response = await HttpClient().get(
      'http://carewhyapp.kinghost.net/lups',
    );
    _lups.clear();
    _lups.addAll((response.data['lups'] as Iterable).map((e) {
      return Lup.fromMap(e);
    }));
    notifyListeners();
  }

  Future<void> createLup({
    required String title,
    required String description,
    // required List<int> collaboratorIds,
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
    _lups.add(Lup.fromMap(response.data));
    notifyListeners();
  }
}
