import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:mlvapp/services/cloud_storage_service.dart';
import 'package:mlvapp/services/encryption_service.dart';
import 'package:mlvapp/services/firestore_database.dart';
import 'package:mlvapp/services/media_service.dart';
import 'package:mlvapp/services/navigation_service.dart';
import 'package:mlvapp/shared/rounded_button.dart';
import 'package:mlvapp/utility/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/database.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashScreen({required Key key, required this.onInitializationComplete}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences sp;
  bool loading = true;
  bool _concent = true;
  // @override
  // void initState() {
  //   super.initState();

  //   Timer(Duration(seconds: 3), () {
  //       Navigator.pushReplacement(
  //             context, MaterialPageRoute(builder: (context) => LogIn()));
  //   });
  // }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 0)).then(
      (_) {
        checkAgreement().then((value) {
          if (value) {
            _setup().then((_) {
              widget.onInitializationComplete();
            });
          }
        });
      },
    );
  }

  Future<bool> checkAgreement() async {
    sp = await SharedPreferences.getInstance();
    bool concent = sp.getBool("agree") ?? false;
    setState(() {
      _concent = concent;
    });
    return concent;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mental Health",
      theme: ThemeData(
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: _concent
                  ? Image.asset('assets/images/logo.png')
                  : Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "The following test is not a diagnostic tool, but an accessible application to obtain some understanding of your present mental status. In instances where you are connected with a medical doctor or a psychologist, MHelp bears no responsibility towards the patient doctor relationship / agreement.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RoundedSizedButton(
                                  fontSize: 16,
                                  radius: 5,
                                  name: "Disagree",
                                  colorGradient: [Colors.red, Colors.red],
                                  onPressed: () {
                                    sp.setBool("agree", false);
                                    setState(() {
                                      _concent = false;
                                    });
                                    exit(0);
                                  },
                                ),
                                RoundedSizedButton(
                                  fontSize: 16,
                                  radius: 5,
                                  name: "Agree",
                                  colorGradient: [Colors.blue, Colors.blue],
                                  onPressed: () {
                                    sp.setBool("agree", true);
                                    setState(() {
                                      _concent = true;
                                    });
                                    _setup().then((_) {
                                      widget.onInitializationComplete();
                                    });
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ))),
    );

    // return Scaffold(
    //   body: Stack(children: [
    //     Container(
    //       constraints: BoxConstraints.expand(),
    //       decoration: const BoxDecoration(color: Colors.white
    //           // image: DecorationImage(
    //           //     image: AssetImage("assets/images.jpeg"), fit: BoxFit.cover),
    //           ),
    //     ),
    //     Center(child: Image.asset('assets/images/logo.png'))
    //   ]),
    // );
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await DatabaseService().initDatabase();
    _registerServices();
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    GetIt.instance.registerSingleton<FirebaseDatabase>(FirebaseDatabase());
    GetIt.instance.registerSingleton<MediaService>(MediaService());
    GetIt.instance.registerSingleton<CloudStorageService>(CloudStorageService());
  }
}
