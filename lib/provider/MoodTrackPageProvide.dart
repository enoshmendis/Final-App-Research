import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mlvapp/Models/mood_record.dart';
import 'package:mlvapp/services/firestore_database.dart';

class MoodTrackerPageProvider extends ChangeNotifier {
  late FirebaseDatabase _database;

  int activeStep = 0;
  int upperBound = 4; // upperBound MUST BE total number of icons minus 1.

  bool loading = true;

  late String _userId;

  List<MoodRecord> moodRecords = [];
  MoodRecord? lastRecord;

  MoodTrackerPageProvider(String userId) {
    _userId = userId;
    _database = GetIt.instance.get<FirebaseDatabase>();

    getMoodRecordsForMonth(DateTime.now()).then((_) {
      getLastMoodRecord();
    });
  }

  void setActiveStep(step) {
    activeStep = step;
    notifyListeners();
  }

  Future<bool> insertMoodRecord(MoodRecord _record) async {
    try {
      var response = await _database.addMoodRecord(_record);
      print(response);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<void> getMoodRecordsForMonth(DateTime month) async {
    moodRecords.clear();

    loading = true;
    notifyListeners();

    DateTime from = DateTime(month.year, month.month, 1);
    DateTime to = DateTime(month.year, month.month + 1, 1);

    await _database.getMoodRecords(_userId, from, to).then((_snapshot) {
      moodRecords = _snapshot.docs.map((_doc) {
        Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;

        MoodRecord _record = MoodRecord.fromJSON(_data);

        return _record;
      }).toList();

      loading = false;
      notifyListeners();
    });
  }

  Future<void> getLastMoodRecord() async {
    loading = true;
    notifyListeners();

    await _database.getLastMoodRecord(_userId).then((_snapshot) {
      if (_snapshot.docs.isNotEmpty) {
        Map<String, dynamic> _data = _snapshot.docs.first.data() as Map<String, dynamic>;

        lastRecord = MoodRecord.fromJSON(_data);
        loading = false;
        notifyListeners();
      } else {
        loading = false;
        notifyListeners();
      }
    });
  }
}
