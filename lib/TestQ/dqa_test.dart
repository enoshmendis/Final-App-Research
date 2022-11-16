import 'dart:ffi';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlvapp/Member2/doctor_list.dart';
import 'package:mlvapp/Models/dq_model.dart';
import 'package:mlvapp/Models/dqa_model.dart';
import 'package:mlvapp/services/database.dart';
import 'package:mlvapp/home.dart';
import 'package:mlvapp/provider/TestPageProvider.dart';
import 'package:http/http.dart' as http;

// enum DassScore { never, sometimes, often, always }

class DQATestPage extends StatefulWidget {
  TestPageProvider testPageProvider;

  DQATestPage({
    Key? key,
    required this.testPageProvider,
  }) : super(key: key);

  @override
  State<DQATestPage> createState() => _DQATestPageState();
}

class _DQATestPageState extends State<DQATestPage> {
  ScrollController _scrollController = ScrollController();
  late TestPageProvider _testPageProvider;
  late double _deviceHeight;
  late double _deviceWidth;

  List<DQModel> list = [];
  //List<String?> answers = List.filled(10, "");
  // DassScore? _score = DassScore.never;
  int _totalScore = 0;

  void getData() async {
    //await DatabaseService().initDatabase();

    list = [
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

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //DatabaseService().initDatabase();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _testPageProvider = widget.testPageProvider;

    return Scaffold(
      body: DraggableScrollbar.rrect(
        alwaysVisibleScrollThumb: true,
        backgroundColor: Colors.black,
        controller: _scrollController,
        child: ListView.builder(
            addAutomaticKeepAlives: true,
            controller: _scrollController,
            itemCount: list.length,
            itemBuilder: (context, i) {
              return _gseTestBuild(i);
            }),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
        height: 40,
        color: Colors.blueGrey,
        child: InkWell(
          onTap: () async {
            if (_testPageProvider.demographicAnswers.contains("")) {
              showError("Please answer all questions");
            } else {
              showDialogBoxSuccess("Please answer personality assessment questions next");
            }
          },
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: const <Widget>[
                Text('Submit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gseTestBuild(index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      list[index].question,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          Container(
              child: list[index].type == "select"
                  ? DropdownButton(
                      items: list[index].answers.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      hint: Text("Select Answer"),
                      value: _testPageProvider.demographicAnswers[index] == ""
                          ? null
                          : _testPageProvider.demographicAnswers[index],
                      onChanged: ((String? value) {
                        setState(() {
                          _testPageProvider.demographicAnswers[index] = value ?? "";
                        });
                      }),
                    )
                  : Container(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: _testPageProvider.demographicAnswers[index],
                        onChanged: ((String? value) {
                          setState(() {
                            _testPageProvider.demographicAnswers[index] = value ?? "";
                          });
                        }),
                        onSaved: ((String? newValue) {
                          setState(() {
                            _testPageProvider.demographicAnswers[index] = newValue ?? "";
                          });
                        }),
                      ),
                    )),
        ],
      ),
    );
  }

  showError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR!'),
            content: Text(message),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  showDialogBoxSuccess(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Demographics Assessment Completed'),
            content: Text(message),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'CANCEL',
                ),
              ),
              // Submit button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _testPageProvider.setActiveStep(2);
                },
                child: const Text(
                  'OK',
                ),
              ),
            ],
          );
        });
  }
}
