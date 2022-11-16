//Packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:mlvapp/services/firestore_database.dart';
import 'package:mlvapp/services/navigation_service.dart';

//Model
import '../Models/app_user.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final FirebaseDatabase _databaseService;

  late AppUser user;

  late bool isError = false;
  late String error;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;

    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<FirebaseDatabase>();

    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        _databaseService.updateUserLastSeenTime(_user.uid);
        _databaseService.getUser(_user.uid).then((_snapshot) {
          if (_snapshot.data() == null) {
            _navigationService.navigateToRoute("/login");
          } else {
            Map<String, dynamic> _userData = _snapshot.data()! as Map<String, dynamic>;

            user = AppUser.fromJSON(
              {
                "uid": _user.uid,
                "name": _userData["name"],
                "email": _userData["email"],
                // "age": _userData["age"],
                // "gender": _userData["gender"],
                "usertype": _userData["usertype"],
                "doctype": _userData["doctype"],
                "last_active": _userData["last_active"],
              },
            );

            _navigationService.removeAndNavigateToRoute('/home');
          }
        });
      } else {
        _navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      isError = false;
      error = "";
    } on FirebaseAuthException catch (e) {
      print("Error Login User Into Firebase");
      isError = true;
      error = "Either user does not exist or Your email and password does not match";
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(String _email, String _password) async {
    try {
      UserCredential _credentials = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);

      return _credentials.user!.uid;
    } on FirebaseAuthException catch (e) {
      print("Error Registering User.");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
