class ANXQTestModel {
  int? id = null;
  String question;
  int never;
  int sometimes;
  int often;
  int always;

  ANXQTestModel({
    this.id,
    required this.question,
    required this.never,
    required this.sometimes,
    required this.often,
    required this.always, 
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