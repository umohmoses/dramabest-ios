import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_box/main.dart';

import '../utils/color.dart';

class SearchItemShimmer extends StatelessWidget {
  const SearchItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBaseColor,
      highlightColor: Colors.grey.shade700,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 140,
                    width: 110,
                    child: Stack(
                      children: [
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColor.shimmer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColor.colorBlack.withValues(alpha: 0.6),
                                  AppColor.colorBlack.withValues(alpha: 0.3),
                                  AppColor.colorBlack.withValues(alpha: 0),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(4.0),
                                bottomRight: Radius.circular(4.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: Get.width / 2.5,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColor.shimmer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      6.height,
                      Container(
                        width: Get.width / 3.3,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColor.shimmer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: Get.width / 1.8,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColor.shimmer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 10),
                ),
              ],
            ),
          );
        },
      ).paddingOnly(top: 16),
    );
  }
}
