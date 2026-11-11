import 'package:flutter/material.dart';

import 'constant.dart';

abstract class AppFontStyle {
  /// customise style
  static TextStyle styleW400(Color? color, double? fontSize, {double? height}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      height: height,
      fontFamily: Constant.appFontFamily,
      fontWeight: FontWeight.w400, // Light
    );
  }

  static TextStyle styleW500(Color? color, double? fontSize, {double? height}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      height: height,
      fontFamily: Constant.appFontFamily,
      fontWeight: FontWeight.w500, // Medium
    );
  }

  static TextStyle styleW600(Color? color, double? fontSize, {double? height}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      height: height,
      fontFamily: Constant.appFontFamily,
      fontWeight: FontWeight.w600, // Regular
    );
  }

  static TextStyle styleW700(Color? color, double? fontSize, {double? height}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      height: height,
      fontFamily: Constant.appFontFamily,
      fontWeight: FontWeight.w700, // Bold
    );
  }

  static TextStyle styleW800(Color? color, double? fontSize, {double? height}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      height: height,
      fontFamily: Constant.appFontFamily,
      fontWeight: FontWeight.w800, // Bold
    );
  }

  static TextStyle styleW900(Color? color, double? fontSize, {double? height}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      height: height,
      fontFamily: Constant.appFontFamily,
      fontWeight: FontWeight.w900, // Bold
    );
  }

  static TextStyle customizeStyle({String? fontFamily, color, fontSize, fontWeight, height, decoration}) {
    return TextStyle(
      fontFamily: fontFamily,
      height: height,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
    );
  }
}
