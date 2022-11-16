//import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mlvapp/utility/consts.dart';
import 'package:mlvapp/video_page.dart';

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  final List<CameraDescription> cameras;

  /// Default Constructor
  const CameraApp({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  final _random = Random();
  late double _deviceHeight;
  late double _deviceWidth;
  Timer? timer;
  late CameraController controller;
  List<String> emotionsList = [];
  String emotionText = "";
  int iterations = 0;
  String video = "";

  List<Map<String, dynamic>> videoList = [
    {
      "type": "angry",
      "videos": [
        "https://res.cloudinary.com/detp06pve/video/upload/v1665605150/mHelp/Angry/WhatsApp_Video_2022-10-10_at_01.07.40_qhtls8.mp4",
        "https://res.cloudinary.com/detp06pve/video/upload/v1665605108/mHelp/Angry/WhatsApp_Video_2022-10-10_at_00.33.08_1_cfpg29.mp4",
      ],
    },
    {
      "type": "fear",
      "videos": [
        "https://res.cloudinary.com/detp06pve/video/upload/v1665605190/mHelp/Fear/WhatsApp_Video_2022-10-10_at_00.33.08_lmxqsf.mp4",
      ],
    },
    {
      "type": "happy",
      "videos": [
        "https://res.cloudinary.com/detp06pve/video/upload/v1665605528/mHelp/Happy/WhatsApp_Video_2022-10-10_at_00.33.07_dm4inl.mp4",
        "https://res.cloudinary.com/detp06pve/video/upload/v1665605375/mHelp/Happy/Happy_-_A_Guided_Meditation_to_Boost_Your_Mood_360p_nkdzlz.mp4",
      ],
    },
    {
      "type": "sad",
      "videos": [
        "https://res.cloudinary.com/detp06pve/video/upload/v1665605800/mHelp/Sad/Meditation_on_Sadness_360p_gyhdrz.mp4",
      ],
    }
  ];

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) controller = CameraController(widget.cameras[1], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});

      timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
        setState(() {
          iterations++;
        });
        if (iterations == 4) {
          List<Map<String, dynamic>> videoSet = videoList.where((element) => element["type"] == emotionText).toList();
          if (videoSet.isNotEmpty) {
            setState(() {
              video = videoSet.first["videos"][_random.nextInt(videoSet.first["videos"].length)];
            });
          }
          timer?.cancel();
        } else {
          XFile image = await controller.takePicture();
          String emotion = await uploadImage(File(image.path));
        }
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [],
      ),
      body: Stack(
        children: [
          Container(
            height: _deviceHeight,
            width: _deviceWidth,
            child: CameraPreview(controller),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                iterations >= 4 && video != ""
                    ? Container(
                        padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.03),
                        alignment: Alignment.bottomCenter,
                        color: Colors.white.withOpacity(0.5),
                        width: _deviceWidth,
                        height: _deviceHeight * 0.15,
                        child: Column(
                          children: [
                            const Text(
                              "A video is suggested for you.",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              child: ElevatedButton(
                                child: const Text("Watch Now"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VideoPage(
                                              url: video,
                                            )),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  padding: EdgeInsets.all(5),
                  child: Container(
                      child: Text(
                    emotionText,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.blueAccent,
                      fontSize: 32,
                    ),
                  )),
                  width: _deviceWidth,
                  height: _deviceHeight * 0.1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> uploadImage(File file) async {
    try {
      String fileName = file.path.split("/").last;

      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      Dio dio = new Dio();

      dio.post(emotionUrl, data: data).then((response) {
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.toString());
          print(jsonResponse["data"].toString());
          List<String> newList = emotionsList;
          newList.add(jsonResponse["data"].toString());
          setState(() {
            emotionText = jsonResponse["data"].toString();
            emotionsList = newList;
          });
          return jsonResponse["data"].toString();
        } else {
          return null;
        }
      }).catchError((error) => print(error));
    } catch (Exception) {
      print("Exception " + Exception.toString() + '100');
    }
    return '';
  }
}
