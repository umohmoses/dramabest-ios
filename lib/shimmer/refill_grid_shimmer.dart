import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/color.dart';

class RefillGridShimmer extends StatelessWidget {
  const RefillGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBaseColor,
      highlightColor: Colors.grey.shade700,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.7,
        ),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColor.colorIconGrey.withValues(alpha: .3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                18.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 15,
                      decoration: BoxDecoration(
                        color: AppColor.shimmer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    4.width,
                    Container(
                      width: 50,
                      height: 15,
                      decoration: BoxDecoration(
                        color: AppColor.shimmer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
                4.height,
                Container(
                  width: 50,
                  height: 15,
                  decoration: BoxDecoration(
                    color: AppColor.shimmer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: Get.width,
                  decoration: const BoxDecoration(
                    color: AppColor.shimmer,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ).paddingOnly(right: 16),
    );
  }
}
