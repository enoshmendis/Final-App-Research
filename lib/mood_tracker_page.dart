import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:mlvapp/mood_page.dart';
import 'package:mlvapp/mood_questions_page.dart';
import 'package:mlvapp/provider/MoodTrackPageProvide.dart';
import 'package:mlvapp/provider/authentication_provider.dart';
import 'package:mlvapp/sleep_page.dart';
import 'package:provider/provider.dart';

class MoodTracker extends StatefulWidget {
  final String userId;
  const MoodTracker({super.key, required this.userId});

  @override
  State<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  late double _deviceWidth;
  late double _deviceHeight;
  late AuthenticationProvider _auth;
  late MoodTrackerPageProvider _pageProvider;

  int _month = DateTime.now().month;
  int _year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MoodTrackerPageProvider>(
          create: (_) => MoodTrackerPageProvider(widget.userId),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _deviceHeight = MediaQuery.of(context).size.height;
      _deviceWidth = MediaQuery.of(context).size.width;
      _auth = Provider.of<AuthenticationProvider>(context);
      _pageProvider = _context.watch<MoodTrackerPageProvider>();

      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.green,
          backgroundColor: Colors.white,
          title:const Text(
            'Mood Tracker',
          ),
        ),
        bottomNavigationBar: _pageProvider.lastRecord != null &&
                _pageProvider.lastRecord!.timestamp.day < DateTime.now().day &&
                _pageProvider.lastRecord!.timestamp.month <= DateTime.now().month &&
                _pageProvider.lastRecord!.timestamp.year <= DateTime.now().year
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.02, vertical: _deviceHeight * 0.02),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoodQuestionsPage(
                          userId: _auth.user.uid,
                        ),
                      ),
                    );
                  },
                  child: Text("Track Mood"),
                ))
            : Container(
                height: 0,
              ),
        backgroundColor: Colors.white,
        body: Container(
          height: _deviceHeight * 0.747,
          child: DefaultTabController(
            length: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: _deviceHeight * 0.02, horizontal: _deviceWidth * 0.02),
                  child: DropdownDatePicker(
                    inputDecoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    isDropdownHideUnderline: true,
                    isFormValidator: true,
                    startYear: 2022,
                    endYear: DateTime.now().year,
                    width: 10,
                    selectedMonth: _month,
                    selectedYear: _year,
                    onChangedDay: (value) => print('onChangedDay: $value'),
                    onChangedMonth: (value) {
                      setState(() {
                        _month = int.parse(value!);
                      });
                      _pageProvider.getMoodRecordsForMonth(DateTime(_year, _month, 1));
                    },
                    onChangedYear: (value) {
                      setState(() {
                        _year = int.parse(value!);
                      });
                      _pageProvider.getMoodRecordsForMonth(DateTime(_year, _month, 1));
                    },
                    showDay: false,
                  ),
                ),
                Container(
                  width: _deviceWidth,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 0.5,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const TabBar(unselectedLabelColor: Colors.black, labelColor: Colors.black, tabs: [
                    Tab(
                      text: "Mood",
                    ),
                    Tab(
                      text: "Sleep",
                    ),
                  ]),
                ),
                Expanded(
                    child: TabBarView(children: [
                  MoodPage(
                    pageProvider: _pageProvider,
                  ),
                  SleepPage(
                    pageProvider: _pageProvider,
                  )
                ]))
              ],
            ),
          ),
        ),
      );
    });
  }
}
