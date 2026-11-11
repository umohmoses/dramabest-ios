import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

class CustomDialog extends StatelessWidget {
  final String text;
  final String buttonText;
  final Function()? onTap;

  const CustomDialog({super.key, required this.text, required this.buttonText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff454446),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: Text(
                    text,
                    style: AppFontStyle.styleW700(AppColor.colorWhite, 22),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey.withValues(alpha: 0.7),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              EnumLocal.cancel.name.tr,
                              style: AppFontStyle.styleW500(AppColor.colorWhite, 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: Colors.grey.withValues(alpha: 0.7),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: onTap,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              buttonText,
                              style: AppFontStyle.styleW500(AppColor.colorTextRed, 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          22.height,
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SizedBox(
              height: 32,
              width: 32,
              child: Image.asset(
                AppAsset.icClose,
                color: AppColor.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
