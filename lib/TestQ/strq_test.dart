import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mlvapp/Member2/doctor_list.dart';
import 'package:mlvapp/Models/anxq_model.dart';
import 'package:mlvapp/Models/dass_model.dart';
import 'package:mlvapp/Models/streq_model.dart';
import 'package:mlvapp/services/database.dart';
import 'package:mlvapp/utility/consts.dart';
import 'package:mlvapp/home.dart';
import 'package:mlvapp/provider/TestPageProvider.dart';
import 'package:http/http.dart' as http;

class STRQTest extends StatefulWidget {
  TestPageProvider testPageProvider;

  STRQTest({
    Key? key,
    required this.testPageProvider,
  }) : super(key: key);

  @override
  State<STRQTest> createState() => _STRQTestState();
}

class _STRQTestState extends State<STRQTest> {
  ScrollController _scrollController = ScrollController();
  late TestPageProvider _testPageProvider;
  late double _deviceHeight;
  late double _deviceWidth;
  String doctor = '';
  bool loading = false;

  List<StrQTestModel> list = [];
  // DassScore? _score = DassScore.never;
  int _totalScore = 0;

  void getData() async {
    //list = await DatabaseService().getAllStrQ();
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
    list = _testPageProvider.strList;
    return Scaffold(
      // appBar: AppBar(
      //   title:const Text("Mental Help App"),
      //   backgroundColor: Colors.green,
      // ),
      body: loading
          ? const SpinKitChasingDots(
              color: Colors.blue,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.03),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: _deviceWidth * 0.25,
                                padding: const EdgeInsets.only(top: 10),
                                child: const Text("Never",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: _deviceWidth * 0.25,
                                padding: const EdgeInsets.only(top: 10),
                                child: const Text("Sometimes",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: _deviceWidth * 0.25,
                                padding: const EdgeInsets.only(top: 10),
                                child: const Text("Often",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: _deviceWidth * 0.25,
                                padding: const EdgeInsets.only(top: 10),
                                child: const Text("Almost Always",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(indent: 5, endIndent: 5, thickness: 2, color: Colors.grey),
                Container(
                  height: _deviceHeight * 0.52,
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
        height: 40,
        color: Colors.blueGrey,
        child: InkWell(
          onTap: () async {
            if (_testPageProvider.demographicAnswers.contains("")) {
              showError("Please answer demographic questions and submit stress questions.");
              _testPageProvider.setActiveStep(0);
            } else if (_testPageProvider.personalityAnswers.contains("")) {
              showError("Please answer personality questions and submit stress questions.");
              _testPageProvider.setActiveStep(1);
            } else if (_testPageProvider.stressAnswers.contains("") ||
                _testPageProvider.demographicAnswers.contains("")) {
              showError("Please answer all questions");
            } else {
              String answers = _testPageProvider.stressAnswers.join(", ");

              List<String> demogAns = _testPageProvider.demographicAnswers.toList();
              demogAns.removeAt(4);
              answers += ", " + _testPageProvider.personalityAnswers.join(", ");
              answers += ", " + demogAns.join(", ");

              print(answers);

              setState(() {
                loading = true;
              });

              var url = Uri.parse(testUrl + "stressQ");
              var map = new Map<String, String>();

              map['stress'] = answers;

              var response = await http.post(url, body: map);
              print(response.statusCode);
              print(response.body);

              setState(() {
                loading = false;
              });

              if (response.statusCode == 200) {
                String result = response.body;
                _testPageProvider.strResult = result;
                //String doctor = "";
                if (result.toLowerCase().contains("normal")) {
                  showDialogBoxNormal('The result indicates that your symptoms are subjective and $result.');
                } else {
                  if (result.toLowerCase().contains("severe")) {
                    doctor = "Psychiatric";
                    showDialogBoxSuccess(
                        'The result indicates that your symptoms are subjective and $result.\n\nWe suggest you to consult a $doctor');
                  } else if (result.toLowerCase().contains("moderate")) {
                    doctor = "Psychotherapist";
                    showDialogBoxSuccess(
                        'The result indicates that your symptoms are subjective and $result.\n\nWe suggest you to consult a $doctor');
                  } else if (result.toLowerCase().contains("low") || result.toLowerCase().contains("mild")) {
                    doctor = "Counselor";
                    showDialogBoxSuccess(
                        'The result indicates that your symptoms are subjective and $result.\n\nWe suggest you to consult a $doctor');
                  } else {
                    showDialogBoxNormal(
                        'The result indicates that your symptoms are subjective and $result.\n\nPlease go to home screen to explore about your mental health.');
                  }
                }
              } else {
                showError("Could not retrieve results. Please try again.");
              }
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
      margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(top: 15), child: Text(list[index].question, textAlign: TextAlign.left)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Flexible(
              //   child: Container(
              //     width: 1,
              //   ),
              // ),
              // Flexible(
              //   child: Column(
              //     children: <Widget>[
              //       Container(
              //           padding: const EdgeInsets.only(top: 15),
              //           child: Text(list[index].question, textAlign: TextAlign.left)),
              //     ],
              //   ),
              // ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: _deviceWidth * 0.25,
                      padding: const EdgeInsets.only(top: 15),
                      child: Checkbox(
                        value: _testPageProvider.strList[index].never == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.stressAnswers[index] = "NEVER"
                              : _testPageProvider.stressAnswers[index] = "";
                          setState(() {
                            _testPageProvider.strList[index].sometimes = 0;
                            _testPageProvider.strList[index].often = 0;
                            _testPageProvider.strList[index].always = 0;
                            _testPageProvider.strList[index].never = value == true ? 1 : 0;
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
                      width: _deviceWidth * 0.25,
                      padding: const EdgeInsets.only(top: 15),
                      child: Checkbox(
                        value: _testPageProvider.strList[index].sometimes == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.stressAnswers[index] = "SOMETIMES"
                              : _testPageProvider.stressAnswers[index] = "";
                          setState(() {
                            _testPageProvider.strList[index].never = 0;
                            _testPageProvider.strList[index].often = 0;
                            _testPageProvider.strList[index].always = 0;
                            _testPageProvider.strList[index].sometimes = value == true ? 1 : 0;
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
                      width: _deviceWidth * 0.25,
                      padding: const EdgeInsets.only(top: 15),
                      child: Checkbox(
                        value: _testPageProvider.strList[index].often == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.stressAnswers[index] = "OFTEN"
                              : _testPageProvider.stressAnswers[index] = "";

                          setState(() {
                            _testPageProvider.strList[index].sometimes = 0;
                            _testPageProvider.strList[index].never = 0;
                            _testPageProvider.strList[index].always = 0;
                            _testPageProvider.strList[index].often = value == true ? 1 : 0;
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
                      width: _deviceWidth * 0.25,
                      padding: const EdgeInsets.only(top: 15),
                      child: Checkbox(
                        value: _testPageProvider.strList[index].always == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.stressAnswers[index] = "ALMOST ALWAYS"
                              : _testPageProvider.stressAnswers[index] = "";
                          setState(() {
                            _testPageProvider.strList[index].sometimes = 0;
                            _testPageProvider.strList[index].often = 0;
                            _testPageProvider.strList[index].never = 0;
                            _testPageProvider.strList[index].always = value == true ? 1 : 0;
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
            title: Text('Stress Test Completed'),
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
                  _testPageProvider.insertTestAnswers();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DoctorsList(
                              doctorType: doctor,
                            )),
                  );
                },
                child: const Text(
                  'OK',
                ),
              ),
            ],
          );
        });
  }

  showDialogBoxNormal(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Stress Test Completed'),
            content: Text(message),
            actions: <Widget>[
              // Submit button
              ElevatedButton(
                onPressed: () {
                  _testPageProvider.insertTestAnswers();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
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
