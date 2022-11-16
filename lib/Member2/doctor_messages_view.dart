import 'package:flutter/material.dart';
import 'package:mlvapp/Authenticate/login.dart';
import 'package:mlvapp/Member3/sound_therapy.dart';
import 'package:mlvapp/shared/constants.dart';

class DoctorMessageView extends StatefulWidget {
  const DoctorMessageView({Key? key}) : super(key: key);

  @override
  _DoctorMessageViewState createState() => _DoctorMessageViewState();
}

class _DoctorMessageViewState extends State<DoctorMessageView> {
  // final AuthService _auth = AuthService();

  // Widget _buildListItem(BuildContext context, DocumentSnapshot document){
  //   String _collector = '';
  //
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8.0),
  //     child: Card(
  //       margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
  //       child: Column(
  //         children: [
  //           ListTile(
  //             leading: Image.network(document['image'],height: 200),
  //             title: Text(document['name']),
  //             subtitle: Text('${document['address']} \nGarbage Collector: ${document['assigned_to']}'),
  //           ),
  //           // Padding(
  //           //   padding: const EdgeInsets.all(16.0),
  //           //   child: Row(
  //           //       children: [
  //           //         //// verify status
  //           //         document['verify'] == true ? Text.rich(
  //           //           TextSpan(
  //           //             style: TextStyle(
  //           //                 fontSize: 16,
  //           //                 color: Colors.green
  //           //             ),
  //           //             children: [
  //           //               TextSpan(
  //           //                 text: 'Verified',
  //           //               ),
  //           //               WidgetSpan(
  //           //                 child: Icon(Icons.check_circle_outlined, color : Colors.green),
  //           //               ),
  //           //             ],
  //           //           ),
  //           //         ) : Text.rich(
  //           //           TextSpan(
  //           //             style: TextStyle(
  //           //                 fontSize: 16,
  //           //                 color: Colors.red
  //           //             ),
  //           //             children: [
  //           //               TextSpan( text: 'Not Verified',),
  //           //               WidgetSpan(child: Icon(Icons.cancel_outlined, color : Colors.red) ),
  //           //             ],
  //           //           ),
  //           //         ),
  //           //
  //           //         SizedBox(width: 30.0),
  //           //         //// collected status
  //           //         document['collected'] == true ? Text.rich(
  //           //           TextSpan(
  //           //             style: TextStyle(
  //           //                 fontSize: 16,
  //           //                 color: Colors.green
  //           //             ),
  //           //             children: [
  //           //               TextSpan(
  //           //                 text: 'Garbage Collected',
  //           //               ),
  //           //               WidgetSpan(
  //           //                 child: Icon(Icons.check_circle_outlined, color : Colors.green),
  //           //               ),
  //           //             ],
  //           //           ),
  //           //         ) : Text.rich(
  //           //           TextSpan(
  //           //             style: TextStyle(
  //           //                 fontSize: 16,
  //           //                 color: Colors.red
  //           //             ),
  //           //             children: [
  //           //               TextSpan( text: 'Garbage Not Collected',),
  //           //               WidgetSpan(child: Icon(Icons.cancel_outlined, color : Colors.red) ),
  //           //             ],
  //           //           ),
  //           //         ),
  //           //       ]
  //           //   ),
  //           // ),
  //           //
  //           // ButtonBar(
  //           //   alignment: MainAxisAlignment.start,
  //           //   children: [
  //           //     MaterialButton(
  //           //       textColor: const Color(0xFF6200EE),
  //           //       onPressed: () {
  //           //         // Perform some action
  //           //         showDialog(
  //           //           context: context,
  //           //           builder: (context) {
  //           //             return AlertDialog(
  //           //               title: Text('Allocate Collectors?'),
  //           //               content: TextFormField(
  //           //                 decoration: textInputDecoration.copyWith(hintText: 'garbage collector name'),
  //           //                 validator: (val) => val.isEmpty ? 'Enter garbage collector name' : null,
  //           //                 onChanged: (val) {
  //           //                   setState(() => _collector = val);
  //           //                 },
  //           //               ),
  //           //
  //           //               actions: [
  //           //                 // Cancel button
  //           //                 MaterialButton(
  //           //                   textColor: Color(0xFF6200EE),
  //           //                   onPressed: () { Navigator.of(context).pop(); },
  //           //                   child: Text('CANCEL'),
  //           //                 ),
  //           //
  //           //                 // Submit button
  //           //                 MaterialButton(
  //           //                   textColor: Color(0xFF6200EE),
  //           //                   onPressed: () {
  //           //                     // updating the detection record to set the collector
  //           //                     FirebaseFirestore.instance.collection('detections').doc("${document.id}")
  //           //                         .update({'assigned_to': _collector})
  //           //                         .whenComplete(() async {
  //           //                       print("Completed");
  //           //                     }).catchError((e) => print(e));
  //           //
  //           //                     Navigator.of(context).pop();
  //           //                   },
  //           //                   child: Text('SUBMIT'),
  //           //                 ),
  //           //               ],
  //           //             );
  //           //           },
  //           //         );
  //           //
  //           //       },
  //           //       child: const Text('Allocate Collectors'),
  //           //     )
  //           //   ],
  //           // ),
  //         ],
  //       ),
  //
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: const <Widget>[
              // Icon(Icons.delete_forever_outlined),
              Text('Mental Health'),
            ],
          ),
          backgroundColor: Colors.lightGreen[800],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('logout'),
              onPressed: () async {
                // await _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogIn()),
                );
              },
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Center(
                    child: Text("Patients Messages",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0)),
                  ),
                  // const Text("Patients Messages", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
                  Card(
                      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                      child: Column(children: [
                        ListTile(
                          // leading: Text('Patient: Peter'),
                          title: Text('Patient: Peter'),
                          subtitle: Text('testestesttesttets'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Reply'),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      TextFormField(
                                        // decoration: textInputDecoration.copyWith(hintText: 'email'),
                                        decoration:
                                            textInputDecoration.copyWith(
                                          hintText: 'Message',
                                          prefixIcon: const Icon(
                                            Icons.email_rounded,
                                            color: Colors.black,
                                          ),
                                        ),
                                        // validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                                        onChanged: (val) {
                                          // setState(() => _message = val);
                                        },
                                      ),
                                      // const SizedBox(
                                      //   height: 25.0,
                                      // ),
                                      // Text('Average price for Salaya is 100.00')
                                    ],
                                  ),
                                  actions: [
                                    // Submit button
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'SEND',
                                        selectionColor: Color(0xFF6200EE),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ])),
                  ListTile(
                    // leading: Text('Patient: Peter'),
                    title: Text('Patient: Peter'),
                    subtitle: Text('testestesttesttets'),
                  ),
                ]))
        // body: StreamBuilder(
        //   stream: FirebaseFirestore.instance.collection('detections').snapshots(),
        //   builder: (context, snapshot){
        //     if(!snapshot.hasData) return const Text('Loading...');
        //     return ListView.builder(
        //       // itemExtent: 80.0,
        //       itemCount: snapshot.data.documents.length,
        //       itemBuilder: (context, index) =>
        //           _buildListItem(context , snapshot.data.documents[index]),
        //     );
        //   },
        // ),
        );
  }
}
