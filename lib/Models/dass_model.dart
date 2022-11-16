class DASSTestModel {
  int? id = null;
  String question;
  int never;
  int sometimes;
  int often;
  int always;

  DASSTestModel({
    this.id,
    required this.question,
    required this.never,
    required this.sometimes,
    required this.often,
    required this.always, required int moderately,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'never': never,
      'sometimes': sometimes,
      'often': often,
      'always': always,
    };
  }
}