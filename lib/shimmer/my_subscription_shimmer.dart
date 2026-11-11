import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

class MySubscriptionShimmer extends StatelessWidget {
  const MySubscriptionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBaseColor,
      highlightColor: Colors.grey.shade700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            EnumLocal.txtMySubscription.name.tr,
            style: AppFontStyle.styleW500(AppColor.greyColor, 20),
          ).paddingOnly(top: 16),
          Stack(
            children: [
              Container(
                height: 200,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: .3),
                  borderRadius: BorderRadius.circular(6),
                ),
              ).paddingOnly(right: 16, top: 16),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 22,
                    right: 32,
                    left: 16,
                    bottom: 22,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAsset.vipCrown,
                        scale: 4,
                      ),
                      Container(
                        height: 15,
                        width: 110,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: .3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      4.height,
                      Container(
                        height: 15,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: .3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      20.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 15,
                            width: 130,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: .3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          Container(
                            height: 15,
                            width: 115,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: .3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                      8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 15,
                            width: 110,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: .3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          Container(
                            height: 15,
                            width: 130,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: .3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
