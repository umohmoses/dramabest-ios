import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:story_box/utils/color.dart';

class CustomProgressDialog extends StatelessWidget {
  const CustomProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.halfTriangleDot(
        color: AppColor.colorPrimary,
        size: 50,
      ),
    );
  }
}
