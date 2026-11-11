import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/color.dart';

class EarnRewardShimmerUi extends StatelessWidget {
  const EarnRewardShimmerUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBaseColor,
      highlightColor: Colors.grey.shade700,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: 250,
              width: Get.width,
              color: AppColor.colorIconGrey.withValues(alpha: .3),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 10,
            child: SizedBox(
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   height: 30,
                  //   width: 30,
                  //   decoration: const BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: AppColor.shimmer,
                  //   ),
                  // ).paddingOnly(left: 16),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 110,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColor.shimmer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColor.shimmer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 50,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColor.shimmer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                      40.height,
                      Container(
                        height: 210,
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.colorIconGrey.withValues(alpha: .5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            16.height,
                            Container(
                              width: Get.width / 1.5,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColor.shimmer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            16.height,
                            SizedBox(
                              height: 75,
                              child: ListView.builder(
                                itemCount: 8,
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 65,
                                    width: 48,
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      color: AppColor.shimmer,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 52,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: AppColor.colorIconGrey,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: Get.width,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColor.shimmer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                      26.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 90,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColor.shimmer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          4.height,
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: 6,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Container(
                              height: 60,
                              color: AppColor.transparent,
                              padding: const EdgeInsets.only(left: 5, right: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColor.shimmer,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  10.width,
                                  Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: const BoxDecoration(
                                          color: AppColor.shimmer,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      5.width,
                                      Container(
                                        width: 20,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: AppColor.shimmer,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 32,
                                    width: 80,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColor.shimmer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
