// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:story_box/utils/constant.dart';

class AppButton extends StatelessWidget {
  double? height;
  double? width;
  Color? backgroundColor;
  IconData? icon;
  Color? iconColor;
  double? iconSize;
  String text;
  Color? textColor;
  double textSize;
  double borderRadius;
  EdgeInsets? padding;
  VoidCallback? onPressed;

  AppButton({
    super.key,
    this.height,
    this.width,
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.iconSize = 26.0,
    this.text = "",
    this.textColor,
    this.textSize = 14.0,
    this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    this.borderRadius = 5.0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: iconSize),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: textSize,
                fontFamily: Constant.appFontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
