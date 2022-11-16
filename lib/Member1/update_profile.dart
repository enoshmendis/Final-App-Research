import 'package:flutter/material.dart';
import 'package:mlvapp/Authenticate/login.dart';
import 'package:mlvapp/Member1/user_profile.dart';
import 'package:mlvapp/services/authentication.dart';
import 'package:mlvapp/services/firestore_database.dart';
import 'package:mlvapp/shared/constants.dart';
import 'package:mlvapp/shared/loading.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String name = '';
  late int age;
  String gender = '';
  String userType = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blueGrey[300],
            appBar: AppBar(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.black,
              elevation: 0.0,
              title: const Text('Mental Help'),
            ),
            body: Stack(
              children: <Widget>[
                // Container(
                //   decoration: const BoxDecoration(
                //       image: DecorationImage(
                //           fit: BoxFit.cover,
                //           image: AssetImage("assets/images/register_background.jpg"))),
                //   ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Name',
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter name...' : null,
                            onChanged: (val) {
                              setState(() => name = val);
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            // decoration: textInputDecoration.copyWith(hintText: 'contact number'),
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Age',
                              prefixIcon: const Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter age...' : null,
                            onChanged: (val) {
                              setState(() => age = int.parse(val));
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            // decoration: textInputDecoration.copyWith(hintText: 'contact number'),
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Gender',
                              prefixIcon: const Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter gender...' : null,
                            onChanged: (val) {
                              setState(() => gender = val);
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            // decoration: textInputDecoration.copyWith(hintText: 'contact number'),
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Marital Status',
                              // prefixIcon: const Icon(
                              //   Icons.phone,
                              //   color: Colors.black,
                              // ),
                            ),
                            // validator: (val) => val!.isEmpty ? 'Enter gender...' : null,
                            onChanged: (val) {
                              // setState(() => gender = val);
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            // decoration: textInputDecoration.copyWith(hintText: 'contact number'),
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Educational Level',
                              // prefixIcon: const Icon(
                              //   Icons.phone,
                              //   color: Colors.black,
                              // ),
                            ),
                            // validator: (val) => val!.isEmpty ? 'Enter gender...' : null,
                            onChanged: (val) {
                              // setState(() => gender = val);
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            // decoration: textInputDecoration.copyWith(hintText: 'contact number'),
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Employee Status',
                              // prefixIcon: const Icon(
                              //   Icons.phone,
                              //   color: Colors.black,
                              // ),
                            ),
                            // validator: (val) => val!.isEmpty ? 'Enter gender...' : null,
                            onChanged: (val) {
                              // setState(() => gender = val);
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            // decoration: textInputDecoration.copyWith(hintText: 'email'),
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Email',
                              prefixIcon: const Icon(
                                Icons.email_rounded,
                                color: Colors.black,
                              ),
                            ),
                            // validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            children: const <Widget>[
                              Expanded(
                                child: Divider(
                                  color: Colors.white,
                                  height: 8.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                              child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text('SUBMIT')),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent[700],
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 20),
                                  textStyle: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // setState(() => loading = true);
                                  // dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                                  //   setState(() {
                                  //     loading = false;
                                  //     // error = 'Please supply a valid email';
                                  //   });
                                  //   return showDialog(
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return const AlertDialog(
                                  //         content: Text('ERROR! Please supply a valid email.'),
                                  //       );
                                  //     },
                                  //   );
                                  // FirebaseDatabase().addUsersData(name, age, gender, userType, email);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserProfile()),
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
