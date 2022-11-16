import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mlvapp/Member2/doctor_list.dart';
import 'package:mlvapp/Models/dass_model.dart';
import 'package:mlvapp/services/database.dart';
import 'package:mlvapp/home.dart';

// enum DassScore { never, sometimes, often, always }

class DASSTest extends StatefulWidget {
  @override
  _DASSTestState createState() => _DASSTestState();
}

class _DASSTestState extends State<DASSTest> {
  ScrollController _scrollController = ScrollController();

  List<DASSTestModel> list = [];
  // DassScore? _score = DassScore.never;
  int _totalScore = 0;

  void getData() async {
    list = await DatabaseService().getAllDass();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // DatabaseService().initDatabase();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mental Help App"),
        backgroundColor: Colors.green,
      ),
      body: DraggableScrollbar.rrect(
        alwaysVisibleScrollThumb: true,
        backgroundColor: Colors.black,
        controller: _scrollController,
        child: ListView.builder(
            addAutomaticKeepAlives: true,
            controller: _scrollController,
            itemCount: list.length,
            itemBuilder: (context, i) {
              // print(list[i].month);

              if (i == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                          Flexible(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: const Text(
                                        "                                            ")),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: const Text("Never",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: const Text("Somtimes",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: const Text("Often",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: const Text("Almost Always",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                        indent: 15,
                        endIndent: 15,
                        thickness: 2,
                        color: Colors.grey),
                    _gseTestBuild(i)
                  ],
                );
              }
              // else {
              //   return _totalBoxChickBuild(i);
              // }
              return _gseTestBuild(i);
            }),
      ),
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.blueGrey,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('DASS Test Completed.'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const <Widget>[
                      Text(
                          'Your response indicates you are in a severe position. \n We recommend you to consult a doctor.')
                    ],
                  ),
                  actions: [
                    // Submit button
                    TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorsList()),
                        );
                        // Navigator.of(context).pop();
                      },
                      child: const Text('Contact Doctor'),
                    ),

                    // Cancel button
                    TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.purple)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      child: Text('CANCEL'),
                    ),
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: const <Widget>[
                // Icon(
                //   Icons.close,
                //   color: Theme.of(context).accentColor,
                // ),
                Text('Submit',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gseTestBuild(index) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
              width: 1,
            ),
          ),
          Flexible(
            child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(top: 15),
                    child:
                        Text(list[index].question, textAlign: TextAlign.right)),
              ],
            ),
          ),
          Flexible(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: Checkbox(
                    value: list[index].never == 0 ? false : true,
                    onChanged: (bool? value) {
                      setState(() {
                        list[index].never = value == true ? 1 : 0;
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
                    value: list[index].sometimes == 0 ? false : true,
                    onChanged: (bool? value) {
                      setState(() {
                        list[index].sometimes = value == true ? 1 : 0;
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
                    value: list[index].often == 0 ? false : true,
                    onChanged: (bool? value) {
                      setState(() {
                        list[index].often = value == true ? 1 : 0;
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
                    value: list[index].always == 0 ? false : true,
                    onChanged: (bool? value) {
                      setState(() {
                        list[index].always = value == true ? 1 : 0;
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
    );
  }
}
