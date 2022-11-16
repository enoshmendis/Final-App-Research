class MoodRecord {
  final String uid;
  final String mood;
  final String activity;
  final String feeling;
  final String sleepStart;
  final String sleepEnd;
  final String note;
  final DateTime timestamp;

  MoodRecord({
    required this.uid,
    required this.mood,
    required this.activity,
    required this.feeling,
    required this.sleepStart,
    required this.sleepEnd,
    required this.note,
    required this.timestamp,
  });

  factory MoodRecord.fromJSON(Map<String, dynamic> _json) {
    return MoodRecord(
      uid: _json["uid"],
      mood: _json["mood"],
      activity: _json["activity"],
      feeling: _json["feeling"],
      sleepStart: _json["sleepStart"],
      sleepEnd: _json["sleepEnd"],
      note: _json["note"],
      timestamp: _json["timestamp"].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'mood': mood,
      'activity': activity,
      'feeling': feeling,
      'sleepStart': sleepStart,
      'sleepEnd': sleepEnd,
      'note': note,
      'timestamp': timestamp,
    };
  }
}
