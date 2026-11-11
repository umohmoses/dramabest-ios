import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/profile_page/api/delete_account_api.dart';
import 'package:story_box/ui/profile_page/controller/profile_controller.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/dummy_data.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  final controller = Get.find<ProfileController>();

  @override
  void initState() {
    controller.remainingTime.value = 10;
    controller.isChecked = false;
    controller.startTimer();
    super.initState();
  }

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
          EnumLocal.attention.name.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attention List
            Expanded(
              child: ListView.builder(
                itemCount: DummyData.attention.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 6,
                      ).paddingOnly(top: 5),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          DummyData.attention[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GetBuilder<ProfileController>(
              builder: (controller) {
                return GestureDetector(
                  onTap: () {
                    controller.isChecked = !controller.isChecked;
                    controller.update();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        controller.isChecked ? Icons.check_circle_outlined : Icons.circle_outlined,
                        color: controller.isChecked ? AppColor.primaryColor : AppColor.greyColor,
                        size: 18,
                      ),
                      4.width,
                      Flexible(
                        child: Text(
                          EnumLocal.iHaveReadAndAgreeToTheAboveContent.name.tr,
                          style: AppFontStyle.styleW500(AppColor.greyColor, 14.5),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            16.height,
            Obx(
              () => ElevatedButton(
                onPressed: controller.remainingTime.value == 0
                    ? () async {
                        await onDelete();
                      }
                    : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.remainingTime.value == 0 ? AppColor.primaryColor : AppColor.primaryColor.withValues(alpha: .16),
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    controller.remainingTime.value == 0 ? EnumLocal.deleteAccount.name.tr : "${EnumLocal.deleteAccount.name.tr} (${controller.remainingTime.value}s)",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onDelete() async {
    if (controller.isChecked) {
      final response = await DeleteUserApi.callApi(userId: Preference.userId);
      if (response) {
        Get.offAllNamed(AppRoutes.login);
        if (Utils.getLoginTypeValue(LoginType.GOOGLE) == 2) {
          Utils.showLog("Google Logout Success");
          await GoogleSignIn().signOut();
        }
        Preference.clear();
        Preference.clearWatchedVideos();
        Utils.showLog("deleteeeeeeeeeeeeeeee");
        Utils.showToast(
          Get.context!,
          EnumLocal.userHasBeeSuccessfullyDeleted.name.tr,
        );
      } else {
        Get.close(2);
      }
    } else {
      Utils.showToast(
        Get.context!,
        EnumLocal.pleaseAgreeToTheAboveContentFirst.name.tr,
      );
    }
  }
}
