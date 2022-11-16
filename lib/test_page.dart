import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:mlvapp/TestQ/anxq_test.dart';
import 'package:mlvapp/TestQ/depq_test.dart';
import 'package:mlvapp/TestQ/dqa_test.dart';
import 'package:mlvapp/TestQ/gse_test.dart';
import 'package:mlvapp/TestQ/pa_test.dart';
import 'package:mlvapp/TestQ/strq_test.dart';
import 'package:mlvapp/provider/TestPageProvider.dart';
import 'package:mlvapp/provider/authentication_provider.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late TestPageProvider _pageProvider;
  late AuthenticationProvider _auth;
  int activeStep = 0; // Initial step set to 5.
  int upperBound = 0; // upperBound MUST BE total number of icons minus 1.

  String test = "";

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TestPageProvider>(
          create: (_) => TestPageProvider(_auth),
        ),
      ],
      child: Builder(builder: (BuildContext _context) {
        _pageProvider = _context.watch<TestPageProvider>();
        activeStep = _pageProvider.activeStep;
        upperBound = _pageProvider.upperBound;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Test"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  IconStepper(
                    icons: const [
                      Icon(Icons.local_hospital),
                      Icon(Icons.medical_information),
                      Icon(Icons.person),
                      Icon(Icons.medical_services),
                      // Icon(Icons.warning),
                      // Icon(Icons.electric_bolt_rounded),
                    ],

                    // activeStep property set to activeStep variable defined above.
                    activeStep: _pageProvider.activeStep,

                    // This ensures step-tapping updates the activeStep.
                    onStepReached: (index) {
                      if (index == 0) {
                        setState(() {
                          _pageProvider.activeStep = index;
                        });
                      } else if (index > 0 &&
                          _pageProvider.gseResult != null &&
                          _pageProvider.gseResult == "negative") {
                        if (index > 1 && _pageProvider.demographicAnswers.contains("")) {
                          setState(() {
                            _pageProvider.activeStep = 1;
                          });
                          showError("Please answer demographic questions to proceed");
                        } else if (index > 2 && _pageProvider.personalityAnswers.contains("")) {
                          setState(() {
                            _pageProvider.activeStep = 2;
                          });
                          showError("Please answer personality questions to proceed");
                        } else {
                          setState(() {
                            _pageProvider.activeStep = index;
                          });
                        }
                      } else {
                        setState(() {
                          _pageProvider.activeStep = 0;
                        });
                        showError("Please complete General Self Efficacy Test");
                      }
                    },
                  ),
                  header(),
                  Center(
                      child: activeStep == 0
                          ? Container(
                              color: Colors.red, width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height - 280,
                              child: GSETestPage(
                                testPageProvider: _pageProvider,
                              ),
                              //  child: DQATestPage(),
                            )
                          : activeStep == 1
                              ? Container(
                                  color: Colors.yellow,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height - 280,
                                  child: DQATestPage(
                                    testPageProvider: _pageProvider,
                                  ),
                                )
                              : activeStep == 2
                                  ? Container(
                                      color: Colors.blue,
                                      width: 400,
                                      height: MediaQuery.of(context).size.height - 280,
                                      child: PATest(
                                        testPageProvider: _pageProvider,
                                      ),
                                    )
                                  : activeStep == 3
                                      ? test.isEmpty
                                          ? Container(
                                              height: MediaQuery.of(context).size.height * 0.65,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                                                    child: const Text(
                                                      "The following questions should not be used to replace a face to face clinical interview. If you are experiencing significant emotional difficulties you should contact your Doctor for a referral to a qualified professional.\n\nPlease read each statement and select suitable answers which indicate how much the statement applied to you over the past week. There are no right or wrong answers. Do not spend too much time on any statement. The rating scale is as follows",
                                                      textAlign: TextAlign.justify,
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          test = "depression";
                                                        });
                                                      },
                                                      child: Text("Depression Test")),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          test = "anxiety";
                                                        });
                                                      },
                                                      child: Text("Anxiety Test")),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          test = "stress";
                                                        });
                                                      },
                                                      child: Text("Stress Test")),
                                                ],
                                              ),
                                            )
                                          : test == "depression"
                                              ? Container(
                                                  color: Colors.green,
                                                  width: 400,
                                                  height: MediaQuery.of(context).size.height - 280,
                                                  child: DEPQTest(
                                                    testPageProvider: _pageProvider,
                                                  ),
                                                )
                                              : test == "anxiety"
                                                  ? Container(
                                                      color: Colors.green,
                                                      width: 400,
                                                      height: MediaQuery.of(context).size.height - 280,
                                                      child: ANXQTest(
                                                        testPageProvider: _pageProvider,
                                                      ),
                                                    )
                                                  : test == "stress"
                                                      ? Container(
                                                          color: Colors.green,
                                                          width: 400,
                                                          height: MediaQuery.of(context).size.height - 280,
                                                          child: STRQTest(
                                                            testPageProvider: _pageProvider,
                                                          ),
                                                        )
                                                      : Container()
                                      : Container()

                      // Text('$activeStep'),
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      activeStep > 0 ? previousButton() : Container(),
                      activeStep == 3 && test.isNotEmpty
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  test = "";
                                });
                              },
                              child: const Text("Back to selection"))
                          : activeStep < 3
                              ? nextButton()
                              : Container(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Test"),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         children: [
    //           IconStepper(
    //             icons: [
    //               Icon(Icons.medical_information),
    //               Icon(Icons.person),
    //               Icon(Icons.local_hospital),
    //               Icon(Icons.medical_services),
    //               Icon(Icons.flag),
    //             ],

    //             // activeStep property set to activeStep variable defined above.
    //             activeStep: activeStep,

    //             // This ensures step-tapping updates the activeStep.
    //             onStepReached: (index) {
    //               setState(() {
    //                 activeStep = index;
    //               });
    //             },
    //           ),
    //           header(),
    //           Center(
    //               child: activeStep == 0
    //                   ? Container(
    //                       color: Colors.red, width: 400, height: MediaQuery.of(context).size.height - 280,
    //                       child: DQATestPage(),
    //                       //  child: DQATestPage(),
    //                     )
    //                   : activeStep == 1
    //                       ? Container(
    //                           color: Colors.yellow,
    //                           width: 400,
    //                           height: MediaQuery.of(context).size.height - 280,
    //                           child: PATest(),
    //                         )
    //                       : activeStep == 2
    //                           ? Container(
    //                               color: Colors.blue,
    //                               width: 400,
    //                               height: MediaQuery.of(context).size.height - 280,
    //                               child: DEPQTest(),
    //                             )
    //                           : activeStep == 3
    //                               ? Container(
    //                                   color: Colors.green,
    //                                   width: 400,
    //                                   height: MediaQuery.of(context).size.height - 280,
    //                                   child: ANXQTest(),
    //                                 )
    //                               : Container(
    //                                   color: Colors.green,
    //                                   width: 400,
    //                                   height: MediaQuery.of(context).size.height - 280,
    //                                   child: STRQTest(),
    //                                 )

    //               // Text('$activeStep'),
    //               ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               previousButton(),
    //               nextButton(),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  /// Returns the next button.
  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        if (_pageProvider.activeStep == 0 && _pageProvider.gseResult != null && _pageProvider.gseResult == "negative") {
          if (_pageProvider.activeStep < _pageProvider.upperBound) {
            setState(() {
              _pageProvider.activeStep++;
            });
          }
        } else if (_pageProvider.activeStep > 0) {
          if (_pageProvider.activeStep == 1 && _pageProvider.demographicAnswers.contains("")) {
            showError("Please answer demographic questions to proceed");
          } else if (_pageProvider.activeStep == 2 && _pageProvider.personalityAnswers.contains("")) {
            showError("Please answer personality questions to proceed");
          } else if (_pageProvider.activeStep < _pageProvider.upperBound) {
            setState(() {
              _pageProvider.activeStep++;
            });
          }
        } else {
          showError("Please complete General Self Efficacy Test");
        }
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
      },
      child: Text('Next'),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (_pageProvider.activeStep > 0) {
          setState(() {
            _pageProvider.activeStep--;
          });
        }
      },
      child: Text('Prev'),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              headerText(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 0:
        return 'General Self Efficacy Test';

      case 1:
        return 'Demographic Question Assessment';

      case 2:
        return 'Personality Assessment';

      case 3:
        return test == "depression"
            ? 'Depression Questions'
            : test == "anxiety"
                ? "Anxiety Questions"
                : test == "stress"
                    ? "Stress Questions"
                    : "Select Test";

      case 4:
        return 'Anxiety Questions';

      default:
        return 'Stress Questions';
    }
  }

  showError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(''),
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
