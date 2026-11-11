import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/setting_view_page/api/setting_api.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/preference.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/utils.dart';
import 'package:rate_my_app/rate_my_app.dart';

class SettingController extends GetxController {
  // Future<void> launchUrlLink(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  RxBool isAutoScrollEnabled = Preference.isAutoScrollEnabled.obs;

  final RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'com.dramabest.story',
    appStoreIdentifier: '6757327901',
  );

  Future<void> showManualRating(BuildContext context) async {
    // Re-ensure init completed safely
    await rateMyApp.init();

    if (!context.mounted) return;

    await rateMyApp.showRateDialog(
      context,
      title: EnumLocal.rateThisApp.name.tr,
      message: EnumLocal.ifYouLikeThisApp.name.tr,
      rateButton: EnumLocal.rate.name.tr,
      noButton: EnumLocal.noThanks.name.tr,
      laterButton: EnumLocal.maybeLater.name.tr,
      listener: (button) {
        if (button == RateMyAppDialogButton.rate) {
          rateMyApp.launchStore();
        }
        return true;
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadSettings();
    rateMyApp.init();
  }

  Future<void> loadSettings() async {
    await SettingApi.callApi(); // API call
    // Do something with response if needed
  }

  Future<void> launchUrlLink(String value) async {
    var url = Uri.parse(value);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> onLogOut() async {
    if (Utils.getLoginTypeValue(LoginType.GOOGLE) == 2) {
      Utils.showLog("Google Logout Success");
      await GoogleSignIn().signOut();
    }
    Preference.clear();
    await Preference.onIsLogin(false);
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> onSwitchAutoScroll(bool value) async {
    log("Auto Scroll Switch toggled: OLD: ${isAutoScrollEnabled.value}, NEW: $value");
    isAutoScrollEnabled.value = value; // ✅ Correct way: just update value
    await Preference.setAutoScrollEnabled(value); // Save to local storage
  }

  /* Future<void> onLogOut() async {
    try {
      // ✅ Google Sign Out
      if (Utils.getLoginTypeValue(LoginType.GOOGLE) == 2) {
        final googleSignIn = GoogleSignIn();

        try {
          await googleSignIn.signOut();

          if (await googleSignIn.isSignedIn()) {
            await googleSignIn.disconnect();
          }

          if (googleSignIn.currentUser == null) {
            Utils.showLog("✅ Google Sign-Out Successful");
          } else {
            Utils.showLog("❌ Google Sign-Out Failed: User still logged in");
            return; // stop here if still logged in
          }
        } catch (e) {
          Utils.showLog("❌ Google Logout Error: $e");
          return; // stop here on failure
        }
      }

      // ✅ Local Data Clear
      await Preference.clear();
      await Preference.onIsLogin(false);

      // ✅ Navigate to Login Screen
      Utils.showLog("🔁 Navigating to login screen...");
      Get.offAllNamed(AppRoutes.login);
    } catch (e, st) {
      Utils.showLog("❌ Logout Exception: $e");
      Utils.showLog(st);
    }
  }*/
}
