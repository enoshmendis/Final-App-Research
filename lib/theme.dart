import 'package:flutter/material.dart';

//const primaryColor = Color.fromRGBO(170, 40, 255, 1.0);
const primaryColor = Colors.blue;
//onst secondaryColor = Color.fromRGBO(111, 0, 255, 1.0);
const secondaryColor = Color.fromARGB(255, 50, 132, 255);
const secondaryShade = Color.fromARGB(102, 140, 186, 255);
const accentBackground = Color.fromARGB(102, 140, 209, 255);
//const background = Color.fromRGBO(255, 255, 255, 1.0);
const background = Color.fromRGBO(247, 247, 247, 1.0);
const navigationBar = Color.fromRGBO(238, 238, 238, 1.0);
const secondaryBackground = Color.fromRGBO(204, 204, 204, 0.5);

const textBlack = Colors.black;
const textWhite = Colors.white;

Map<int, Color> primaryCodes = {
  50: Color.fromRGBO(33, 150, 243, 0.1),
  100: Color.fromRGBO(50, 132, 255, 0.2),
  200: Color.fromRGBO(33, 150, 243, 0.3),
  300: Color.fromRGBO(50, 132, 255, 0.4),
  400: Color.fromRGBO(50, 132, 255, 0.5),
  500: Color.fromRGBO(50, 132, 255, 0.6),
  600: Color.fromRGBO(50, 132, 255, 0.7),
  700: Color.fromRGBO(50, 132, 255, 0.8),
  800: Color.fromRGBO(50, 132, 255, 0.9),
  900: Color.fromRGBO(50, 132, 255, 1.0),
};
// Green color code: FF93cd48
MaterialColor primaryMaterialColor = MaterialColor(0xFF2767B0, primaryCodes);

Map<int, Color> secondaryCodes = {
  50: Color.fromRGBO(50, 132, 255, 0.1),
  100: Color.fromRGBO(50, 132, 255, 0.2),
  200: Color.fromRGBO(50, 132, 255, 0.3),
  300: Color.fromRGBO(50, 132, 255, 0.4),
  400: Color.fromRGBO(50, 132, 255, 0.5),
  500: Color.fromRGBO(50, 132, 255, 0.6),
  600: Color.fromRGBO(50, 132, 255, 0.7),
  700: Color.fromRGBO(50, 132, 255, 0.8),
  800: Color.fromRGBO(50, 132, 255, 0.9),
  900: Color.fromRGBO(50, 132, 255, 1.0),
};
// Green color code: FF93cd48
MaterialColor secondaryMaterialColor = MaterialColor(0xFF104D9E, secondaryCodes);
