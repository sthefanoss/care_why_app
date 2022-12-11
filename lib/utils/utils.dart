import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Utils {
  static Future<List<String>> getAssetsPaths() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines
    return manifestMap.keys
        .where((String key) => key.contains('assets/'))
        .where((String key) => key.contains('.png'))
        .map((String key) => key.replaceAll('%20', ' '))
        .toList();
  }

  static String formatDateTime(DateTime dateTime, {String format = "HH:mm dd/MM "}) {
    return DateFormat(format).format(dateTime);
  }
}
