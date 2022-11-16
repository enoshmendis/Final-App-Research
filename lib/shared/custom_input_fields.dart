//packages
import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mlvapp/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final Function(String) validator;
  final String regEx;
  final String hintText;
  final bool obscureText;
  final IconData icon;

  const CustomTextFormField(
      {required this.onSaved,
      required this.validator,
      required this.hintText,
      required this.obscureText,
      required this.regEx,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (_value) => onSaved(_value!),
      cursorColor: textBlack,
      style: const TextStyle(
        color: textBlack,
      ),
      obscureText: obscureText,
      validator: (_value) => validator(_value!),
      //return RegExp(regEx).hasMatch(_value!) ? null : invalidText;

      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 18.0, 10.0, 18.0),
        fillColor: secondaryShade,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(
          icon,
          size: 30,
          color: primaryColor,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black54),
      ),
    );
  }
}

class PlainFormInputField extends StatelessWidget {
  final Function(String) onSaved;
  final Function(String) validator;
  final String hintText;
  final bool obscureText;
  final Color? color;
  final bool? isBordered;
  final bool? isEnabled;
  String? initialValue;
  TextInputType? keyboardType;
  Color? hintColor;

  PlainFormInputField({
    required this.onSaved,
    required this.validator,
    required this.hintText,
    required this.obscureText,
    this.color = secondaryShade,
    this.isBordered = true,
    this.initialValue,
    this.keyboardType,
    this.isEnabled,
    this.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnabled ?? true,
      keyboardType: keyboardType ?? TextInputType.name,
      maxLines: null,
      initialValue: initialValue,
      onSaved: (_value) => onSaved(_value!),
      cursorColor: textBlack,
      style: const TextStyle(
        color: textBlack,
      ),
      obscureText: obscureText,
      validator: (_value) => validator(_value!),
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 10,
          height: isBordered! ? 1 : 0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: isBordered!
              ? const BorderSide(
                  color: secondaryShade,
                  width: 1.5,
                )
              : BorderSide.none,
        ),
        labelText: isBordered! ? hintText : null,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 15.0),
        fillColor: color,
        filled: true,
        labelStyle: TextStyle(color: hintColor ?? Colors.black54),
        border: isBordered!
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
        hintStyle: TextStyle(color: hintColor ?? Colors.black54),
      ),
    );
  }
}

class DropdownFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String invalidText;
  final String hintText;
  final List<String> items;
  final bool iconInput;
  final IconData icon;
  String? value;

  DropdownFormField({
    required this.onSaved,
    required this.invalidText,
    required this.hintText,
    required this.items,
    required this.iconInput,
    required this.icon,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonFormField<String>(
        value: value,
        validator: (_value) {
          return _value != null ? null : invalidText;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10.0),
          alignLabelWithHint: true,
          prefixIcon: iconInput
              ? Icon(
                  icon,
                  size: 25,
                  color: Colors.black,
                )
              : null,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide.none,
          ),
        ),
        hint: Text(hintText),
        onChanged: (_value) => onSaved(_value!),
        onSaved: (_value) => onSaved(_value!),
        items: items
            .map(
              (label) => DropdownMenuItem(
                child: Text(label.toString()),
                value: label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final bool isOnChange;
  IconData? icon;
  Function(String)? onChanged;

  CustomTextField({
    required this.onEditingComplete,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.isOnChange,
    this.icon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
        onChanged: isOnChange ? (_value) => onEditingComplete(controller.value.text) : (_) => {},
        controller: controller,
        onEditingComplete: () {
          onEditingComplete(controller.value.text);
          FocusScope.of(context).unfocus();
        },
        cursorColor: primaryColor,
        style: const TextStyle(
          color: Colors.black,
        ),
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0.5),
          fillColor: secondaryShade,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black54,
          ),
          prefixIcon: Icon(
            icon,
            color: primaryColor,
          ),
        ));
  }

  String onChangeFunction() {
    onEditingComplete(controller.value.text);
    return "";
  }
}
