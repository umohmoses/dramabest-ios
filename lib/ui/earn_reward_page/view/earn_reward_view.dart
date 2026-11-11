import 'dart:async';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/shimmer/earn_reward_shimmer_ui.dart';
import 'package:story_box/ui/earn_reward_page/controller/earn_reward_controller.dart';
import 'package:story_box/ui/earn_reward_page/model/get_daily_reward_model.dart';
import 'package:story_box/ui/refill/view/store_view.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';
import 'package:story_box/ui/referral_page/referral_view.dart';

class EranRewardView extends StatelessWidget {
  const EranRewardView({super.key});

  @override
  Widget build(BuildContext context) {
    EarnRewardController earnRewardController = Get.find<EarnRewardController>();
    List<String> appBarRoutes = [AppRoutes.rewards];

    bool showAppBar = appBarRoutes.contains(Get.currentRoute);
    earnRewardController.init();
    Utils.showLog("Show App Bar :: $showAppBar");
    Timer(
      const Duration(milliseconds: 300),
      () {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: AppColor.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        );
      },
    );

    return GetBuilder<EarnRewardController>(
      id: "onGetDailyRewards",
      builder: (controller) => controller.isLoadingDailyRewards
          ? const Scaffold(
              backgroundColor: AppColor.colorBlack,
              body: EarnRewardShimmerUi(),
              // body: Container(),
            )
          : Scaffold(
              backgroundColor: AppColor.colorBlack,
              body: RefreshIndicator(
                color: AppColor.primaryColor,
                onRefresh: () {
                  return controller.init();
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        child: SizedBox(
                          height: 250,
                          width: Get.width,
                          child: Image.asset(
                            AppAsset.giftImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).viewPadding.top,
                        child: SizedBox(
                          width: Get.width,
                          child: Row(
                            children: [
                              showAppBar
                                  ? GestureDetector(
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        color: Colors.transparent,
                                        child: const Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                        ).paddingOnly(left: 16, bottom: 20),
                                      ),
                                      onTap: () => Get.back(),
                                    )
                                  : const SizedBox(width: 50),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    EnumLocal.earnRewards.name.tr,
                                    style: AppFontStyle.styleW600(AppColor.colorWhite, 19),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 50)
                            ],
                          ),
                        ).paddingOnly(top: 8),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: SizedBox(
                          width: Get.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          EnumLocal.myRewardCoin.name.tr,
                                          style: AppFontStyle.styleW500(AppColor.colorWhite, 16),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     const SizedBox(width: 10),
                                        //     Obx(
                                        //       () => Text(
                                        //         '${Preference.userCoin}',
                                        //         // "${controller.myRewardCoin.value}",
                                        //         style: AppFontStyle.styleW800(AppColor.colorWhite, 28),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      4.width,
                                      Obx(
                                        () => Row(
                                          children: [
                                            Image.asset(
                                              AppAsset.starCoin,
                                              height: 26,
                                            ).paddingOnly(right: 5),
                                            Text(
                                              '${Preference.userCoin}',
                                              // "${controller.myRewardCoin.value}",
                                              style: AppFontStyle.styleW800(AppColor.colorWhite, 28),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Spacer(),
                                      const Flexible(flex: 8, child: VipAccessCard()),
                                    ],
                                  ),
                                  10.height,
                                  BlurryContainer(
                                    height: ((controller.getDailyRewardModel?.streak ?? 0) >= 3) ? 225 : 185,
                                    width: Get.width,
                                    blur: 20,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColor.colorWhite.withValues(alpha: 0.1),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if ((controller.getDailyRewardModel?.streak ?? 0) >= 3) ...[
                                          SizedBox(
                                            height: 40,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                                              child: RichText(
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: EnumLocal.youHaveCheckedInFor.name.tr,
                                                      style: AppFontStyle.styleW600(
                                                        AppColor.colorWhite.withValues(alpha: 0.7),
                                                        15,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: " ${controller.getDailyRewardModel?.streak ?? 0} ",
                                                      style: AppFontStyle.styleW800(
                                                        AppColor.colorWhite,
                                                        16,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: EnumLocal.dayStraight.name.tr,
                                                      style: AppFontStyle.styleW600(
                                                        AppColor.colorWhite.withValues(alpha: 0.7),
                                                        14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          10.height,
                                        ],
                                        GetBuilder<EarnRewardController>(
                                          id: "onGetDailyRewards",
                                          builder: (controller) => SizedBox(
                                            height: 75,
                                            child: ListView.builder(
                                              itemCount: controller.dailyRewards.length,
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                DailyRewardData value = controller.dailyRewards[index];

                                                final isToday = (DateTime.now().day == CustomGetCurrentWeekDate.onGet()[index].day);

                                                final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                                                final customDate = CustomGetCurrentWeekDate.onGet()[index];
                                                final isPreviousDay = customDate.isBefore(today);

                                                return Container(
                                                  height: 65,
                                                  width: 48,
                                                  margin: const EdgeInsets.only(right: 6),
                                                  decoration: BoxDecoration(
                                                    color: (isPreviousDay && value.isCheckIn == false)
                                                        ? AppColor.lightRed
                                                        : (value.isCheckIn == true)
                                                            ? AppColor.lightGreen
                                                            : (isToday && value.isCheckIn == false)
                                                                ? AppColor.primaryColor
                                                                : AppColor.colorWhite.withValues(alpha: 0.2),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 20,
                                                        width: 52,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: (isPreviousDay && value.isCheckIn == false)
                                                              ? AppColor.lightRed1
                                                              : (value.isCheckIn == true)
                                                                  ? AppColor.lightGreen1
                                                                  : (isToday && value.isCheckIn == false)
                                                                      ? AppColor.colorBlack.withValues(alpha: 0.2)
                                                                      : AppColor.colorWhite.withValues(alpha: 0.15),
                                                          borderRadius: const BorderRadius.only(
                                                            topLeft: Radius.circular(10),
                                                            topRight: Radius.circular(10),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          (isPreviousDay && value.isCheckIn == false) ? "Lost" : "+${value.reward ?? 0}",
                                                          style: AppFontStyle.styleW800(
                                                            (isPreviousDay && value.isCheckIn == false)
                                                                ? AppColor.colorWhite
                                                                : (value.isCheckIn == true)
                                                                    ? AppColor.greyColor
                                                                    : (isToday && value.isCheckIn == false)
                                                                        ? AppColor.colorWhite
                                                                        : AppColor.colorWhite,
                                                            11,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Center(
                                                          child: Image.asset(
                                                            (isPreviousDay && value.isCheckIn == false)
                                                                ? AppAsset.closeIcon
                                                                : (isToday || value.isCheckIn == true)
                                                                    ? AppAsset.coinIcon
                                                                    : AppAsset.coinIconGrey,
                                                            height: isToday ? 30 : 24,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                        child: Text(
                                                          isToday ? EnumLocal.today.name.tr : CustomGetCurrentWeekDate.onShow(CustomGetCurrentWeekDate.onGet()[index]),
                                                          style: AppFontStyle.styleW800(
                                                            (isToday && value.isCheckIn == false)
                                                                ? AppColor.colorWhite
                                                                : (isPreviousDay && value.isCheckIn == false)
                                                                    ? AppColor.darkRed
                                                                    : (value.isCheckIn == true)
                                                                        ? AppColor.greyColor
                                                                        : (isToday && value.isCheckIn == false)
                                                                            ? AppColor.colorWhite
                                                                            : AppColor.colorWhite,
                                                            10,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        15.height,
                                        GestureDetector(
                                          onTap: () => controller.onCheckIn(context),
                                          child: Container(
                                            height: 50,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                              gradient: controller.isTodayCheckIn
                                                  ? const LinearGradient(colors: [AppColor.grey, AppColor.grey])
                                                  : const LinearGradient(colors: [AppColor.colorPrimary, AppColor.colorSecondary]),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              EnumLocal.checkIn.name.tr,
                                              style: AppFontStyle.styleW800(AppColor.colorWhite, 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  20.height,
                                  const InviteFriendsTile(),
                                  // Eran more  Reward
                                  // Container(
                                  //   height: 242,
                                  //   width: Get.width,
                                  //   decoration: BoxDecoration(
                                  //     color: AppColor.colorWhite,
                                  //     borderRadius: BorderRadius.circular(30),
                                  //     border: Border.all(
                                  //       width: 1.5,
                                  //       color: AppColor.primaryColor.withValues(alpha:0.4),
                                  //     ),
                                  //   ),
                                  //   child: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                  //     children: [
                                  //       Container(
                                  //         alignment: Alignment.centerLeft,
                                  //         height: 60,
                                  //         padding: const EdgeInsets.symmetric(horizontal: 20),
                                  //         decoration: BoxDecoration(
                                  //           color: AppColor.primaryColor.withValues(alpha:0.2),
                                  //           borderRadius: const BorderRadius.only(
                                  //             topLeft: Radius.circular(28),
                                  //             topRight: Radius.circular(28),
                                  //           ),
                                  //         ),
                                  //         child: Text(
                                  //           EnumLocal.earnMore.name.tr,
                                  //           style: AppFontStyle.styleW800(AppColor.primaryColor, 16),
                                  //         ),
                                  //       ),
                                  //       Container(
                                  //         height: 80,
                                  //         color: AppColor.transparent,
                                  //         padding: const EdgeInsets.only(left: 5, right: 15),
                                  //         child: Row(
                                  //           crossAxisAlignment: CrossAxisAlignment.center,
                                  //           children: [
                                  //             Container(
                                  //               alignment: Alignment.center,
                                  //               height: 55,
                                  //               padding: const EdgeInsets.symmetric(horizontal: 20),
                                  //               decoration: BoxDecoration(
                                  //                 color: AppColor.primaryColor.withValues(alpha:0.2),
                                  //                 shape: BoxShape.circle,
                                  //               ),
                                  //               child: Image.asset(AppAsset.referralIcon, width: 30),
                                  //             ),
                                  //             const SizedBox(width: 8),
                                  //             Column(
                                  //               crossAxisAlignment: CrossAxisAlignment.start,
                                  //               mainAxisAlignment: MainAxisAlignment.center,
                                  //               children: [
                                  //                 Text(
                                  //                   EnumLocal.referralReward.name.tr,
                                  //                   style: AppFontStyle.styleW800(AppColor.primaryColor, 16),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //             const Spacer(),
                                  //             GestureDetector(
                                  //               onTap: () {
                                  //                 // Get.to(const ReferralProgramView());
                                  //               },
                                  //               child: Container(
                                  //                 height: 32,
                                  //                 width: 70,
                                  //                 alignment: Alignment.center,
                                  //                 decoration: BoxDecoration(
                                  //                   color: AppColor.primaryColor,
                                  //                   borderRadius: BorderRadius.circular(30),
                                  //                 ),
                                  //                 child: Text(
                                  //                   EnumLocal.go.name.tr,
                                  //                   style: AppFontStyle.styleW700(AppColor.colorWhite, 15),
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       Divider(
                                  //         indent: 15,
                                  //         endIndent: 15,
                                  //         color: AppColor.primaryColor.withValues(alpha:0.2),
                                  //       ),
                                  //       GestureDetector(
                                  //         onTap: () {
                                  //           // Get.to(const ContentEngagementView());
                                  //         },
                                  //         child: Container(
                                  //           height: 80,
                                  //           color: AppColor.transparent,
                                  //           padding: const EdgeInsets.only(left: 5, right: 15),
                                  //           child: Row(
                                  //             crossAxisAlignment: CrossAxisAlignment.center,
                                  //             children: [
                                  //               Container(
                                  //                 alignment: Alignment.center,
                                  //                 height: 55,
                                  //                 padding: const EdgeInsets.symmetric(horizontal: 20),
                                  //                 decoration: BoxDecoration(
                                  //                   color: AppColor.primaryColor.withValues(alpha:0.2),
                                  //                   shape: BoxShape.circle,
                                  //                 ),
                                  //                 child: Image.asset(AppAsset.engagementIcon, width: 30),
                                  //               ),
                                  //               const SizedBox(width: 8),
                                  //               Column(
                                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                                  //                 mainAxisAlignment: MainAxisAlignment.center,
                                  //                 children: [
                                  //                   Text(
                                  //                     EnumLocal.engagementRewards.name.tr,
                                  //                     style: AppFontStyle.styleW800(AppColor.primaryColor, 18),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               const Spacer(),
                                  //               Container(
                                  //                 height: 32,
                                  //                 width: 70,
                                  //                 alignment: Alignment.center,
                                  //                 decoration: BoxDecoration(
                                  //                   color: AppColor.primaryColor,
                                  //                   borderRadius: BorderRadius.circular(30),
                                  //                 ),
                                  //                 child: Text(
                                  //                   EnumLocal.go.name.tr,
                                  //                   style: AppFontStyle.styleW700(AppColor.colorWhite, 15),
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  GetBuilder<EarnRewardController>(
                                    id: "onGetAdRewards",
                                    builder: (controller) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          EnumLocal.watchAds.name.tr,
                                          style: AppFontStyle.styleW800(AppColor.colorWhite, 22),
                                        ),
                                        4.height,
                                        GetBuilder<EarnRewardController>(
                                          id: "onChangeAdReward",
                                          builder: (context) {
                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount: controller.adRewards.length,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) => Container(
                                                height: 60,
                                                color: AppColor.transparent,
                                                padding: const EdgeInsets.only(left: 5, right: 15),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      AppAsset.adIcon,
                                                      width: 30,
                                                      color: AppColor.colorWhite,
                                                    ),
                                                    12.width,
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          AppAsset.starCoin,
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                        8.width,
                                                        Text(
                                                          "+${controller.adRewards[index].coinEarnedFromAd ?? 0}",
                                                          style: AppFontStyle.styleW800(AppColor.colorWhite, 16),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    GetBuilder<EarnRewardController>(
                                                      id: "onChangeAdReward",
                                                      builder: (context) {
                                                        return Bounceable(
                                                          onTap: () {
                                                            Utils.showLog("call function");
                                                            controller.onClickPlay(index);
                                                          },
                                                          child: Container(
                                                            height: 32,
                                                            width: 80,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: index < controller.completeAdTask
                                                                  ? AppColor.colorWhite.withValues(alpha: 0.2)
                                                                  : index != controller.completeAdTask
                                                                      ? AppColor.grey.withValues(alpha: 0.2)
                                                                      : controller.isEnableCurrentAdTask
                                                                          ? AppColor.primaryColor
                                                                          : AppColor.primaryColor.withValues(alpha: 0.15),
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: Text(
                                                              index < controller.completeAdTask
                                                                  ? EnumLocal.earned.name.tr
                                                                  : index != controller.completeAdTask
                                                                      ? EnumLocal.watchAd.name.tr
                                                                      : controller.isEnableCurrentAdTask
                                                                          ? EnumLocal.watchAd.name.tr
                                                                          : controller.convertAdTime(controller.nextAdTaskTime),
                                                              style: AppFontStyle.styleW700(
                                                                (index == controller.completeAdTask && !controller.isEnableCurrentAdTask)
                                                                    ? AppColor.primaryColor
                                                                    : index < controller.completeAdTask
                                                                        ? AppColor.grey
                                                                        : AppColor.colorWhite,
                                                                13,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class CustomGetCurrentWeekDate {
  static List<DateTime> onGet() {
    List<DateTime> weekDates = [];

    DateTime now = DateTime.now();

    int currentWeekday = now.weekday;

    DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));

    for (int i = 0; i < 7; i++) {
      DateTime weekDay = startOfWeek.add(Duration(days: i));
      weekDates.add(weekDay);
    }

    return weekDates;
  }

  static String onShow(DateTime date) {
    DateFormat formatter = DateFormat('dd/MM');
    String formattedDay = formatter.format(date);
    Utils.showLog("Format Date => $formattedDay");
    return formattedDay;
  }
}

/// Rewards page: VIP offer next to the coin balance. Coins unlock episodes but
/// ads still show; VIP is the only way to watch without ads.
class VipAccessCard extends StatelessWidget {
  const VipAccessCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isVip = Preference.isVip;
    return Bounceable(
      onTap: () => Get.to(() => StoreView()),
      child: Container(
        padding: const EdgeInsets.all(1.4),
        decoration: BoxDecoration(gradient: AppColor.goldBorderGradient, borderRadius: BorderRadius.circular(14)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(color: AppColor.brownColor.withValues(alpha: 0.92), borderRadius: BorderRadius.circular(13)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.workspace_premium_rounded, color: AppColor.colorLightOrange, size: 26),
              const SizedBox(width: 7),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isVip ? 'VIP Active' : 'VIP Access',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.styleW800(AppColor.colorLightYellow, 15),
                    ),
                    Text(
                      'Unlimited videos · No ads',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.styleW500(AppColor.colorWhite.withValues(alpha: 0.85), 11.5),
                    ),
                  ],
                ),
              ),
              if (!isVip) ...[
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: AppColor.colorLightYellow, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
