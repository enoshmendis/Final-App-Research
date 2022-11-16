import 'package:flutter/material.dart';

double deviceHeight(BuildContext _context) {
  return MediaQuery.of(_context).size.height;
}

double deviceWidth(BuildContext _context) {
  return MediaQuery.of(_context).size.width;
}
