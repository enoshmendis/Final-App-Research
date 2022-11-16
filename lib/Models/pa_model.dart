class PATestModel {
  int? id = null;
  String question;
  int disagree_strongly;
  int disagree_moderately;
  int disagree_alittle;
  int neither_agree_or_disagree;
  int agree_a_little;
  int agree_strongly;
  

  PATestModel({
    this.id,
    required this.question,

  required this.disagree_strongly,
  required this.disagree_moderately,
  required this.disagree_alittle,
  required this.neither_agree_or_disagree,
  required this.agree_a_little,
  required this.agree_strongly,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'disagree_strongly': disagree_strongly,
      'disagree_moderately': disagree_moderately,
      'disagree_alittle': disagree_alittle,
      'neither_agree_or_disagree': neither_agree_or_disagree,
      'agree_a_little': agree_a_little,
      'agree_strongly': agree_strongly,
    };
  }
}