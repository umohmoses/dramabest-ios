import 'package:flutter/material.dart';
import 'package:story_box/utils/color.dart';

class ProfileItemViewWidget extends StatelessWidget {
  final String imagePath;
  final String text;
  final double imageHeight;
  final VoidCallback onTap;

  const ProfileItemViewWidget({
    super.key,
    required this.imagePath,
    required this.text,
    required this.imageHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        decoration: const BoxDecoration(color: AppColor.transparent),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              height: imageHeight,
            ),
            const SizedBox(width: 10),
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
              color: Colors.white.withValues(alpha: 0.7),
              size: 24,
            )
          ],
        ),
      ),
    );
  }
}
