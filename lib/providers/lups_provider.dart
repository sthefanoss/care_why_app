import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/lup.dart';
import '../services/http_client.dart';

class LupsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final _lups = <LUP>[];

  List<LUP> get lups => [..._lups];

  Future<void> getLupsFromApi() async {
    final response = await HttpClient().get(
      'http://carewhyapp.kinghost.net/lups',
    );
    print(response.data);
    final data = response.data as List;

    _lups.clear();
    _lups.addAll(data.map((e) {
      print(e);
      return LUP.fromMap(e);
    }));
    notifyListeners();
  }

  Future<void> createLup({
    required String title,
    required String description,
    required List<int> collaboratorIds,
    required Uint8List image,
  }) async {
    final data = FormData();

    data.files.add(MapEntry(
      'image',
      MultipartFile.fromBytes(image, filename: 'image'),
    ));

    final response = await HttpClient().post(
      'http://carewhyapp.kinghost.net/lups',
      queryParameters: {
        'title': title,
        'description': description,
        'collaboratorIds': collaboratorIds,
      },
      data: data,
      options: Options(contentType: 'multipart/form-data'),
    );
    if (kDebugMode) {
      print(response.data);
    }
    _lups.add(LUP.fromMap(response.data));
    notifyListeners();
  }
}
