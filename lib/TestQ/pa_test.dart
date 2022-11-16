import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mlvapp/Member2/doctor_list.dart';
import 'package:mlvapp/Models/pa_model.dart';
import 'package:mlvapp/services/database.dart';
import 'package:mlvapp/home.dart';
import 'package:mlvapp/provider/TestPageProvider.dart';
import 'package:http/http.dart' as http;

class PATest extends StatefulWidget {
  TestPageProvider testPageProvider;

  PATest({
    Key? key,
    required this.testPageProvider,
  }) : super(key: key);
  @override
  State<PATest> createState() => _PATestState();
}

class _PATestState extends State<PATest> {
  ScrollController _scrollController = ScrollController();
  late TestPageProvider _testPageProvider;
  late double _deviceHeight;
  late double _deviceWidth;

  List<PATestModel> list = [];
  // DassScore? _score = DassScore.never;
  int _totalScore = 0;

  void getData() async {
    //list = await DatabaseService().getAllPA();
    //setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // DatabaseService().initDatabase();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _testPageProvider = widget.testPageProvider;
    list = _testPageProvider.paList;

    return Scaffold(
      // appBar: AppBar(
      //   title:const Text("Mental Help App"),
      //   backgroundColor: Colors.green,
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                    ),
                    width: 1,
                  ),
                ),
                // Flexible(
                //   child: Column(
                //     children: <Widget>[
                //       Container(
                //           padding: const EdgeInsets.only(top: 30),
                //           child: const Text("                                            ")),
                //     ],
                //   ),
                // ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text("Disagree Strongly",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text("Disagree Moderately",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text("Disagree a little",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text("Neither agree or disagree",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text("Agree a little",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text("Agree Strongly",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(indent: 5, endIndent: 5, thickness: 2, color: Colors.grey),
          Container(
            height: _deviceHeight * 0.47,
            child: DraggableScrollbar.rrect(
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
          ),
        ],
      ),

      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
        height: 40,
        color: Colors.blueGrey,
        child: InkWell(
          onTap: () async {
            if (_testPageProvider.personalityAnswers.contains("")) {
              showError("Please answer all questions");
            } else {
              showDialogBoxSuccess(
                  "Please take one of the following tests next.\n• Depression Test\n• Anxiety Test\n• Stress Test");
            }
          },
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: const <Widget>[
                // Icon(
                //   Icons.close,
                //   color: Theme.of(context).accentColor,
                // ),
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
      margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 1,
          ),
          Container(
              padding: const EdgeInsets.only(top: 15), child: Text(list[index].question, textAlign: TextAlign.left)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: Checkbox(
                        value: _testPageProvider.paList[index].disagree_strongly == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.personalityAnswers[index] = "Disagree strongly"
                              : _testPageProvider.personalityAnswers[index] = "";
                          setState(() {
                            _testPageProvider.paList[index].disagree_moderately = 0;
                            _testPageProvider.paList[index].disagree_alittle = 0;
                            _testPageProvider.paList[index].neither_agree_or_disagree = 0;
                            _testPageProvider.paList[index].agree_a_little = 0;
                            _testPageProvider.paList[index].agree_strongly = 0;
                            _testPageProvider.paList[index].disagree_strongly = value == true ? 1 : 0;
                            _totalScore += 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: Checkbox(
                        value: _testPageProvider.paList[index].disagree_moderately == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.personalityAnswers[index] = "Disagree moderately"
                              : _testPageProvider.personalityAnswers[index] = "";
                          setState(() {
                            _testPageProvider.paList[index].disagree_strongly = 0;
                            _testPageProvider.paList[index].disagree_alittle = 0;
                            _testPageProvider.paList[index].neither_agree_or_disagree = 0;
                            _testPageProvider.paList[index].agree_a_little = 0;
                            _testPageProvider.paList[index].agree_strongly = 0;
                            _testPageProvider.paList[index].disagree_moderately = value == true ? 1 : 0;
                            _totalScore += 2;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: Checkbox(
                        value: _testPageProvider.paList[index].disagree_alittle == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.personalityAnswers[index] = "Disagree a little"
                              : _testPageProvider.personalityAnswers[index] = "";
                          setState(() {
                            _testPageProvider.paList[index].disagree_strongly = 0;
                            _testPageProvider.paList[index].disagree_moderately = 0;
                            _testPageProvider.paList[index].neither_agree_or_disagree = 0;
                            _testPageProvider.paList[index].agree_a_little = 0;
                            _testPageProvider.paList[index].agree_strongly = 0;
                            _testPageProvider.paList[index].disagree_alittle = value == true ? 1 : 0;
                            _totalScore += 3;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: Checkbox(
                        value: _testPageProvider.paList[index].neither_agree_or_disagree == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.personalityAnswers[index] = "Neither agree nor disagree"
                              : _testPageProvider.personalityAnswers[index] = "";

                          setState(() {
                            _testPageProvider.paList[index].disagree_moderately = 0;
                            _testPageProvider.paList[index].disagree_alittle = 0;
                            _testPageProvider.paList[index].disagree_strongly = 0;
                            _testPageProvider.paList[index].agree_a_little = 0;
                            _testPageProvider.paList[index].agree_strongly = 0;
                            _testPageProvider.paList[index].neither_agree_or_disagree = value == true ? 1 : 0;
                            _totalScore += 4;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: Checkbox(
                        value: _testPageProvider.paList[index].agree_a_little == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.personalityAnswers[index] = "Agree a little"
                              : _testPageProvider.personalityAnswers[index] = "";

                          setState(() {
                            _testPageProvider.paList[index].disagree_moderately = 0;
                            _testPageProvider.paList[index].disagree_alittle = 0;
                            _testPageProvider.paList[index].neither_agree_or_disagree = 0;
                            _testPageProvider.paList[index].disagree_strongly = 0;
                            _testPageProvider.paList[index].agree_strongly = 0;
                            _testPageProvider.paList[index].agree_a_little = value == true ? 1 : 0;
                            _totalScore += 4;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: Checkbox(
                        value: _testPageProvider.paList[index].agree_strongly == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.personalityAnswers[index] = "Agree strongly"
                              : _testPageProvider.personalityAnswers[index] = "";

                          setState(() {
                            _testPageProvider.paList[index].disagree_moderately = 0;
                            _testPageProvider.paList[index].disagree_alittle = 0;
                            _testPageProvider.paList[index].neither_agree_or_disagree = 0;
                            _testPageProvider.paList[index].agree_a_little = 0;
                            _testPageProvider.paList[index].disagree_strongly = 0;
                            _testPageProvider.paList[index].agree_strongly = value == true ? 1 : 0;
                            _totalScore += 4;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  showDialogBoxSuccess(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Personality Assessment Completed'),
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
                  _testPageProvider.setActiveStep(3);
                },
                child: const Text(
                  'OK',
                ),
              ),
            ],
          );
        });
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
}
