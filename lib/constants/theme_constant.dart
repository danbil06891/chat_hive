import 'dart:math';
import 'package:chathive/constants/color_constant.dart';
import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
    primarySwatch: _generateMaterialColor(secondaryColor),
    fontFamily: 'monstserrat',
    // textTheme: textTheme(),
  );
}

MaterialColor _generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: _tintColor(color, 0.9),
    100: _tintColor(color, 0.8),
    200: _tintColor(color, 0.6),
    300: _tintColor(color, 0.4),
    400: _tintColor(color, 0.2),
    500: color,
    600: _shadeColor(color, 0.1),
    700: _shadeColor(color, 0.2),
    800: _shadeColor(color, 0.3),
    900: _shadeColor(color, 0.4),
  });
}

int _tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color _tintColor(Color color, double factor) => Color.fromRGBO(
    _tintValue(color.red, factor),
    _tintValue(color.green, factor),
    _tintValue(color.blue, factor),
    1);

int _shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color _shadeColor(Color color, double factor) => Color.fromRGBO(
    _shadeValue(color.red, factor),
    _shadeValue(color.green, factor),
    _shadeValue(color.blue, factor),
    1);

class CustomFont {
  static const boldText = TextStyle(
    fontSize: 25,
    fontFamily: 'monstserrat',
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    color: Colors.white,
    letterSpacing: 0,
    // height: 1.1,
  );
  static const mediumText = TextStyle(
    fontSize: 25,
    fontFamily: 'monstserrat',
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    color: Colors.black,
    letterSpacing: 0,
    height: 1.2,
  );
  static const regularText = TextStyle(
    fontSize: 15,
    fontFamily: 'monstserrat',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: Colors.black,
    letterSpacing: 0,
    height: 1.2,
  );
  static const lightText = TextStyle(
    fontSize: 12,
    fontFamily: 'monstserrat',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0,
    // height: 1.1,
  );
}
