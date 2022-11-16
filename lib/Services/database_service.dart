import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/app_user.dart';

const String USER_COLLECTION = "users";
const String LOGS_COLLECTION = "logRecTest";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  



  Future<void> addUsersData(String _uid, String name, int age, String gender, String usertype, String email) async {
    return await _db.collection(USER_COLLECTION).doc(_uid).set({
      'name': name,
      'age': age,
      'gender': gender,
      'usertype': usertype,
      'email': email,
    });
  }
}
