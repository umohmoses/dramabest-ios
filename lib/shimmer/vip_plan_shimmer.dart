import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/color.dart';

class VipPlanShimmer extends StatelessWidget {
  const VipPlanShimmer({
    super.key,
    this.isShow = false,
  });

  final bool isShow;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBaseColor,
      highlightColor: Colors.grey.shade700,
      child: SizedBox(
        height: 90,
        child: ListView.builder(
          itemCount: 2,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SizedBox(
                height: 80,
                width: Get.width - 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: isShow ? Colors.grey.withValues(alpha: .4) : AppColor.bgGreyColor.withValues(alpha: .75),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isShow ? AppColor.shimmer : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        6.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColor.shimmer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            6.height,
                            Container(
                              width: Get.width / 2.5,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColor.shimmer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xff1d1311),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: Container(
                                width: 50,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: AppColor.shimmer,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ).paddingOnly(right: 16),
                        )
                      ],
                    ).paddingOnly(left: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
