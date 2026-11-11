import 'package:flutter/material.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/font_style.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppAsset.noData,
            fit: BoxFit.cover,
            height: 80,
            color: AppColor.colorIconGrey,
          ),
          20.height,
          Text(
            text,
            style: AppFontStyle.styleW500(AppColor.colorIconGrey, 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
