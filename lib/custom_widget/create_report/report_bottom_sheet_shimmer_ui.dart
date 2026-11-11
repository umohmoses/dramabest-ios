import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/widgets.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/color.dart';

class ReportBottomSheetShimmerUi extends StatelessWidget {
  const ReportBottomSheetShimmerUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmer,
      highlightColor: AppColor.colorWhite,
      child: ListView.builder(
        itemCount: 15,
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(color: AppColor.colorBlack, shape: BoxShape.circle),
              ),
              10.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      decoration: BoxDecoration(color: AppColor.colorBlack, borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
