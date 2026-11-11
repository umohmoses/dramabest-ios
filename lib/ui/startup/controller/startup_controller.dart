import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:story_box/routes/app_routes.dart';

class StartupController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _forceResetNavigation();
  }

  void _forceResetNavigation() {
    // 1. Future.microtask for immediate queue execution before ui paints
    Future.microtask(() {
      Get.offAllNamed(AppRoutes.splash);
    });

    // 2. addPostFrameCallback to ensure reset after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(AppRoutes.splash);
    });
  }
}
