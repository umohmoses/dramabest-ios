import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlurWidget extends StatelessWidget {
  final Widget child;
  final double blurAmount;
  final double? height;

  const BlurWidget({
    super.key,
    required this.child,
    this.height,
    this.blurAmount = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Get.height * 0.6,
      child: Stack(
        children: [
          child, //
          SizedBox(
            height: height ?? Get.height * 0.6,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
              child: Container(
                height: height ?? Get.height * 0.6,
                width: Get.width,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
