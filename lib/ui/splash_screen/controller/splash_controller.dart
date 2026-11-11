import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:story_box/notification/notification_service.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/login_page/model/login_user_model.dart';
import 'package:story_box/ui/profile_page/api/profile_api.dart';
import 'package:story_box/ui/setting_view_page/api/setting_api.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreenController extends GetxController {
  bool isLoading = false;
  LoginUserModel? loginUserModel;

  @override
  Future<void> onInit() async {
    NotificationServices.initFirebase();

    checkForceUpdate();

    super.onInit();
  }

  bool isUpdateRequired(String current, String latest) {
    final currentParts = current.split('.').map(int.parse).toList();
    final latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (currentParts[i] < latestParts[i]) return true;
      if (currentParts[i] > latestParts[i]) return false;
    }
    return false;
  }

  Future<void> checkForceUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    Utils.showLog("Current version ==> ${packageInfo.version}");
    // 🔴 Replace this with API response

    final latestVersion = Platform.isIOS ? SettingApi.setting?.iosAppVersion ?? "" : SettingApi.setting?.androidAppVersion ?? "";
    Utils.showLog("Latest  version ==> $latestVersion");
    if (latestVersion.isEmpty) {
      Utils.showLog("⚠️ Latest version missing from API");
      Future.delayed(const Duration(seconds: 3), () async {
        if (Preference.isLogin) {
          Get.offAllNamed(AppRoutes.bottomBarPage);
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
      });
      Utils.showLog("Preference.isLogin${Preference.isLogin}");
      loginUserModel = await ProfileApi.callApi();

      if (loginUserModel?.message == "User does not found!") {
        Utils.showToast(Get.context!, EnumLocal.txtUserDoesNotFound.name.tr);
        Preference.clear();
        Preference.clearWatchedVideos();
        GoogleSignIn().signOut();
        log("not found");
        Get.offAllNamed(AppRoutes.login);

        return;
      }
      return;
    }
    if (isUpdateRequired(currentVersion, latestVersion)) {
      Get.dialog(
        const ForceUpdateDialog(),
        barrierDismissible: false, // ❌ outside tap disabled
      );
    } else {
      Future.delayed(const Duration(seconds: 3), () async {
        if (Preference.isLogin) {
          Get.offAllNamed(AppRoutes.bottomBarPage);
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
      });

      log("Preference.isLogin${Preference.isLogin}");
      loginUserModel = await ProfileApi.callApi();

      if (loginUserModel?.message == "User does not found!") {
        Utils.showToast(Get.context!, EnumLocal.txtUserDoesNotFound.name.tr);
        Preference.clear();
        Preference.clearWatchedVideos();
        GoogleSignIn().signOut();
        log("not found");
        Get.offAllNamed(AppRoutes.login);

        return;
      }
    }
  }
}

class ForceUpdateDialog extends StatelessWidget {
  const ForceUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColor.primaryColor.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Icon Container
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColor.primaryColor.withValues(alpha: 0.2),
                        AppColor.primaryColor.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.system_update_alt_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Title
                Text(
                  EnumLocal.txtUpdateAvailable.name.tr,
                  style: AppFontStyle.styleW700(AppColor.colorBlack, 24),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  EnumLocal.txtWeHaveMadeImprovementsToEnhanceYourExperienceUpdateNowToAccessTheLatestFeatures.name.tr,
                  style: AppFontStyle.styleW400(
                    AppColor.colorBlack.withValues(alpha: 0.7),
                    15,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Update Button with gradient
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryColor,
                        AppColor.primaryColor.withValues(alpha: 0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryColor.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _openStore,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          EnumLocal.txtUpdateNow.name.tr,
                          style: AppFontStyle.styleW600(Colors.white, 16),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Version info
                Text(
                  EnumLocal.txtRequiredForContinuedAccess.name.tr,
                  style: AppFontStyle.styleW400(
                    AppColor.colorBlack.withValues(alpha: 0.5),
                    12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openStore() async {
    String url = Platform.isAndroid ? SettingApi.setting?.androidAppLink ?? "" : SettingApi.setting?.iosAppLink ?? "";
    if (url.isEmpty && Platform.isAndroid) url = "https://play.google.com/store/apps/details?id=com.dramabest.story";
    if (url.isEmpty) return;

    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
