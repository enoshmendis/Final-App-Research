import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:im_stepper/stepper.dart';
import 'package:mlvapp/Models/mood_record.dart';
import 'package:mlvapp/provider/MoodTrackPageProvide.dart';
import 'package:mlvapp/provider/authentication_provider.dart';
import 'package:mlvapp/services/navigation_service.dart';
import 'package:mlvapp/shared/label.dart';
import 'package:mlvapp/utility/consts.dart';
import 'package:provider/provider.dart';
import 'package:time_range_picker/time_range_picker.dart';

class MoodQuestionsPage extends StatefulWidget {
  final String userId;
  const MoodQuestionsPage({super.key, required this.userId});

  @override
  State<MoodQuestionsPage> createState() => _MoodQuestionsPageState();
}

class _MoodQuestionsPageState extends State<MoodQuestionsPage> {
  final _noteFormKey = GlobalKey<FormState>();

  late double _deviceWidth;
  late double _deviceHeight;
  late MoodTrackerPageProvider _pageProvider;
  late AuthenticationProvider _auth;
  late NavigationService _navigationService;
  int activeStep = 0; // Initial step set to 5.
  int upperBound = 0; // upperBound MUST BE total number of icons minus 1.

  String todayMood = "";
  String todayActivity = "";
  String todayFeeling = "";
  TimeOfDay? todaySleepStart;
  TimeOfDay? todaySleepEnd;
  String todayNote = "";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MoodTrackerPageProvider>(
          create: (_) => MoodTrackerPageProvider(widget.userId),
        ),
      ],
      child: Builder(builder: (BuildContext _context) {
        _deviceHeight = MediaQuery.of(context).size.height;
        _deviceWidth = MediaQuery.of(context).size.width;
        _pageProvider = _context.watch<MoodTrackerPageProvider>();
        _auth = _context.watch<AuthenticationProvider>();
        _navigationService = GetIt.instance.get<NavigationService>();
        activeStep = _pageProvider.activeStep;
        upperBound = _pageProvider.upperBound;

        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.green,
            backgroundColor: Colors.white,
            title: const Text(
              'Mood Tracker',
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.02, vertical: _deviceHeight * 0.02),
            child: ElevatedButton(
              onPressed: () async {
                if (_pageProvider.activeStep < _pageProvider.upperBound) {
                  if (_pageProvider.activeStep == 0 && todayMood.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Please select your mood today.')));
                  } else if (_pageProvider.activeStep == 1 && todayActivity.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Please select what you did today.')));
                  } else if (_pageProvider.activeStep == 2 && todayFeeling.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Please select how you feel today.')));
                  } else if (_pageProvider.activeStep == 3 && todaySleepStart == null && todaySleepEnd == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Please select sleep time.')));
                  } else {
                    setState(() {
                      _pageProvider.activeStep = _pageProvider.activeStep + 1;
                    });
                  }
                } else {
                  _noteFormKey.currentState!.save();
                  if (_pageProvider.activeStep == 4 && todayNote.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add a note.')));
                  } else if (_pageProvider.activeStep == 4 &&
                      todayNote.isNotEmpty &&
                      todayMood.isNotEmpty &&
                      todayFeeling.isNotEmpty &&
                      todayActivity.isNotEmpty &&
                      todaySleepStart != null &&
                      todaySleepEnd != null) {
                    print("Insert MOOD Record");

                    MoodRecord _record = MoodRecord(
                      uid: _auth.user.uid,
                      mood: todayMood,
                      activity: todayActivity,
                      feeling: todayFeeling,
                      sleepStart: todaySleepStart!.format(context),
                      sleepEnd: todaySleepEnd!.format(context),
                      note: todayNote,
                      timestamp: DateTime.now(),
                    );
                    bool result = await _pageProvider.insertMoodRecord(_record);
                    if (result) {
                      _navigationService.removeAndNavigateToRoute("/home");
                    } else {
                      showError("Could not insert your data. Please try again");
                    }
                  }
                }
              },
              child: activeStep == 4 ? const Text("Done") : const Text("Next"),
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                IconStepper(
                  icons: const [
                    Icon(Icons.mood),
                    Icon(Icons.nature_people),
                    Icon(Icons.face_retouching_natural),
                    Icon(Icons.night_shelter),
                    Icon(Icons.notes),
                  ],

                  // activeStep property set to activeStep variable defined above.
                  activeStep: _pageProvider.activeStep,

                  // This ensures step-tapping updates the activeStep.
                  onStepReached: (index) {
                    if (index == 1 && todayMood.isEmpty) {
                      setState(() {
                        _pageProvider.activeStep = 0;
                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Please select your mood today.')));
                    } else if (index == 2 && todayActivity.isEmpty) {
                      setState(() {
                        _pageProvider.activeStep = 1;
                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Please select what you did today.')));
                    } else if (index == 3 && todayFeeling.isEmpty) {
                      setState(() {
                        _pageProvider.activeStep = 2;
                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Please select how you feel today.')));
                    } else if (index == 4 && todaySleepStart == null && todaySleepEnd == null) {
                      setState(() {
                        _pageProvider.activeStep = 3;
                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Please select sleep time.')));
                    } else {
                      setState(() {
                        _pageProvider.activeStep = index;
                      });
                    }
                  },
                ),
                Center(
                  child: activeStep == 0
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.02, vertical: _deviceHeight * 0.03),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "How was your mood today?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
                                  shrinkWrap: true,
                                  itemCount: kMoodList.length,
                                  itemBuilder: (BuildContext _context, int _index) {
                                    return GestureDetector(
                                      onTap: () {
                                        // _pageProvider.getEmotions(DateTime(_currentYear.year, index + 1));
                                        setState(() {
                                          todayMood = kMoodList[_index];
                                        });
                                      },
                                      child: Container(
                                        width: _deviceWidth * 0.1,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: _deviceWidth * 0.3, vertical: _deviceHeight * 0.01),
                                        child: Label(
                                          isBordered: true,
                                          borderColor: Colors.green,
                                          fontSize: 38,
                                          labelColor:
                                              kMoodList.indexOf(todayMood) == _index ? Colors.green : Colors.white,
                                          label: kMoodEmojiList[_index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      : activeStep == 1
                          ? Container(
                              margin:
                                  EdgeInsets.symmetric(horizontal: _deviceWidth * 0.02, vertical: _deviceHeight * 0.03),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "What have you been up to?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: _deviceHeight * 0.65,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
                                    child: ListView.builder(
                                      // padding: EdgeInsets.symmetric(
                                      //     horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.01),
                                      shrinkWrap: false,
                                      itemCount: kActivityList.length,
                                      itemBuilder: (BuildContext _context, int _index) {
                                        return GestureDetector(
                                          onTap: () {
                                            // _pageProvider.getEmotions(DateTime(_currentYear.year, index + 1));
                                            setState(() {
                                              todayActivity = kActivityList[_index];
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.01),
                                            child: Label(
                                              isBordered: true,
                                              borderColor: Colors.green,
                                              labelColor: kActivityList.indexOf(todayActivity) == _index
                                                  ? Colors.green
                                                  : Colors.white,
                                              label: kActivityList[_index],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          : activeStep == 2
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: _deviceWidth * 0.02, vertical: _deviceHeight * 0.03),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "How are you feeling?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        height: _deviceHeight * 0.65,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
                                        child: ListView.builder(
                                          // padding: EdgeInsets.symmetric(
                                          //     horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.01),
                                          shrinkWrap: false,
                                          itemCount: kFeelingsList.length,
                                          itemBuilder: (BuildContext _context, int _index) {
                                            return GestureDetector(
                                              onTap: () {
                                                // _pageProvider.getEmotions(DateTime(_currentYear.year, index + 1));
                                                setState(() {
                                                  todayFeeling = kFeelingsList[_index];
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.01),
                                                child: Label(
                                                  isBordered: true,
                                                  borderColor: Colors.green,
                                                  labelColor: kFeelingsList.indexOf(todayFeeling) == _index
                                                      ? Colors.green
                                                      : Colors.white,
                                                  label: kFeelingsList[_index],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : activeStep == 3
                                  ? Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: _deviceWidth * 0.02, vertical: _deviceHeight * 0.03),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Your sleep time",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: _deviceHeight * 0.03),
                                            width: _deviceWidth,
                                            height: 60,
                                            child: todaySleepStart != null && todaySleepEnd != null
                                                ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            todaySleepStart!.format(context),
                                                            style: const TextStyle(
                                                              fontSize: 22,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          const Text(
                                                            "Bedtime",
                                                            style: TextStyle(fontSize: 16),
                                                          ),
                                                        ],
                                                      ),
                                                      const VerticalDivider(
                                                        thickness: 2,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            todaySleepEnd!.format(context),
                                                            style: const TextStyle(
                                                              fontSize: 22,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          const Text(
                                                            "Wake up",
                                                            style: TextStyle(fontSize: 16),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: _deviceHeight * 0.03),
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  TimeRange? result = await showTimeRangePicker(
                                                    context: context,
                                                    ticks: 24,
                                                    ticksColor: Colors.grey,
                                                    ticksOffset: -12,
                                                    autoAdjustLabels: true,
                                                    use24HourFormat: false,
                                                    snap: true,
                                                    labelOffset: -30,
                                                    rotateLabels: false,
                                                    start: const TimeOfDay(hour: 0, minute: 0),
                                                    end: const TimeOfDay(hour: 8, minute: 0),
                                                    clockRotation: 180,
                                                    timeTextStyle: const TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    barrierDismissible: true,
                                                    labels: [
                                                      "0",
                                                      "2",
                                                      "4",
                                                      "6",
                                                      "8",
                                                      "10",
                                                      "12",
                                                      "14",
                                                      "16",
                                                      "18",
                                                      "20",
                                                      "22",
                                                    ].asMap().entries.map((e) {
                                                      return ClockLabel.fromIndex(
                                                          idx: e.key, length: 12, text: e.value);
                                                    }).toList(),
                                                  );
                                                  print("result " + result.toString());
                                                  if (result != null) {
                                                    setState(() {
                                                      todaySleepStart = result.startTime;
                                                      todaySleepEnd = result.endTime;
                                                    });
                                                  }
                                                },
                                                child: const Text("Select Time")),
                                          ),
                                        ],
                                      ),
                                    )
                                  : activeStep == 4
                                      ? Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: _deviceWidth * 0.02, vertical: _deviceHeight * 0.03),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Today Note",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Container(
                                                height: _deviceHeight * 0.6,
                                                margin: EdgeInsets.symmetric(
                                                  vertical: _deviceHeight * 0.02,
                                                ),
                                                child: Form(
                                                  key: _noteFormKey,
                                                  child: TextFormField(
                                                    expands: true,
                                                    maxLines: null,
                                                    decoration:
                                                        const InputDecoration(fillColor: Colors.black12, filled: true),
                                                    onSaved: (value) {
                                                      setState(() {
                                                        todayNote = value!;
                                                      });
                                                    },
                                                    onChanged: ((value) {
                                                      setState(() {
                                                        todayNote = value;
                                                      });
                                                    }),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  showError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Error',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
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
