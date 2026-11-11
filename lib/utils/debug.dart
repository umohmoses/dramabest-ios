import 'dart:developer';

abstract class Debug {
  ///|>==|>==|> Set all debug variable false when you make release build. <|==<|==<|

  static const debug = false;
  static const isLocal = false;

  static void printLog(String tag, String str) {
    if (debug) log(":::TAG::: $tag -->> $str");
  }
}
