import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  Label({
    Key? key,
    required this.labelColor,
    required this.label,
    this.fontSize,
    this.borderColor,
    this.isBordered,
  }) : super(key: key);

  final Color? labelColor;
  Color? borderColor;
  final String? label;
  double? fontSize;
  bool? isBordered;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(
            color: isBordered != null
                ? borderColor ?? Colors.transparent
                : Colors.transparent,
          ),
          color: labelColor,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Text(
        label!,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: labelColor == Colors.white ? Colors.black : Colors.white,
            fontSize: fontSize),
      ),
    );
  }
}
