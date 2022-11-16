import 'package:flutter/material.dart';
import 'package:mlvapp/Models/test_model.dart';
import 'package:mlvapp/utility/utils.dart';

class ReportPage extends StatefulWidget {
  final Test test;
  const ReportPage({super.key, required this.test});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Test _test;
  late PageController _pageController;

  int curPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _test = widget.test;

    List<Map<String, dynamic>> testList = [
      {
        "name": "General Self Efficiency Test",
        "result": _test.gseResult,
        "test": _test.gseTest,
      },
      {
        "name": "Demographic Questions Test",
        "result": _test.dqaResult,
        "test": _test.dqaTest,
      },
      {
        "name": "Personality Test",
        "result": _test.paResult,
        "test": _test.paTest,
      },
      {
        "name": "Depression Test",
        "result": _test.deppressionResult,
        "test": _test.deppressionTest,
      },
      {
        "name": "Anxiety Test",
        "result": _test.anxietyResult,
        "test": _test.anxietyTest,
      },
      {
        "name": "Stress Test",
        "result": _test.stressResult,
        "test": _test.stressTest,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        title: const Text(
          'Test Reports',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                onPageChanged: ((value) {
                  setState(() {
                    curPage = value;
                  });
                }),
                itemCount: testList.length,
                controller: _pageController,
                itemBuilder: (context, index) => _buildResultPage(testList[index]),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ...List.generate(
                  testList.length,
                  ((index) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: DotIndicator(
                          isActive: index == curPage,
                        ),
                      )))
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                curPage != 0
                    ? SizedBox(
                        child: IconButton(
                          onPressed: () {
                            _pageController.previousPage(duration: Duration(microseconds: 300), curve: Curves.ease);
                          },
                          icon: const Icon(
                            Icons.arrow_circle_left,
                            color: Colors.blue,
                          ),
                          iconSize: 60,
                        ),
                      )
                    : Container(
                        width: 65,
                      ),
                curPage != 5
                    ? SizedBox(
                        child: IconButton(
                          onPressed: () {
                            _pageController.nextPage(duration: Duration(microseconds: 300), curve: Curves.ease);
                          },
                          icon: const Icon(
                            Icons.arrow_circle_right,
                            color: Colors.blue,
                          ),
                          iconSize: 60,
                        ),
                      )
                    : Container(
                        width: 65,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResultPage(Map<String, dynamic> test) {
    List questions = test["test"] as List;
    List<Widget> qList = questions.map((q) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: deviceWidth(context) * 0.02,
          vertical: deviceHeight(context) * 0.02,
        ),
        width: deviceWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q["question"]),
            const SizedBox(
              height: 10,
            ),
            Text(
              q["answer"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      );
    }).toList();

    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: deviceHeight(context) * 0.02,
              horizontal: deviceWidth(context) * 0.02,
            ),
            child: Text(
              test["name"],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: deviceHeight(context) * 0.01,
              horizontal: deviceWidth(context) * 0.02,
            ),
            child: test['result'] == ""
                ? Container()
                : Text(
                    "Result : ${test['result']}",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
          ),
          Container(
            height: deviceHeight(context) * 0.64,
            margin: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.02),
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      child: Column(children: qList),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.blue.withOpacity(0.4),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}
