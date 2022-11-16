import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:mlvapp/Member2/chat_page.dart';
import 'package:mlvapp/Member2/doctor_messages_view.dart';
import 'package:mlvapp/Member2/doctor_profile.dart';
import 'package:mlvapp/Models/app_user.dart';
import 'package:mlvapp/Models/chat.dart';
import 'package:mlvapp/chat_page.dart';
import 'package:mlvapp/home.dart';
import 'package:mlvapp/provider/authentication_provider.dart';
import 'package:mlvapp/services/firestore_database.dart';
import 'package:mlvapp/services/navigation_service.dart';
import 'package:mlvapp/shared/constants.dart';
import 'package:mlvapp/theme.dart';
import 'package:provider/provider.dart';

class DoctorsList extends StatefulWidget {
  String? doctorType;

  DoctorsList({Key? key, this.doctorType}) : super(key: key);

  @override
  State<DoctorsList> createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  late FirebaseDatabase _firebaseDatabase;
  late NavigationService _navigationService;
  late AuthenticationProvider _auth;
  ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  late double _deviceHeight;
  late double _deviceWidth;

  String _doctorType = '';

  int _totalScore = 0;
  bool not = false;
  String? _docName;
  String _message = '';
  bool loading = true;

  String? _docUID;

  // List<Map<String, String>> docList = [
  //   {"name": "Dr. Nimal Perera", "type": "Counselor", "contact": "+94 71 864 4458"},
  //   {"name": "Dr. Sunil Perera", "type": "Psychotherapist", "contact": "+94 71 864 4458"},
  //   {"name": "Dr. Kamal Bandara", "type": "Psychiatric", "contact": "+94 71 864 4458"}
  // ];

  List<AppUser> docList = [];

  Chat? chat;

  @override
  void initState() {
    super.initState();
    // getData();
    _firebaseDatabase = GetIt.instance.get<FirebaseDatabase>();
    _navigationService = GetIt.instance.get<NavigationService>();
    if (widget.doctorType != null) {
      getDoctorList(widget.doctorType!);
    }
  }

  Future<void> getDoctorList(String type) async {
    await _firebaseDatabase.getDoctorList(type).then((_snapshot) {
      List<AppUser> list = _snapshot.docs.map((_doc) {
        Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
        _data["uid"] = _doc.id;

        AppUser _record = AppUser.fromJSON(_data);

        return _record;
      }).toList();
      setState(() {
        docList = list;
        loading = false;
      });
    });
  }

  Future<bool> createChat() async {
    try {
      //Create Chat
      List<String> _membersIds = [_docUID!, _auth.user.uid];

      bool _isGroup = false;

      if (!_isGroup && await _firebaseDatabase.checkChatExist(_membersIds.first)) {
        String error = "You have already started a chat with ${_membersIds.first}. Please see chats page.";
        print(error);
        return false;
      } else {
        DocumentReference? _doc = await _firebaseDatabase.createChat({
          "is_group": _isGroup,
          "is_activity": false,
          "members": _membersIds,
        });

        //Navigate to chat page
        List<AppUser> _members = [];
        for (var _uid in _membersIds) {
          DocumentSnapshot _userSnapshot = await _firebaseDatabase.getUser(_uid);

          Map<String, dynamic> _userData = _userSnapshot.data() as Map<String, dynamic>;

          _userData["uid"] = _userSnapshot.id;
          _members.add(AppUser.fromJSON(_userData));
        }

        chat = Chat(
          uid: _doc!.id,
          currentUserUid: _auth.user.uid,
          messages: [],
          activity: false,
          group: _isGroup,
          members: _members,
        );

        // ChatPage _chatPage = ChatPage(
        //     chat: Chat(
        //   uid: _doc.id,
        //   currentUserUid: _auth.user.uid,
        //   messages: [],
        //   activity: false,
        //   group: _isGroup,
        //   members: _members,
        // ));

        //_navigationService.navigateToPage(_chatPage);
        return true;
      }
    } catch (e) {
      print("Error creating chat.");
      print(e);
    }

    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _doctorType = widget.doctorType ?? "";
    _auth = Provider.of<AuthenticationProvider>(context);
    // List<Map<String, String>> list = [];
    // if (_doctorType == "") {
    //   setState(() {
    //     list = [];
    //   });
    // } else {
    //   // setState(() {
    //   //   list = docList.where((element) => element["type"] == _doctorType).toList();
    //   // });

    //   getDoctorList(_doctorType);
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctors List"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          // TextButton.icon(
          //   icon: const Icon(Icons.person),
          //   label: const Text(''),
          //   onPressed: () async {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => ProfilePage()),
          //     );
          //   },
          // ),
        ],
      ),
      body: loading
          ? const Center(
              child: SpinKitThreeBounce(color: primaryColor),
            )
          : Stack(
              children: <Widget>[
                Container(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(8.0),
                    child: Column(children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "Doctors List",
                          textScaleFactor: 2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: _deviceHeight * 0.3,
                        width: _deviceWidth,
                        padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.02),
                        child: ListView.builder(
                            addAutomaticKeepAlives: true,
                            controller: _scrollController,
                            itemCount: docList.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                dense: true,
                                visualDensity: VisualDensity(vertical: -3),
                                title: Container(
                                  width: _deviceWidth,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: _deviceWidth * 0.45,
                                        child: Text(
                                          docList[i].name,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        width: _deviceWidth * 0.4,
                                        child: Text(
                                          docList[i].doctype,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      // Container(
                                      //   width: _deviceWidth * 0.25,
                                      //   child: Text(
                                      //     list[i]["contact"]!,
                                      //     textAlign: TextAlign.start,
                                      //     style: TextStyle(fontSize: 12),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        // child: Table(
                        //   // textDirection: TextDirection.rtl,
                        //   // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                        //   // border:TableBorder.all(width: 2.0,color: Colors.red),
                        //   children: const [
                        //     TableRow(children: [
                        //       Text(
                        //         "Name",
                        //         textScaleFactor: 1.5,
                        //       ),
                        //       Text("Category", textScaleFactor: 1.5),
                        //       Text("Contact No.", textScaleFactor: 1.5),
                        //     ]),
                        //     TableRow(children: [
                        //       Text("Dr. Nimal Perera", textScaleFactor: 1.5),
                        //       Text("Councilor", textScaleFactor: 1.5),
                        //       Text("+94 71 864 4458", textScaleFactor: 1.5),
                        //     ]),
                        //     TableRow(children: [
                        //       Text("Dr. Sunil Perera", textScaleFactor: 1.5),
                        //       Text("Psychotherapist", textScaleFactor: 1.5),
                        //       Text("+94 71 864 4458", textScaleFactor: 1.5),
                        //     ]),
                        //     TableRow(children: [
                        //       Text("Dr. Kamal Bandara", textScaleFactor: 1.5),
                        //       Text("Psychiatric", textScaleFactor: 1.5),
                        //       Text("+94 71 864 4458", textScaleFactor: 1.5),
                        //     ]),
                        //   ],
                        // ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Column(children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Send Message to Doctor",
                            textScaleFactor: 2,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        DropdownButton<String>(
                          onChanged: (valueSelectedByUser) {
                            setState(() {
                              _docName = docList.firstWhere((element) => element.uid == valueSelectedByUser).name;
                              _docUID = valueSelectedByUser;
                            });
                          },
                          value: _docUID,
                          hint: const Text('Choose a doctor', style: TextStyle(color: Colors.black)),
                          items: docList.map((value) {
                            return DropdownMenuItem<String>(
                              value: value.uid,
                              child: Text(
                                value.name,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          key: _formKey,
                          // decoration: textInputDecoration.copyWith(hintText: 'email'),
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Message',
                            prefixIcon: const Icon(
                              Icons.email_rounded,
                              color: Colors.black,
                            ),
                          ),
                          validator: (val) => val!.isEmpty ? 'Enter message' : null,
                          onChanged: (val) {
                            setState(() => _message = val);
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent[700],
                              textStyle: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              // if(_formKey.currentState!.validate()){
                              if (_message.isNotEmpty) {
                                return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Your message sent successfully!'),
                                      actions: [
                                        // Submit button
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Color(0xFF6200EE),
                                          ),
                                          onPressed: () async {
                                            if (_message.isNotEmpty) {
                                              await createChat();
                                              _navigationService.navigateToPage(MLChatPage(
                                                initialMessage: _message,
                                                chat: chat,
                                              ));
                                            }
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              // }
                            },
                            child: const Padding(padding: EdgeInsets.all(15.0), child: Text('SEND'))),
                      ]),
                    ]),
                  ),
                ),
                // Container(
                //   child: SingleChildScrollView(
                //     padding: EdgeInsets.all(30.0),
                //     child: Form(
                //       key: _formKey,
                //       child: Column(
                //           children:<Widget>[
                //             const Padding(
                //               padding: EdgeInsets.all(8.0),
                //               child: Text("GSE Test",textScaleFactor: 2,style: TextStyle(fontWeight:FontWeight.bold),),
                //             ),
                //             const SizedBox(height: 15.0,),
                //
                //             DropdownButton<String>(
                //               // value: userType,
                //               // isDense: true,
                //               onChanged: (valueSelectedByUser) {
                //                 setState(() => _docName = valueSelectedByUser!);
                //               },
                //               // value: userType == "" ? ' ' : userType,
                //               hint: const Text('Choose a doctor',style: TextStyle(color: Colors.black)),
                //               items: <String>['Patient', 'Doctor', 'Admin'].map((String value) {
                //                 return DropdownMenuItem<String>(
                //                   value: value,
                //                   child: Text(value,style: TextStyle(color: Colors.black),),
                //                 );
                //               }).toList(),
                //             ),
                //             const SizedBox(height: 15.0,),
                //
                //             TextFormField(
                //               // decoration: textInputDecoration.copyWith(hintText: 'email'),
                //               decoration: textInputDecoration.copyWith(
                //                 hintText: 'Message',
                //                 prefixIcon: const Icon(
                //                   Icons.email_rounded,
                //                   color: Colors.black,
                //                 ),
                //               ),
                //               // validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                //               onChanged: (val) {
                //                 setState(() => _message = val);
                //               },
                //             ),
                //             const SizedBox(height: 15.0,),
                //
                //             MaterialButton(
                //                 child: const Padding(
                //                     padding: EdgeInsets.all(15.0),
                //                     child: Text('REGISTER')
                //                 ),
                //                 color: Colors.blueAccent[700],
                //                 textColor: Colors.white,
                //                 onPressed: () async {
                //                   if(_formKey.currentState!.validate()){
                //
                //                     return showDialog(
                //                       context: context,
                //                       builder: (context) {
                //                         return AlertDialog(
                //                           title: const Text('Your message sent successfully!'),
                //
                //                           actions: [
                //                             // Submit button
                //                             MaterialButton(
                //                               textColor: Color(0xFF6200EE),
                //                               onPressed: () {
                //                                 Navigator.push(
                //                                   context,
                //                                   MaterialPageRoute(builder: (context) => Home()),
                //                                 );
                //                               },
                //                               child: Text('OK'),
                //                             ),
                //                           ],
                //                         );
                //                       },
                //                     );
                //                   }
                //                 }
                //             ),
                //
                //           ]
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
    );
  }
}
