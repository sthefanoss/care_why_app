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
    print(_colleges);
    notifyListeners();
  }
}
