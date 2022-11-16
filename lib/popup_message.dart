import 'package:flutter/material.dart';

class PopupsMessage {
   SnackBar getSnackBar({required String message}) {
    return SnackBar(backgroundColor: Colors.green, content: Text(message));
  }
}