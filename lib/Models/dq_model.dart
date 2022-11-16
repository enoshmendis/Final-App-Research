class DQModel {
  int? id = null;
  String question;
  String type; //number or select
  List<String> answers;

  DQModel({
    this.id,
    required this.type,
    required this.question,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'type': type,
      'nott': answers,
    };
  }
}
