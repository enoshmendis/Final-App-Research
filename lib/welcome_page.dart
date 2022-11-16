import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'provider/authentication_provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);

    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return _buildUI();
  }

  Widget _buildUI() {
    return Container(
      color: Colors.white,
      height: _deviceHeight,
      width: _deviceWidth,
      child: const Center(
        child: SpinKitThreeBounce(
          color: Colors.blue,
        ),
      ),
    );
  }
}
