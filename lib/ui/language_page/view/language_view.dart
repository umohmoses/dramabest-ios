import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/ui/language_page/controller/language_controller.dart';
import 'package:story_box/ui/language_page/widget/language_widget.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.luxuryDarkBase,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColor.luxuryDarkSurface,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios, color: AppColor.colorWhite),
          onTap: () => Get.back(),
        ),
        title: Text(
          EnumLocal.language.name.tr,
          style: AppFontStyle.styleW600(AppColor.colorWhite, 20),
        ),
      ),
      body: Obx(() {
        final controller = Get.find<LanguageController>();

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColor.colorLightOrange));
        }

        if (controller.languages.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.onRefresh,
            color: AppColor.colorLightOrange,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                const Center(child: Text("No languages found", style: TextStyle(color: Colors.white70))),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          color: AppColor.colorLightOrange,
          child: ListView.builder(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: controller.languages.length + (controller.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.languages.length) {
                return Obx(() => controller.isMoreLoading.value
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator(color: AppColor.colorLightOrange)),
                      )
                    : const SizedBox());
              }

              final language = controller.languages[index];
              return ItemsView(
                icon: language.languageIcon.isNotEmpty
                    ? language.languageIcon
                    : (controller.countryFlags.length > index ? controller.countryFlags[index] : AppAsset.icUnitedStates),
                title: language.languageTitle,
                isSelected: language.languageCode == controller.languageInfo?.languageCode,
                callback: () => controller.onChangeLanguage(language),
              );
            },
          ),
        );
      }),
    );
  }
}
