import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:http/http.dart' as http;
import 'package:mlvapp/Member2/chat_page.dart';
import 'package:mlvapp/Models/chat.dart';
import 'package:mlvapp/Models/chat_message.dart';
import 'package:mlvapp/home.dart';
import 'package:mlvapp/popup_message.dart';
import 'package:mlvapp/services/encryption_service.dart';
import 'package:mlvapp/services/firestore_database.dart';
import 'package:mlvapp/services/navigation_service.dart';
import 'package:mlvapp/sw_dialog.dart';
import 'package:mlvapp/utility/consts.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;

class MLChatPage extends StatefulWidget {
  String? initialMessage;
  Chat? chat;

  MLChatPage({Key? key, this.initialMessage, this.chat}) : super(key: key);

  @override
  State<MLChatPage> createState() => _MLChatPageState();
}

class _MLChatPageState extends State<MLChatPage> {
  ScrollController _scrollController = ScrollController();
  static String chatResponseMsg = "";
  String? initMessage;
  late double _deviceHeight;
  late double _deviceWidth;
  final _formKey = GlobalKey<FormState>();

  List<Map<String, String>> messageList = [];

  final encrypter = Encrypt.Encrypter(Encrypt.AES(Encrypt.Key.fromLength(32)));

  late StreamSubscription _messagesStream;
  late FirebaseDatabase _db;
  late NavigationService _navigationService;
  late EncryptionService _encryption;

  List<ChatMessage>? messages;

  @override
  void initState() {
    _db = GetIt.instance.get<FirebaseDatabase>();
    _navigationService = GetIt.instance.get<NavigationService>();
    _encryption = EncryptionService(encrypter);
    chatResponseMsg = "";
    initMessage = widget.initialMessage;
    if (initMessage != null) {
      sendInitialMessage(initMessage!);
      if (widget.chat != null) {
        listenToMessages();
      }
    }

    super.initState();
  }

  TextEditingController textEditingController = TextEditingController();

  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessagesForChat(widget.chat!.uid).listen((_snapshot) {
        List<ChatMessage> _messages = _snapshot.docs.map(
          (_m) {
            Map<String, dynamic> _messageData = _m.data() as Map<String, dynamic>;

            _messageData["content"] = _encryption.decrypt(_messageData["content"]);

            return ChatMessage.fromJSON(_messageData);
          },
        ).toList();
        messages = _messages;
        if (messages != null &&
            messages!.isNotEmpty &&
            messages!.last.sentTime.compareTo(DateTime.now().subtract(Duration(minutes: 1))) > 0) {
          _navigationService.navigateToPage(ChatPage(chat: widget.chat!));
        }
      });
    } catch (e) {
      print("Error Getting Messages");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        title: Text('ML Assistance'),
        excludeHeaderSemantics: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
              icon: const Icon(Icons.home))
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              "assets/images/bg1.jpeg",
              fit: BoxFit.cover,
              height: double.maxFinite,
              width: double.maxFinite,
            ),
          ),
          Center(
              child: Container(
            height: _deviceHeight * 0.75,
            margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
            child: ListView.builder(
                addAutomaticKeepAlives: true,
                itemCount: messageList.length,
                controller: _scrollController,
                itemBuilder: (context, i) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.01),
                    child: Text(
                      messageList[i]["message"]!,
                      textAlign: messageList[i]["type"] == "bot" ? TextAlign.left : TextAlign.right,
                      style: TextStyle(

                          // backgroundColor: messageList[i]["type"] == "bot" ? Colors.blueGrey : Colors.grey[100],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: messageList[i]["type"] == "bot" ? Colors.blue : Colors.black),
                    ),
                  );
                }),
            // child: Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Text(
            //     '$chatResponseMsg',
            //     style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 67, 2, 51), fontWeight: FontWeight.bold),
            //   ),
            // ),
          )),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 80,
              width: double.infinity,
              //color: Color.fromARGB(255, 152, 94, 0),
              child: Form(
                key: _formKey,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: textEditingController,
                        style: const TextStyle(color: Colors.black),
                        // decoration: InputDecoration(
                        //   fillColor: Colors.white,
                        //   filled: true,
                        //   contentPadding: EdgeInsets.all(12.0),
                        //   enabledBorder: OutlineInputBorder(
                        //     borderSide: BorderSide(color: Colors.white, width: 2.0),
                        //   ),
                        //   focusedBorder: OutlineInputBorder(
                        //     borderSide: BorderSide(color: Colors.pink, width: 2.0),
                        //   ),
                        //   hintText: "Write message...",
                        // ),
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            filled: true,
                            fillColor: Color.fromARGB(255, 247, 255, 247).withOpacity(0.2),
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red, //this has no effect
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            helperText: ''),
                        validator: (value) => value!.isEmpty ? "Enter message." : null,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 25),
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            chatResponseMsg = "";
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              sendChat(context, textEditingController.text);
                              textEditingController.clear();
                            }
                          });
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Color.fromARGB(255, 219, 206, 19),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendChat(BuildContext context, String msg) async {
    messageList.add({"type": "user", "message": msg});
    SWDialog sw = SWDialog(context);
    PopupsMessage popupsMessage = PopupsMessage();
    // sw.displayDialog(title: "Sending", bodyText: "Pleas wait...");
    Future<bool> _willPopCallback() async {
      // await Show dialog of exit or what you want
      // then
      return true; //
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
            onWillPop: _willPopCallback,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              //  title: new Text(title),
              content: Row(
                children: <Widget>[
                  Expanded(
                    child: Image.asset('assets/images/loadingtea.gif'),
                  ),
                ],
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
              ],
            ));
      },
    );
    try {
      // string to uri
      var uri = Uri.parse(chatbotUrl);
      var map = new Map<String, dynamic>();
      map['chat'] = msg;
      var response = await http.post(uri, body: map);

      sw.closeAlert();
      print(response.body);

      if (response.statusCode == 200) {
        FocusManager.instance.primaryFocus?.unfocus();
        // listen for response
        Map res = jsonDecode(response.body);
        if (res["data"] != null) {
          setState(() {
            chatResponseMsg = res["data"];
            messageList.add({"type": "bot", "message": chatResponseMsg});
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(popupsMessage.getSnackBar(message: "Error"));
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(popupsMessage.getSnackBar(message: "Something went wrong. Please try again."));
    }
  }

  sendInitialMessage(String msg) async {
    try {
      messageList.add({"type": "user", "message": msg});

      // string to uri
      var uri = Uri.parse(chatbotUrl);
      var map = new Map<String, dynamic>();
      map['chat'] = msg;
      var response = await http.post(uri, body: map);

      print(response.body);

      if (response.statusCode == 200) {
        FocusManager.instance.primaryFocus?.unfocus();
        // listen for response
        Map res = jsonDecode(response.body);
        if (res["data"] != null) {
          setState(() {
            chatResponseMsg = res["data"];
            messageList.add({"type": "bot", "message": chatResponseMsg});
          });
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
