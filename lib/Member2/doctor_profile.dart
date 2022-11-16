import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mlvapp/Authenticate/login.dart';
import 'package:mlvapp/shared/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            child: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
          ),
          const SizedBox(height: 40),
          ProfileWidget(
            imagePath: "assets/images/doctor_profile.png",
            onClicked: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) => EditProfilePage()),
              // );
            },
          ),
          const SizedBox(height: 24),
          buildName(),
          const SizedBox(height: 48),
          buildAbout(),
        ],
      ),
    );
  }

  Widget buildName() => Column(
        children: const [
          Text(
            'Sarah Abs',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 4),
          Text(
            'sarah.abs@gmail.com',
            style: TextStyle(color: Colors.grey),
          )
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
