// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:story_box/utils/color.dart';

class ProgressDialog extends StatelessWidget {
  bool? inAsyncCall;
  final Color? color;

  ProgressDialog({
    super.key,
    this.inAsyncCall,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (inAsyncCall ?? false) {
      return SpinKitCircle(
        color: color ?? AppColor.colorWhite,
        size: 60,
      );
    }
    return const SizedBox();
  } /*  @override
  Widget build(BuildContext context) {
    if (inAsyncCall!) {
      return  const SizedBox(
        width: 200,
        height: 200,
        child: Center(
            child: SizedBox(
                height: 100,
                width: 100,
                child:  CircularProgressIndicator())),
      );
    }
    return const SizedBox();
  }*/
}
