// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:story_box/main.dart';
import 'package:story_box/ui/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:story_box/ui/reels_page/controller/reels_controller.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

class BottomBarUi extends StatelessWidget {
  BottomBarUi({super.key});

  ReelsController reelsController = Get.put(ReelsController());
  @override
  Widget build(BuildContext context) {
    // reelsController.init();
    return GetBuilder<BottomBarController>(
      id: Constant.idBottomBar,
      builder: (logic) {
        return BottomAppBar(
          padding: EdgeInsets.zero,
          height: Constant.bottomBarSize,
          color: AppColor.colorBlack,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    logic.onChangeBottomBar(0);
                  },
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          logic.selectedTabIndex == 0 ? AppAsset.icHomeSelected : AppAsset.icHome,
                          width: 24,
                        ),
                        3.height,
                        Text(
                          EnumLocal.home.name.tr,
                          style: AppFontStyle.styleW400(AppColor.colorWhite, 11),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    logic.onChangeBottomBar(1);
                    reelsController.init();
                  },
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          logic.selectedTabIndex == 1 ? AppAsset.icReelsSelected : AppAsset.icReels,
                          width: 24,
                        ),
                        3.height,
                        Text(
                          EnumLocal.forYou.name.tr,
                          style: AppFontStyle.styleW400(AppColor.colorWhite, 11),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    logic.onChangeBottomBar(3);
                  },
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Platform.isIOS ? 10.height : 3.height,
                        Lottie.asset(
                          AppAsset.lottieGiftHome,
                          fit: BoxFit.cover,
                          height: 36,
                          width: 36,
                        ),
                        Text(
                          EnumLocal.rewards.name.tr,
                          style: AppFontStyle.styleW400(AppColor.colorWhite, 11),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    logic.onChangeBottomBar(2);
                  },
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          logic.selectedTabIndex == 2 ? AppAsset.icMyListSelected : AppAsset.icMyList,
                          width: 24,
                        ),
                        5.height,
                        Text(
                          EnumLocal.myList.name.tr,
                          style: AppFontStyle.styleW400(AppColor.colorWhite, 11),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    logic.onChangeBottomBar(4);
                  },
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        logic.selectedTabIndex == 4
                            ? Image.asset(
                                AppAsset.icProfileSelected,
                                height: 26,
                              )
                            : Image.asset(
                                AppAsset.icProfile,
                                height: 26,
                                color: Colors.white,
                              ),
                        5.height,
                        Text(
                          EnumLocal.profile.name.tr,
                          style: AppFontStyle.styleW400(AppColor.colorWhite, 11),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
