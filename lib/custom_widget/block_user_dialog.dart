import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:story_box/custom_widget/custom_gradiant_text.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

void showBlockedUserDialog() {
  Get.dialog(
    WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF281238), Color(0xFF2B0612)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(36),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 115),
                  GradientText(
                    text: EnumLocal.txtThisUser.name.tr,
                    style: AppFontStyle.styleW700(AppColor.colorWhite, 28),
                    gradient: const LinearGradient(
                      colors: [Color(0xffFB7C61), Color(0xffFE3E9B)],
                    ),
                  ),
                  const SizedBox(height: 2),
                  GradientText(
                    text: EnumLocal.txtBlockedByAdmin.name.tr,
                    style: AppFontStyle.styleW700(AppColor.colorWhite, 28),
                    gradient: const LinearGradient(
                      colors: [Color(0xffFB7C61), Color(0xffFE3E9B)],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else if (Platform.isIOS) {
                        exit(0);
                      }
                    },
                    child: Container(
                      width: Get.width,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [Color(0xffFB7C61), Color(0xffFE3E9B)],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          EnumLocal.txtCloseApp.name.tr,
                          style: AppFontStyle.styleW600(AppColor.colorWhite, 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -35,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  AppAsset.icBlockTopIcon,
                  width: 285,
                  height: 161,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
