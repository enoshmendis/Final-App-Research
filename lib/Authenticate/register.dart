import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mlvapp/Authenticate/login.dart';
import 'package:mlvapp/Models/users.dart';
import 'package:mlvapp/services/authentication.dart';
import 'package:mlvapp/services/firestore_database.dart';
import 'package:mlvapp/shared/constants.dart';
import 'package:mlvapp/shared/custom_input_fields.dart';
import 'package:mlvapp/shared/loading.dart';

enum Gender { select, male, female, other }

enum UserType { select, patient, doctor }

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late double _deviceHeight;
  late double _deviceWidth;

  Gender? _genderRadioBtn = Gender.select;
  UserType? _userTypeBtn = UserType.select;

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
  String docType = '';

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0.0,
        title: const Text('Register'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/images/bg1.jpeg"))),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 60,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Name',
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter name...' : null,
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    // TextFormField(
                    //   // decoration: textInputDecoration.copyWith(hintText: 'contact number'),
                    //   keyboardType: TextInputType.number,
                    //   decoration: textInputDecoration.copyWith(
                    //     hintText: 'Age',
                    //     prefixIcon: const Icon(
                    //       Icons.numbers,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    //   validator: (val) => val!.isEmpty ? 'Enter age...' : null,
                    //   onChanged: (val) {
                    //     setState(() => age = int.parse(val));
                    //   },
                    // ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0) //                 <--- border radius here
                                ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Padding(
                          //   padding: EdgeInsets.all(8.0),
                          //   child: Text("Gender", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                          // ),
                          // FormField(
                          //   builder: (FormFieldState<bool> state) {
                          //     return Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Row(
                          //           // mainAxisAlignment: MainAxisAlignment.center,
                          //           children: <Widget>[
                          //             Radio<Gender>(
                          //               value: Gender.male,
                          //               groupValue: _genderRadioBtn,
                          //               onChanged: (Gender? value) {
                          //                 state.setValue(true);
                          //                 setState(() {
                          //                   _genderRadioBtn = value;
                          //                   gender = 'Male';
                          //                 });
                          //               },
                          //             ),
                          //             const Text("Male", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),

                          //             Radio<Gender>(
                          //               value: Gender.female,
                          //               groupValue: _genderRadioBtn,
                          //               onChanged: (Gender? value) {
                          //                 state.setValue(true);
                          //                 setState(() {
                          //                   _genderRadioBtn = value;
                          //                   gender = 'Female';
                          //                 });
                          //               },
                          //             ),
                          //             const Text("Female",
                          //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), //

                          //             Radio<Gender>(
                          //               value: Gender.other,
                          //               groupValue: _genderRadioBtn,
                          //               onChanged: (Gender? value) {
                          //                 state.setValue(true);
                          //                 setState(() {
                          //                   _genderRadioBtn = value;
                          //                   gender = 'Other';
                          //                 });
                          //               },
                          //             ),
                          //             const Text(
                          //               "Other",
                          //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                          //             ),
                          //           ],
                          //         ),
                          //         state.hasError
                          //             ? Container(
                          //                 margin: EdgeInsets.symmetric(horizontal: 10),
                          //                 child: Text(
                          //                   state.errorText!,
                          //                   style: const TextStyle(color: Colors.red),
                          //                 ),
                          //               )
                          //             : Container()
                          //       ],
                          //     );
                          //   },
                          //   validator: (value) {
                          //     if (value != true) {
                          //       return 'Please select gender';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "User Type",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                          ),
                          FormField(
                            builder: (FormFieldState<bool> state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Radio(
                                        value: UserType.patient,
                                        groupValue: _userTypeBtn,
                                        onChanged: (UserType? value) {
                                          state.setValue(true);
                                          setState(() {
                                            _userTypeBtn = value;
                                            userType = 'Patient';
                                          });
                                        },
                                      ),
                                      const Text("Patient",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),

                                      Radio(
                                        value: UserType.doctor,
                                        groupValue: _userTypeBtn,
                                        onChanged: (UserType? value) {
                                          state.setValue(true);
                                          setState(() {
                                            _userTypeBtn = value;
                                            userType = 'Doctor';
                                          });
                                        },
                                      ),
                                      const Text("Doctor",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  16.0)), //, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)
                                    ],
                                  ),
                                  state.hasError
                                      ? Container(
                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            state.errorText!,
                                            style: const TextStyle(color: Colors.red),
                                          ),
                                        )
                                      : Container()
                                ],
                              );
                            },
                            validator: (value) {
                              if (value != true) {
                                return 'Please select user type';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    userType == "Doctor"
                        ? Column(
                            children: [
                              DropdownFormField(
                                icon: Icons.medical_services,
                                iconInput: true,
                                hintText: "Specialty",
                                onSaved: (_value) {
                                  setState(
                                    () {
                                      docType = _value;
                                    },
                                  );
                                },
                                invalidText: "Please select specialty.",
                                items: ["Counselor", "Psychotherapist", "Psychiatric"],
                              ),
                            ],
                          )
                        : Container(),
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
                      validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                      ),
                      obscureText: true,
                      validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() => loading = true);
                          dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              loading = false;
                              // error = 'Please supply a valid email';
                            });
                            return showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Text('ERROR! Please supply a valid email.'),
                                );
                              },
                            );
                          } else {
                            setState(() {
                              loading = false;
                            });

                            if (userType == "Doctor") {
                              FirebaseDatabase().addUsersData(result.uid!, name, userType, email, docType);
                            } else {
                              FirebaseDatabase().addUsersData(result.uid!, name, userType, email, "");
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LogIn()),
                            );
                          }
                        }
                      },
                      child: const Padding(padding: EdgeInsets.all(15.0), child: Text('REGISTER')),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.red)),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogIn()),
                        );
                      },
                      child: const Padding(padding: EdgeInsets.all(15.0), child: Text('LOGIN')),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.red)),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
          ),
          loading
              ? Container(
                  height: _deviceHeight,
                  width: _deviceWidth,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                  ),
                  child: const SpinKitChasingDots(
                    color: Colors.blue,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
