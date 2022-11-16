import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:mlvapp/Models/test_model.dart';
import 'package:mlvapp/services/firestore_database.dart';
import 'package:mlvapp/shared/loading.dart';

class ReportsPageProvider extends ChangeNotifier {
  late FirebaseDatabase _database;

  List<Test> tests = [];
  bool loading = true;

  late String _userId;

  ReportsPageProvider(String userId) {
    _userId = userId;
    _database = GetIt.instance.get<FirebaseDatabase>();

    getTestReports();
  }

  Future<void> getTestReports() async {
    tests.clear();

    loading = true;
    notifyListeners();

    await _database.getTests(_userId).then((_snapshot) {
      tests = _snapshot.docs.map((_doc) {
        Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;

        Test _record = Test.fromJSON(_data);

        return _record;
      }).toList();

      loading = false;
      notifyListeners();
    });
  }
}
