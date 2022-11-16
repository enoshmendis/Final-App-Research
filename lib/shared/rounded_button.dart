import 'package:flutter/material.dart';
import 'package:mlvapp/theme.dart';

class RoundedButton extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  final double radius;
  final Function onPressed;
  final double? fontSize;

  const RoundedButton(
      {required this.name,
      required this.height,
      required this.width,
      required this.radius,
      required this.onPressed,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize ?? 22,
            color: textWhite,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height * radius),
        gradient: const LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        color: primaryColor,
      ),
    );
  }
}

class RoundedSizedButton extends StatelessWidget {
  final String name;
  final double radius;
  final double fontSize;
  final Function onPressed;
  List<Color>? colorGradient;

  RoundedSizedButton({
    required this.name,
    required this.radius,
    required this.fontSize,
    required this.onPressed,
    this.colorGradient,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> gradient = [];
    if (colorGradient != null) {
      gradient = colorGradient!;
    } else {
      gradient = [primaryColor, secondaryColor];
    }
    return Container(
      height: fontSize * 2.3,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        child: Text(
          name,
          style: TextStyle(
            fontSize: fontSize,
            color: textWhite,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         colors: [primaryColor, secondaryColor],
  //         begin: Alignment.centerLeft,
  //         end: Alignment.centerRight,
  //       ),
  //       borderRadius: BorderRadius.circular(radius),
  //     ),
  //     child: ElevatedButton(
  //       onPressed: () => onPressed(),
  //       style: ElevatedButton.styleFrom(
  //         primary: Colors.transparent,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(radius),
  //         ),
  //       ),
  //       child: Text(
  //         name,
  //         style: TextStyle(
  //           fontSize: fontSize,
  //           color: textWhite,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
