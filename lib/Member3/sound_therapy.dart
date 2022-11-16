
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SoundTherapy extends StatefulWidget {
  const SoundTherapy({Key? key}) : super(key: key);

  @override
  _SoundTherapyState createState() => _SoundTherapyState();
}

class _SoundTherapyState extends State<SoundTherapy> {

  AudioPlayer player = AudioPlayer();
  String output = '';

  // speedometer
  double velocity = 0;
  double highestVelocity = 0.0;

  loadCamera() async {

  
  }

  runModel() async {

  }

  loadmodel() async {
    // await Tflite.loadModel(
    //     model: 'assets/therapy_tflite/model.tflite', labels: 'assets/therapy_tflite/labels.txt');
  }

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadmodel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Mental Health"),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                  child: Column(children: [
                    // Padding(
                    //   padding: EdgeInsets.all(20),
                    //   child: Container(
                    //     height: MediaQuery.of(context).size.height * 0.7,
                    //     width: MediaQuery.of(context).size.width,
                    //     child: !cameraController!.value.isInitialized
                    //         ? Container()
                    //         : AspectRatio(
                    //       aspectRatio: cameraController!.value.aspectRatio,
                    //       child: CameraPreview(cameraController!),
                    //     ),
                    //   ),
                    // ),
                    Text(
                      output,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                    ),

                    const SizedBox(height: 20.0,),

                    Wrap(
                      spacing: 10,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () async {
                              String audioasset = "assets/audio/Piano_Playing_Classical_Music.mp3";
                              ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
                              Uint8List  soundbytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
                              // int result = await player.playBytes(soundbytes);
                              // if(result == 1){ //play success
                              //   print("Sound playing successful.");
                              // }else{
                              //   print("Error while playing sound.");
                              // }
                            },
                            icon: Icon(Icons.play_arrow),
                            label:Text("Play")
                        ),

                        ElevatedButton.icon(
                            onPressed: () async {
                             // int result = await player.stop();

                              // You can pasue the player
                              // int result = await player.pause();

                              // if(result == 1){ //stop success
                              //   print("Sound playing stopped successfully.");
                              // }else{
                              //   print("Error on while stopping sound.");
                              // }
                            },
                            icon: Icon(Icons.stop),
                            label:Text("Stop")
                        ),

                      ],
                    )
                  ]),
              );
            },
          ),

        )
    );
  }

  // void testAlert(BuildContext context){
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: new Text("Location service disable"),
  //         content: new Text("You must enable your location access"),
  //
  //       );
  //     },
  //   );
  // }
}
