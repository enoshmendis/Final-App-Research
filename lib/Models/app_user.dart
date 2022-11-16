//packages

import 'dart:ffi';

class AppUser {
  final String uid;
  late String name;
  // final int age;
  final String email;
  // final String gender;
  final String usertype;
  final String doctype;
  late DateTime lastActive;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    // required this.age,
    // required this.gender,
    required this.usertype,
    required this.doctype,
    required this.lastActive,
  });

  factory AppUser.fromJSON(Map<String, dynamic> _json) {
    return AppUser(
      uid: _json["uid"],
      name: _json["name"] ?? "",
      email: _json["email"],
      // age: _json["age"],
      // gender: _json["gender"],
      usertype: _json["usertype"],
      doctype: _json["doctype"],
      lastActive: _json["last_active"].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      // 'age': age,
      // 'gender': gender,
      'usertype': usertype,
      'doctype': doctype,
      'email': email,
      "last_active": lastActive,
    };
  }

  String lastDayActive() {
    return "${lastActive.month}/${lastActive.day}/${lastActive.year}";
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 1;
  }
}
