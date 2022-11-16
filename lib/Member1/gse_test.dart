import 'package:flutter/material.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:mlvapp/Member1/dass_test.dart';
import 'package:mlvapp/Models/gse_model.dart';
import 'package:mlvapp/services/database.dart';
import 'package:mlvapp/home.dart';
import 'package:mlvapp/shared/constants.dart';

// enum GseScore { not, hardly, moderately, exactly }

class GSETest extends StatefulWidget {
  @override
  _GSETestState createState() => _GSETestState();
}

class _GSETestState extends State<GSETest> {
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();

  List<GSETestModel> list = [];
  // GseScore? _score;
  int _totalScore = 0;
  // bool not = false;

  void getData() async {
    list = await DatabaseService().getAllGseTests();
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
                                    child: const Text("Not at all true",
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
                                    child: const Text("Hardly true",
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
                                    child: const Text("Moderately true",
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
                                    child: const Text("Exactly true",
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
                  title: const Text('GSE Test Completed.'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const <Widget>[
                      Text(
                          'Your response indicates your efficiency is low.\n Your should do the DASS test')
                    ],
                  ),
                  actions: [

                    TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DASSTest()),
                        );
                        // Navigator.of(context).pop();
                      },
                      child: Text('OK'),
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
                    value: list[index].nott == 0 ? false : true,
                    onChanged: (bool? value) {
                      setState(() {
                        list[index].nott = value == true ? 1 : 0;
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
                    value: list[index].hardly == 0 ? false : true,
                    onChanged: (bool? value) {
                      setState(() {
                        list[index].hardly = value == true ? 1 : 0;
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
                    value: list[index].moderately == 0 ? false : true,
                    onChanged: (bool? value) {
                      setState(() {
                        list[index].moderately = value == true ? 1 : 0;
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
                    value: list[index].exactly == 0 ? false : true,
                    onChanged: (bool? value) {
                      setState(() {
                        list[index].exactly = value == true ? 1 : 0;
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
