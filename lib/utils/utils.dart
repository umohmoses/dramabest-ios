import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
// import 'package:logger/logger.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';

class Utils {
  static const sandboxVerifyReceiptUrl = false;
  static const revenueCatAndroidApiKey = "goog_DHjhirEjKWgvfgQCUVjGeevasqS";
  static const revenueCatAppleApiKey = "your_revenueCat_iOS_api_key";

  /// =================== Toast =================== ///
  static Future<bool?> showToast(BuildContext context, String msg, {ToastGravity gravity = ToastGravity.BOTTOM}) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      backgroundColor: AppColor.colorBlack,
      textColor: AppColor.colorWhite,
      fontSize: 15,
    );
  }

  /// =================== Current Focus Node =================== ///
  static void currentFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  static int getLoginTypeValue(LoginType type) {
    switch (type) {
      case LoginType.MOBILE_NUMBER:
        return 1;
      case LoginType.GOOGLE:
        return 2;
      case LoginType.QUICK:
        return 3;
      case LoginType.APPLE:
        return 4;
      case LoginType.EMAIL:
        return 5;
      // Default case if needed
    }
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  /// =================== Lunch URL =================== ///
  // static Future<void> launchURL(String value) async {
  //   var url = Uri.parse(value);
  //   if (await canLaunchUrl(url)) {
  //     launchUrl(url);
  //   } else {
  //     Utils.showToast(Get.context!, "Web page can't loaded");
  //     throw "Cannot load the page";
  //   }
  // }

  /// =================== Clipboard (Copy Text) =================== ///
  static void copyText(String text) {
    // FlutterClipboard.copy(text);
  }

  /// =================== Console Log =================== ///
  // static final Logger _logger = Logger();

  // static void showLog(String text, {LogLevels level = LogLevels.info, dynamic error, StackTrace? stackTrace}) {
  //   switch (level) {
  //     case LogLevels.trace:
  //       _logger.t(text);
  //       break;
  //     case LogLevels.debug:
  //       _logger.d(text);
  //       break;
  //     case LogLevels.info:
  //       _logger.i(text);
  //       break;
  //     case LogLevels.warning:
  //       _logger.w(text);
  //       break;
  //     case LogLevels.error:
  //       _logger.e(text, error: error, stackTrace: stackTrace);
  //       break;
  //     case LogLevels.fatal:
  //       _logger.f(text, error: error, stackTrace: stackTrace);
  //       break;
  //   }
  // }
  static void showLog(String text) {
    return log(text);
  }

  static String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date).toLocal();
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  static String formatDateTime(String date) {
    DateTime dateTime = DateTime.parse(date).toLocal();
    return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
  }
}

enum LogLevels {
  trace,
  debug,
  info,
  warning,
  error,
  fatal,
}

class CustomFormatNumber {
  static String convert(int number) {
    if (number >= 1000000) {
      // Handle 1 million and above
      return '${(number / 1000000).toStringAsFixed(2)}m';
    } else if (number >= 1000) {
      // Handle thousands
      return '${(number / 1000).toStringAsFixed(2)}k';
    } else {
      // Handle less than a thousand
      return number.toString();
    }
  }
}
