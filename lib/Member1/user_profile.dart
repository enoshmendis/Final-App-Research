import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mlvapp/Authenticate/login.dart';
import 'package:mlvapp/Member1/update_profile.dart';
import 'package:mlvapp/shared/profile_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _name = '';
  int _age = 0;
  String _gender = '';
  String _email = '';
  String _usertype = '';

  void userData() async {
    final User? user = _auth.currentUser;
    final useremail = user!.email;

    FirebaseFirestore.instance
        .collection('users')
        // .orderBy('detectionID', descending: true)
        .where('email', isEqualTo: useremail)
        .get()
        .then((results) async {
      if (results.docs.isNotEmpty) {
        setState(() {
          _name = results.docs[0].data()['name'];
          //_age = results.docs[0].data()['age'];
          //_gender = results.docs[0].data()['gender'];
          _email = results.docs[0].data()['email'];
          _usertype = results.docs[0].data()['usertype'];
        });
      }
    });
    // print(customer);
  }

  @override
  void initState() {
    super.initState();
    userData();
  }

  @override
  Widget build(BuildContext context) {
    // final user = UserPreferences.myUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mental Help App"),
        backgroundColor: Colors.green,
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
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 40),
          const Center(
            child: Text("User Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
          ),
          const SizedBox(height: 40),
          ProfileWidget(
            imagePath: _usertype != 'Doctor' ? "assets/images/defaultProfile.png" : "assets/images/doctor_profile.png",
            onClicked: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UpdateProfile()),
              );
            },
          ),
          const SizedBox(height: 24),
          buildName(),
          _usertype != 'Doctor' ? const SizedBox(height: 48) : buildAbout(),
        ],
      ),
    );
  }

  Widget buildName() => Column(
        children: [
          Text(
            _name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 4),
          Text(
            _email,
            style: TextStyle(color: Colors.blue, fontSize: 22),
          ),
          SizedBox(height: 10),
          // ListTile(
          //   title: Text(_age.toString(),
          //       style:
          //           const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          //   leading: const Text('Age: ',
          //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          // ),
          // ListTile(
          //   title: Text(_gender,
          //       style:
          //           const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          //   leading: const Text('Gender: ',
          //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          // ),
        ],
      );

  Widget buildAbout() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Certified Personal Trainer and Nutritionist with years of experience in creating effective diets and training plans focused on achieving individual customers goals in a smooth way.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
