import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/payment/subscription/subscription_manager.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/profile_page/controller/profile_controller.dart';
import 'package:story_box/ui/profile_page/widget/profile_widget.dart';
import 'package:story_box/ui/refill/view/store_view.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class ProfileViewPage extends StatelessWidget {
  const ProfileViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      body: SingleChildScrollView(
        child: GetBuilder<ProfileController>(
          id: "userProfile",
          builder: (profileController) {
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColor.colorPrimary.withValues(alpha: 0.15),
                            AppColor.colorPrimary.withValues(alpha: 0.1),
                            AppColor.colorBlack.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8, top: 34),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 55,
                            width: 55,
                            child: Preference.shared.getString(Preference.profilePic) != null && Preference.shared.getString(Preference.profilePic)!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl: Preference.shared.getString(Preference.profilePic) ?? '',
                                      placeholder: (context, url) => Center(
                                        child: Image.asset(
                                          AppAsset.placeHolderImage,
                                          color: AppColor.colorIconGrey,
                                        ).paddingAll(16),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                    ),
                                  )
                                : Image.asset(AppAsset.icProfileMen),
                          ),
                          10.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width * 0.6,
                                child: Text(
                                  Preference.shared.getString(Preference.name) ?? '',
                                  style: AppFontStyle.styleW700(AppColor.colorWhite, 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  if (Preference.shared.getInt(Preference.loginType) == 2) ...{
                                    Image.asset(
                                      AppAsset.icGoogle,
                                      scale: 7,
                                    ),
                                  } else if (Preference.shared.getInt(Preference.loginType) == 4) ...{
                                    Image.asset(
                                      AppAsset.icApple,
                                      scale: 7,
                                    ),
                                  } else if (Preference.shared.getInt(Preference.loginType) == 3) ...{
                                    const SizedBox.shrink()
                                  },
                                  if (Preference.shared.getInt(Preference.loginType) != 3) 4.width,
                                  Text(
                                    "UID: ${Preference.shared.getString(Preference.uniqueId)}",
                                    style: AppFontStyle.styleW700(AppColor.grey, 14),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),

                10.height,

                VipBannerShimmer(
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // 10 px radius
                      color: AppColor.colorLightOrange,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppAsset.vipCrown,
                                        height: 26,
                                        width: 26,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Text(
                                          Preference.isVip == false
                                              ? '${EnumLocal.txtAppName.name.tr} ${EnumLocal.txtVIP.name.tr}'
                                              : (profileController.loginUserModel?.user?.currentPlan?.validityType == 'month'
                                                  ? EnumLocal.monthlyVIP.name.tr
                                                  : profileController.loginUserModel?.user?.currentPlan?.validityType == 'year'
                                                      ? EnumLocal.yearlyVIP.name.tr
                                                      : EnumLocal.weeklyVIP.name.tr),
                                          style: AppFontStyle.styleW800(AppColor.brownColor, 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Utils.showLog("Coming Soon Calling to store");
                                      PremiumManager.instance.startSubscriptionTracking();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        EnumLocal.txtEnjoyExclusiveBenefits.name.tr,
                                        style: AppFontStyle.styleW400(AppColor.brownColor, 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => StoreView())?.then(
                                  (value) => profileController.profileDataGet(),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColor.colorBlack.withAlpha(200), blurRadius: 15, offset: Offset(0.5, 0.5), blurStyle: BlurStyle.inner, spreadRadius: 1)
                                  ],
                                  borderRadius: BorderRadius.circular(22),
                                  color: AppColor.brownColor.withAlpha(220),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                                  child: Text(
                                    Preference.isVip == false ? EnumLocal.txtActivate.name.tr : EnumLocal.txtActivated.name.tr,
                                    style: AppFontStyle.styleW500(AppColor.colorLightOrange, 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        5.height,
                        Container(
                          height: 42,
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            gradient:
                                LinearGradient(colors: [AppColor.colorLightOrange, AppColor.colorLightOrange.withAlpha(100), AppColor.colorLightYellow.withAlpha(150)]),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Get.width * 0.4,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      AppAsset.icWatchAll,
                                      color: AppColor.brownColor.withAlpha(220),
                                      height: 16,
                                      width: 16,
                                    ),
                                    5.width,
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Text(
                                          EnumLocal.txtWatchAllForFree.name.tr,
                                          style: AppFontStyle.styleW800(AppColor.brownColor, 16),
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      AppAsset.icNoAds,
                                      color: AppColor.brownColor.withAlpha(220),
                                      height: 16,
                                      width: 16,
                                    ),
                                    5.width,
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        EnumLocal.txtAdFree.name.tr,
                                        style: AppFontStyle.styleW800(AppColor.brownColor, 16),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                8.height,
                ProfileItemViewWidget(
                  imagePath: AppAsset.icEarnRewards,
                  text: EnumLocal.earnRewards.name.tr,
                  imageHeight: 22,
                  onTap: () {
                    Get.toNamed(AppRoutes.rewards);
                  },
                ),

                ProfileItemViewWidget(
                  imagePath: AppAsset.icWallet,
                  text: EnumLocal.myWallet.name.tr,
                  imageHeight: 22,
                  onTap: () {
                    Get.toNamed(AppRoutes.wallet);
                  },
                ),
                ProfileItemViewWidget(
                  imagePath: AppAsset.icMyListProfile,
                  text: EnumLocal.myList.name.tr,
                  imageHeight: 22,
                  onTap: () {
                    // Define the action on tap
                    Get.toNamed(
                      AppRoutes.myList,
                      arguments: {
                        "isShowArrow": true,
                      },
                    );
                  },
                ),
                // ProfileItemViewWidget(
                //   imagePath: AppAsset.icInvitationCode,
                //   text: EnumLocal.invitationCode.name.tr,
                //   imageHeight: 22,
                //   onTap: () {
                //     // Define the action on tap
                //     log('Earn Rewards tapped');
                //   },
                // ),
                // ProfileItemViewWidget(
                //   imagePath: AppAsset.icCoupons,
                //   text: EnumLocal.myCoupons.name.tr,
                //   imageHeight: 22,
                //   onTap: () {
                //     // Define the action on tap
                //     log('Earn Rewards tapped');
                //   },
                // ),
                // ProfileItemViewWidget(
                //   imagePath: AppAsset.icFeedback,
                //   text: EnumLocal.feedback.name.tr,
                //   imageHeight: 22,
                //   onTap: () {
                //     // Define the action on tap
                //     log('Earn Rewards tapped');
                //   },
                // ),
                ProfileItemViewWidget(
                  imagePath: AppAsset.icLanguage,
                  text: EnumLocal.language.name.tr,
                  imageHeight: 22,
                  onTap: () {
                    // Define the action on tap
                    Get.toNamed(AppRoutes.language);
                  },
                ),
                ProfileItemViewWidget(
                  imagePath: AppAsset.icSetting,
                  text: EnumLocal.setting.name.tr,
                  imageHeight: 22,
                  onTap: () {
                    // Define the action on tap

                    Get.toNamed(AppRoutes.setting);
                    log('Earn Rewards tapped');
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class VipBannerShimmer extends StatefulWidget {
  const VipBannerShimmer({super.key, required this.child});
  final Widget child;
  @override
  _VipBannerShimmerState createState() => _VipBannerShimmerState();
}

class _VipBannerShimmerState extends State<VipBannerShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slide;
  ProfileController profileController = Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // 2 s move + 2 s pause
    );

    _slide = Tween(begin: 0.0, end: 2.0).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _slide,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: const Alignment(-1.0, -1.0),
                end: const Alignment(1.0, 1.0),
                colors: const [
                  Colors.transparent,
                  Colors.white30,
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
                transform: SlideGradientTransform(percent: _slide.value),
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: ClipRRect(borderRadius: BorderRadius.circular(10), child: child),
          );
        },
        child: widget.child);
  }
}

class SlideGradientTransform extends GradientTransform {
  final double percent;
  const SlideGradientTransform({required this.percent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    // map 0→-1  and  2→1  (completely off-screen at ends)
    final t = (percent - 1.0).clamp(-1.0, 1.0);
    return Matrix4.translationValues(bounds.width * t, 0, 0);
  }
}
