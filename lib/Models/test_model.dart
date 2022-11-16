class Test {
  final String uid;
  final DateTime timestamp;
  final List gseTest;
  final List dqaTest;
  final List paTest;
  final List deppressionTest;
  final List anxietyTest;
  final List stressTest;
  final String gseResult;
  final String dqaResult;
  final String paResult;
  final String deppressionResult;
  final String anxietyResult;
  final String stressResult;

  Test({
    required this.uid,
    required this.timestamp,
    required this.gseTest,
    required this.dqaTest,
    required this.paTest,
    required this.deppressionTest,
    required this.anxietyTest,
    required this.stressTest,
    required this.gseResult,
    required this.dqaResult,
    required this.paResult,
    required this.deppressionResult,
    required this.anxietyResult,
    required this.stressResult,
  });

  factory Test.fromJSON(Map<String, dynamic> _json) {
    return Test(
      uid: _json["uid"],
      timestamp: _json["timestamp"].toDate(),
      gseTest: _json["gseTest"],
      dqaTest: _json["dqaTest"],
      paTest: _json["paTest"],
      deppressionTest: _json["deppressionTest"],
      anxietyTest: _json["anxietyTest"],
      stressTest: _json["stressTest"],
      gseResult: _json["gseResult"],
      dqaResult: _json["dqaResult"],
      paResult: _json["paResult"],
      deppressionResult: _json["deppressionResult"],
      anxietyResult: _json["anxietyResult"],
      stressResult: _json["stressResult"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "timestamp": timestamp,
      "gseTest": gseTest,
      "dqaTest": dqaTest,
      "paTest": paTest,
      "deppressionTest": deppressionTest,
      "anxietyTest": anxietyTest,
      "stressTest": stressTest,
      "gseResult": gseResult,
      "dqaResult": dqaResult,
      "paResult": paResult,
      "deppressionResult": deppressionResult,
      "anxietyResult": anxietyResult,
      "stressResult": stressResult,
    };
  }
}
