import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mlvapp/Models/anxq_model.dart';
import 'package:mlvapp/Models/depq_model.dart';
import 'package:mlvapp/Models/dq_model.dart';
import 'package:mlvapp/Models/gse_model.dart';
import 'package:mlvapp/Models/pa_model.dart';
import 'package:mlvapp/Models/streq_model.dart';
import 'package:mlvapp/Models/test_model.dart';
import 'package:mlvapp/provider/authentication_provider.dart';
import 'package:mlvapp/services/database.dart';
import 'package:mlvapp/services/firestore_database.dart';

class TestPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late FirebaseDatabase _database;

  int activeStep = 0; // Initial step set to 5.
  int upperBound = 3; // upperBound MUST BE total number of icons minus 1.
  List<String> demographicAnswers = List.filled(10, "");
  List<String> personalityAnswers = List.filled(10, "");
  List<String> gseAnswers = List.filled(10, "");
  List<String> depressionAnswers = List.filled(14, "");
  List<String> anxietyAnswers = List.filled(14, "");
  List<String> stressAnswers = List.filled(14, "");

  String? demogResult;
  String? paResult;
  String? gseResult;
  String? depResult;
  String? anxResult;
  String? strResult;

  List<PATestModel> paList = [];
  List<GSETestModel> gseList = [];
  List<DepQTestModel> depList = [];
  List<ANXQTestModel> anxList = [];
  List<StrQTestModel> strList = [];
  List<DQModel> demogList = [
    DQModel(
        id: 1,
        question: "How much education have you completed?",
        type: "select",
        answers: ["High school", "Less than high school", "University degree", "Graduate degree"]),
    DQModel(id: 2, question: "What is your gender?", type: "select", answers: ["Female", "Male", "Other"]),
    DQModel(id: 3, question: "Is English your native language?", type: "select", answers: ["No", "Yes"]),
    DQModel(id: 4, question: "Which one do you mostly use?", type: "select", answers: ["phone", "laptop or desktop"]),
    DQModel(id: 5, question: "How many years old are you?", type: "number", answers: []),
    DQModel(
        id: 6,
        question: "Are you left handed or right handed or both?",
        type: "select",
        answers: ["Right", "Left", "Both"]),
    DQModel(id: 7, question: "What is your religion?", type: "select", answers: [
      "Christian (Catholic)",
      "Christian (Protestant)",
      "Christian (Mormon)",
      "Christian (Other)",
      "Muslim",
      "Atheist",
      "Agnostic",
      "Hindu",
      "Buddhist",
      "Sikh",
      "Jewish",
      "Other"
    ]),
    DQModel(
        id: 8,
        question: "What is your sexual orientation?",
        type: "select",
        answers: ["Heterosexual", "Homosexual", "Bisexual", "Asexual", "Other"]),
    DQModel(
        id: 9,
        question: "What is your marital status?",
        type: "select",
        answers: ["Never married", "Previously married", "Currently married"]),
    DQModel(
        id: 9,
        question: "Which category you belong in your family?",
        type: "select",
        answers: ["Teenager", "Adults", "Elder Adults", "Older People"]),
  ];

  TestPageProvider(this._auth) {
    _database = GetIt.instance.get<FirebaseDatabase>();

    getGSEList();
    getDEPList();
    getANXList();
    getSTRList();
    getPAList();
  }

  void setActiveStep(step) {
    activeStep = step;
    notifyListeners();
  }

  void getGSEList() async {
    gseList = await DatabaseService().getAllGseTests();
    notifyListeners();
  }

  void getDEPList() async {
    depList = await DatabaseService().getAllDepQ();
    notifyListeners();
  }

  void getANXList() async {
    anxList = await DatabaseService().getAllANXQ();
    notifyListeners();
  }

  void getSTRList() async {
    strList = await DatabaseService().getAllStrQ();
    notifyListeners();
  }

  void getPAList() async {
    paList = await DatabaseService().getAllPA();
    notifyListeners();
  }

  Future<bool> insertTestAnswers() async {
    try {
      Test _test = Test(
        uid: _auth.user.uid,
        timestamp: DateTime.now(),
        gseTest: getAnswerList(gseList, gseAnswers),
        dqaTest: getAnswerList(demogList, demographicAnswers),
        paTest: getAnswerList(paList, personalityAnswers),
        deppressionTest: getAnswerList(depList, depressionAnswers),
        anxietyTest: getAnswerList(anxList, anxietyAnswers),
        stressTest: getAnswerList(strList, stressAnswers),
        anxietyResult: anxResult ?? "",
        deppressionResult: depResult ?? "",
        stressResult: strResult ?? "",
        gseResult: gseResult ?? "",
        dqaResult: demogResult ?? "",
        paResult: paResult ?? "",
      );

      var response = await _database.addTest(_test);
      if (kDebugMode) {
        print(response);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  List<Map<String, String>> getAnswerList(List questions, List answers) {
    List<Map<String, String>> tempList = [];

    if (answers.isNotEmpty) {
      for (int i = 0; i < questions.length; i++) {
        Map<String, String> ans = {
          "question": questions[i].question,
          "answer": answers[i],
        };

        tempList.add(ans);
      }
    }

    return tempList;
  }
}
