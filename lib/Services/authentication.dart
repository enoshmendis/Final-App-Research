import 'package:firebase_auth/firebase_auth.dart';
import 'package:mlvapp/Models/users.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  LogUsers? _userFromFirebaseUser(User? user) {
    if (user != null) {
      return LogUsers(uid: user.uid);
    } else {
      return null;
    }
  }

  // auth change user stream
  Stream<LogUsers?> get user {
    return _auth.authStateChanges()
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;
      // AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      // FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      User? user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user;
      // AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // FirebaseUser user = result.user;
      print(user);
      // create a new document for the user with the uid
      // await DatabaseService(uid: user.uid).updateUserData('0','new crew member', 100);
      return _userFromFirebaseUser(user!);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}