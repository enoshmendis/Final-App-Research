import 'package:flutter/material.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mlvapp/Models/gse_model.dart';
import 'package:mlvapp/services/database.dart';
import 'package:mlvapp/utility/consts.dart';
import 'package:mlvapp/home.dart';
import 'package:mlvapp/provider/TestPageProvider.dart';
import 'package:http/http.dart' as http;

// enum GseScore { not, hardly, moderately, exactly }

class GSETestPage extends StatefulWidget {
  TestPageProvider testPageProvider;

  GSETestPage({
    Key? key,
    required this.testPageProvider,
  }) : super(key: key);

  @override
  State<GSETestPage> createState() => _GSETestPageState();
}

class _GSETestPageState extends State<GSETestPage> {
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  late TestPageProvider _testPageProvider;
  late double _deviceHeight;
  late double _deviceWidth;
  bool loading = false;

  List<GSETestModel> list = [];
  // GseScore? _score;
  int _totalScore = 0;
  // bool not = false;

  void getData() async {
    //_testPageProvider.gseList = await DatabaseService().getAllGseTests();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //DatabaseService().initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _testPageProvider = widget.testPageProvider;
    list = _testPageProvider.gseList;
    //getData();
    return Scaffold(
      body: _testPageProvider.gseList.isEmpty
          ? Container()
          : loading
              ? SpinKitChasingDots(
                  color: Colors.blue,
                )
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.01),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    width: _deviceWidth * 0.245,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Text("Not at all true",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    width: _deviceWidth * 0.245,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Text("Moderately true",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    width: _deviceWidth * 0.245,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Text("Hardly true",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    width: _deviceWidth * 0.245,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Text("Exactly true",
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
                      height: _deviceHeight * 0.5,
                      child: DraggableScrollbar.rrect(
                        alwaysVisibleScrollThumb: true,
                        backgroundColor: Colors.black,
                        controller: _scrollController,
                        child: ListView.builder(
                            addAutomaticKeepAlives: true,
                            controller: _scrollController,
                            itemCount: _testPageProvider.gseList.length,
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
            if (_testPageProvider.gseAnswers.contains("")) {
              showError("Please answer all questions.");
            } else {
              String ansData = _testPageProvider.gseAnswers.join(", ");

              var url = Uri.parse(testUrl + "GSEQ");
              var map = new Map<String, String>();

              map['GSE'] = ansData;

              setState(() {
                loading = true;
              });
              var response = await http.post(url, body: map);
              print(response.statusCode);
              print(response.body);

              setState(() {
                loading = false;
              });

              if (response.statusCode == 200) {
                String result = response.body;
                _testPageProvider.gseResult = result;
                if (result == "negative") {
                  showDialogBoxProceed(
                      'The result shows that you have negative feelings from the answers you have select. We suggest you to go through the Depression, Anxiety or Stress scale questionnaire. You may select one question set for now to check the severity.\n\nBefore that please answer demographic questions next');
                } else {
                  showDialogBoxEnd(
                      'The result shows that you have positive feelings. please go to home screen to explore about your mental health.');
                }
              } else {
                showError("Could not retrieve result. pleas try again.");
              }
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
      margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                      width: _deviceWidth * 0.25,
                      padding: const EdgeInsets.only(top: 15),
                      child: Checkbox(
                        value: _testPageProvider.gseList[index].nott == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.gseAnswers[index] = "Not at all true"
                              : _testPageProvider.gseAnswers[index] = "";
                          setState(() {
                            _testPageProvider.gseList[index].moderately = 0;
                            _testPageProvider.gseList[index].hardly = 0;
                            _testPageProvider.gseList[index].exactly = 0;
                            _testPageProvider.gseList[index].nott = value == true ? 1 : 0;
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
                        value: _testPageProvider.gseList[index].moderately == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.gseAnswers[index] = "Moderately true"
                              : _testPageProvider.gseAnswers[index] = "";
                          setState(() {
                            _testPageProvider.gseList[index].nott = 0;
                            _testPageProvider.gseList[index].hardly = 0;
                            _testPageProvider.gseList[index].exactly = 0;
                            _testPageProvider.gseList[index].moderately = value == true ? 1 : 0;
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
                        value: _testPageProvider.gseList[index].hardly == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.gseAnswers[index] = "Hardly true"
                              : _testPageProvider.gseAnswers[index] = "";
                          setState(() {
                            _testPageProvider.gseList[index].nott = 0;
                            _testPageProvider.gseList[index].moderately = 0;
                            _testPageProvider.gseList[index].exactly = 0;
                            _testPageProvider.gseList[index].hardly = value == true ? 1 : 0;
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
                        value: _testPageProvider.gseList[index].exactly == 0 ? false : true,
                        onChanged: (bool? value) {
                          value == true
                              ? _testPageProvider.gseAnswers[index] = "Exactly true"
                              : _testPageProvider.gseAnswers[index] = "";
                          setState(() {
                            _testPageProvider.gseList[index].nott = 0;
                            _testPageProvider.gseList[index].hardly = 0;
                            _testPageProvider.gseList[index].moderately = 0;
                            _testPageProvider.gseList[index].exactly = value == true ? 1 : 0;
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

  showDialogBoxProceed(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('General Self Efficacy Test Completed.'),
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
                  _testPageProvider.setActiveStep(1);
                },
                child: const Text(
                  'OK',
                ),
              ),
            ],
          );
        });
  }

  showDialogBoxEnd(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('General Self Efficiency Test Completed.'),
            content: Text(message),
            actions: <Widget>[
              // Submit button
              ElevatedButton(
                onPressed: () {
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
}
