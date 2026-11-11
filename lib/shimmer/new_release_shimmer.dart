import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/color.dart';

class NewReleaseShimmer extends StatelessWidget {
  const NewReleaseShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBaseColor,
      highlightColor: Colors.grey.shade700,
      child: SizedBox(
        height: 90,
        child: ListView.builder(
          itemCount: 4,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
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
        ),
      ),
    );
  }
}
