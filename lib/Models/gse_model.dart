class GSETestModel {
  int? id = null;
  String question;
  int nott;
  int hardly;
  int moderately;
  int exactly;

  GSETestModel({
    this.id,
    required this.question,
    required this.nott,
    required this.hardly,
    required this.moderately,
    required this.exactly,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'nott': nott,
      'hardly': hardly,
      'moderately': moderately,
      'exactly': exactly,
    };
  }
}