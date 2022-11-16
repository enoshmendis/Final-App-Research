import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mlvapp/Authenticate/login.dart';
import 'package:mlvapp/Member1/dass_test.dart';
import 'package:mlvapp/Member1/gse_test.dart';
import 'package:mlvapp/Member1/user_profile.dart';

import 'package:mlvapp/Member2/chats_page.dart';
import 'package:mlvapp/Member2/doctor_profile.dart';
import 'package:mlvapp/Member3/sound_therapy.dart';
import 'package:mlvapp/Member4/analysis_report.dart';
import 'package:mlvapp/Member4/test_reports_page.dart';
import 'package:mlvapp/provider/authentication_provider.dart';
import 'package:mlvapp/services/navigation_service.dart';
import 'package:mlvapp/services/rest_api_service.dart';
import 'package:mlvapp/chat_page.dart';
import 'package:mlvapp/mood_tracker_page.dart';
import 'package:mlvapp/test_page.dart';
import 'package:camera/camera.dart';
import 'package:mlvapp/Member3/camera_page.dart';

import 'dart:io';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

//// Home function
class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  bool _inserted = false;
  late NavigationService _navigationService;
  late AuthenticationProvider _auth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _navigationService = GetIt.instance.get<NavigationService>();
    _auth = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          // leading: Icon(Icons.delete_forever_outlined),
          title: const Text("Home"),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfile()),
                );
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () async {
                _auth.logout();
                //_navigationService.removeAndNavigateToRoute("/login");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => LogIn()),
                // );
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg1.jpeg"), // setting background image
              fit: BoxFit.cover,
            ),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: _auth.user.usertype == "Doctor"
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 160,
                          ),
                          Card(
                            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                            child: Column(children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.message,
                                ),
                                title: const Text("Chats"),
                                // subtitle: Text("Verify Detected Garbage."),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChatsPage()),
                                  );
                                },
                              ),
                            ]),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 160,
                          ),
                          Card(
                            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.medical_information_outlined),
                                  title: const Text("Test"),
                                  // subtitle: Text("Detect Garbage from your camera"),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const TestPage()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.report),
                                  title: const Text("Emotion tracking"),
                                  onTap: () async {
                                    // pickCameraMedia();
                                    await availableCameras().then(
                                      (value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CameraApp(cameras: value),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                            child: Column(children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.data_array,
                                ),
                                title: const Text("Test Reports"),
                                // subtitle: Text("Verify Detected Garbage."),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TestReportsPage(uid: _auth.user.uid),
                                    ),
                                  );
                                },
                              ),
                            ]),
                          ),
                          Card(
                            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                            child: Column(children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.chat_bubble_outline,
                                ),
                                title: const Text("ML Assitant"),
                                // subtitle: Text("Verify Detected Garbage."),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MLChatPage()),
                                  );
                                },
                              ),
                            ]),
                          ),
                          Card(
                            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                            child: Column(children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.message,
                                ),
                                title: const Text("Chats"),
                                // subtitle: Text("Verify Detected Garbage."),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChatsPage()),
                                  );
                                },
                              ),
                            ]),
                          ),
                          Card(
                            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                            child: Column(children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.face,
                                ),
                                title: const Text("Mood Tracker"),
                                // subtitle: Text("Verify Detected Garbage."),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MoodTracker(
                                              userId: _auth.user.uid,
                                            )),
                                  );
                                },
                              ),
                            ]),
                          ),
                        ],
                      ),
              );
            },
          ),
        ));
  }
}
