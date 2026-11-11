import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/color.dart';

class MyListShimmer extends StatelessWidget {
  const MyListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBaseColor,
      highlightColor: Colors.grey.shade700,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: 5,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.59,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: .3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                6.height,
                Flexible(
                  child: Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColor.shimmer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                6.height,
                Container(
                  width: 50,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColor.shimmer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          );
        },
      ).paddingSymmetric(horizontal: 12, vertical: 10),
    );
  }
}
