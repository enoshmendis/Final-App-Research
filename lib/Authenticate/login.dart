import 'package:flutter/material.dart';
import 'package:mlvapp/Authenticate/register.dart';
import 'package:mlvapp/services/authentication.dart';
import 'package:mlvapp/services/database.dart';
import 'package:mlvapp/home.dart';
import 'package:mlvapp/shared/constants.dart';
import 'package:mlvapp/shared/loading.dart';
import 'package:provider/provider.dart';

import '../provider/authentication_provider.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  late AuthenticationProvider _authProvider;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    DatabaseService().initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthenticationProvider>(context);

    return loading
        ? Loading()
        : Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.blue,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0.0,
              title: const Text('Login'),
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/images/bg1.jpeg"))),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
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
                            height: 25.0,
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
                          const SizedBox(
                            height: 40.0,
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);
                                await _authProvider.loginUsingEmailAndPassword(email, password);
                                if (_authProvider.isError) {
                                  setState(() {
                                    loading = false;
                                    // error = 'Could not sign in with those credentials';
                                  });
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        content: Text('ERROR! Could not sign in with those credentials.'),
                                      );
                                    },
                                  );
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => Home()),
                                  // );
                                }
                              }
                            },
                            child: const Padding(padding: EdgeInsets.all(15.0), child: Text('LOGIN')),
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 255, 0, 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.red)),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Register()),
                              );
                            },
                            child: const Padding(padding: EdgeInsets.all(15.0), child: Text('REGISTER')),
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(0, 181, 188, 199),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.red)),
                            ),
                          )
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
