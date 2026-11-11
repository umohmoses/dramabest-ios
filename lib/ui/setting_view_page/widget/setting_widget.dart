import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/ui/setting_view_page/controller/setting_controller.dart';
import 'package:story_box/utils/color.dart';

class SettingItemViewWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SettingItemViewWidget({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          color: AppColor.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
          child: Row(
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.withValues(alpha: 0.7),
                size: 26,
              )
            ],
          ),
        ),
      );
    });
  }
}
