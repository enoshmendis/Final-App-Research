import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mlvapp/Authenticate/login.dart';
import 'package:mlvapp/Member4/indicator.dart';
import 'package:mlvapp/Member4/preview.dart';

class ReportView extends StatefulWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const <Widget>[
            // Icon(Icons.delete_forever_outlined),
            Text('Mental Health'),
          ],
        ),
        backgroundColor: Colors.lightGreen[800],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('logout'),
            onPressed: () async {
              // await _auth.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogIn()),
              );
            },
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        Container(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(30.0),
                child: Column(children: <Widget>[
                  Card(
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        // const SizedBox(
                        //   height: 18,
                        // ),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                  pieTouchData: PieTouchData(touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  }),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 50,
                                  sections: showingSections()),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          // mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Indicator(
                              color: Color(0xff0293ee),
                              text: 'First',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Indicator(
                              color: Color(0xfff8b250),
                              text: 'Second',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Indicator(
                              color: Color(0xff845bef),
                              text: 'Third',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Indicator(
                              color: Color(0xff13d38e),
                              text: 'Fourth',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 18,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 28,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    "Report View",
                    textScaleFactor: 2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    child: Column(
                      children: const [
                        ListTile(
                          // leading: Text('Patient: Peter'),
                          title: Text('Patient: Peter'),
                          subtitle: Text('testestesttesttets'),
                        ),
                        ListTile(
                          // leading: Text('Patient: Peter'),
                          title: Text('Patient: Peter'),
                          subtitle: Text('testestesttesttets'),
                        ),
                      ],
                    ),
                  ),
                ])))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Preview()),
          );
        },
        tooltip: 'Check Out Customers',
        child: Icon(Icons.print_rounded),
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('detections').snapshots(),
      //   builder: (context, snapshot){
      //     if(!snapshot.hasData) return const Text('Loading...');
      //     return ListView.builder(
      //       // itemExtent: 80.0,
      //       itemCount: snapshot.data.documents.length,
      //       itemBuilder: (context, index) =>
      //           _buildListItem(context , snapshot.data.documents[index]),
      //     );
      //   },
      // ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
