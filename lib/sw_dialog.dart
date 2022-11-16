import 'package:flutter/material.dart';

class SWDialog {
// user defined function

  late BuildContext context;

  SWDialog(BuildContext context) {
    this.context = context;
  }

  void displayDialog({required String title, required String bodyText}) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
            onWillPop: _willPopCallback,
            child: AlertDialog(
              title: new Text(title),
              content: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      bodyText,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  CircularProgressIndicator()
                ],
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
              ],
            ));
      },
    );
  }

  Future<bool> _willPopCallback() async {
    // await Show dialog of exit or what you want
    // then
    return true; //
  }

  void closeAlert() {
    Navigator.pop(context); //it will close last route in your navigator
  }
}