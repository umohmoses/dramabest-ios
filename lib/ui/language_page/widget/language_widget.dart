import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/font_style.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.callback,
  });

  final String icon;
  final String title;
  final bool isSelected;
  final Callback callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(1.2),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColor.goldBorderGradient : AppColor.unselectedBorderGradient,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Container(
          height: 65,
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.luxuryCardSelected : AppColor.luxuryDarkSurface,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            children: [
              icon.contains('/uploads/') || icon.startsWith('http')
                  ? ClipOval(
                      child: Image.network(
                        icon.startsWith('http') ? icon : ApiConstant.getBaseURL() + icon.replaceFirst(RegExp(r'^/'), ''),
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 36,
                          height: 36,
                          color: AppColor.colorBorderGrey,
                          child: const Icon(Icons.language, size: 20),
                        ),
                      ),
                    )
                  : Image.asset(
                      icon,
                      width: 36,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.language, color: AppColor.colorLightYellow),
                    ),
              15.width,
              Expanded(
                child: Text(
                  title,
                  style: AppFontStyle.styleW700(
                    isSelected ? AppColor.colorLightYellow : AppColor.colorWhite.withValues(alpha: 0.9),
                    15,
                  ),
                ),
              ),
              RadioItem(isSelected: isSelected),
            ],
          ),
        ),
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  const RadioItem({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: AppColor.transparent,
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColor.colorLightOrange : AppColor.colorWhite.withValues(alpha: 0.25),
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColor.colorLightOrange.withValues(alpha: 0.25),
                        blurRadius: 6,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.5),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSelected ? AppColor.vipGradient : null,
                  color: isSelected ? null : Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
