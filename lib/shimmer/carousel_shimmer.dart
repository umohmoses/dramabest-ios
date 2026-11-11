import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_box/utils/color.dart';

class CarouselShimmer extends StatelessWidget {
  const CarouselShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.40,
      child: Shimmer.fromColors(
        baseColor: AppColor.shimmerBaseColor,
        highlightColor: Colors.grey.shade700,
        child: CarouselSlider.builder(
          itemCount: 5, // ya 3 bhi chalega
          options: CarouselOptions(
            height: Get.height * 0.40,
            viewportFraction: 0.7,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            autoPlay: false, // shimmer me animation nahi chahiye
            enableInfiniteScroll: true,
            // enlargeCenterPage: ,
          ),
          itemBuilder: (context, index, realIndex) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColor.shimmer,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
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
