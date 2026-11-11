import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:story_box/main.dart';
import 'package:story_box/ui/profile_page/view/delete_account_view.dart';
import 'package:story_box/ui/setting_view_page/controller/setting_controller.dart';
import 'package:story_box/ui/setting_view_page/widget/setting_widget.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/custom_dialog.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';

class SettingViewPage extends StatelessWidget {
  SettingViewPage({super.key});

  final controller = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      appBar: AppBar(
        backgroundColor: AppColor.colorBlack,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            color: AppColor.transparent,
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColor.colorWhite,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          EnumLocal.setting.name.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: AppColor.colorWhite,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColor.bgGreyColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  SettingItemViewWidget(
                    onTap: () {
                      controller.launchUrlLink(Constant.termsOfUsePolicyLink);
                    },
                    text: EnumLocal.termsOfService.name.tr,
                  ),
                  Divider(
                    color: AppColor.greyColor.withValues(alpha: 0.4),
                  ),
                  SettingItemViewWidget(
                    onTap: () {
                      controller.launchUrlLink(Constant.privacyPolicyLink);
                    },
                    text: EnumLocal.privacyPolicy.name.tr,
                  ),
                  Divider(
                    color: AppColor.greyColor.withValues(alpha: 0.4),
                  ),
                  SettingItemViewWidget(
                    onTap: () async {
                      log("${Preference.userId} ");
                      Get.to(() => const DeleteAccountView());
                    },
                    text: EnumLocal.deleteAccount.name.tr,
                  ),
                  Divider(
                    color: AppColor.greyColor.withValues(alpha: 0.4),
                  ),
                  SettingItemViewWidget(
                    onTap: () {
                      controller.showManualRating(context);
                    },
                    text: EnumLocal.rateUs.name.tr,
                  ),
                  Divider(
                    color: AppColor.greyColor.withValues(alpha: 0.4),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: Row(
                      children: [
                        8.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              EnumLocal.txtAutoScroll.name.tr,
                              style: AppFontStyle.styleW600(AppColor.colorWhite, 16),
                            ),
                            2.height,
                          ],
                        ),
                        const Spacer(),
                        Obx(() => Switch(
                              value: controller.isAutoScrollEnabled.value,
                              activeColor: AppColor.colorWhite,
                              activeTrackColor: AppColor.primaryColor,
                              inactiveThumbColor: AppColor.colorWhite,
                              inactiveTrackColor: AppColor.greyColor,
                              onChanged: (val) async {
                                controller.onSwitchAutoScroll(val);
                              },
                            ))
                      ],
                    ),
                  ),
                  8.height,
                ],
              ),
            ),
          ),
          10.height,
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomDialog(
                    text: EnumLocal.areYouSureWantToLogout.name.tr,
                    buttonText: EnumLocal.logout.name.tr,
                    onTap: () {
                      controller.onLogOut();
                    },
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: const Color(0xff454446),
              minimumSize: Size(Get.width, 50),
            ),
            child: Text(
              EnumLocal.signOut.name.tr,
              style: TextStyle(fontSize: 16, color: AppColor.colorWhite),
            ),
          ).paddingAll(16),
        ],
      ),
    );
  }
}
