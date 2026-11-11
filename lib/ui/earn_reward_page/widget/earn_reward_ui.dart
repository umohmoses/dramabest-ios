// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/enums.dart';

class CheckInDialog extends StatefulWidget {
  const CheckInDialog({super.key, this.todayCoin});
  final String? todayCoin;

  @override
  State<CheckInDialog> createState() => _CheckInDialogState();
}

class _CheckInDialogState extends State<CheckInDialog> {
  bool _showLottie = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showLottie = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      // Gives consistent horizontal margin on all screen sizes
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Card + lottie overlay in an inner Stack
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black87,
                  image: const DecorationImage(
                    image: AssetImage(AppAsset.icDialogBackground),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 110,
                      child: Image.asset(AppAsset.icGiftDialog),
                    ),
                    14.height,
                    Text(
                      EnumLocal.txtCheckInSuccessful.name.tr,
                      style: TextStyle(
                        color: AppColor.colorLightOrange,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: Constant.appFontFamily,
                      ),
                    ),
                    50.height,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '+ ',
                          style: TextStyle(
                            color: AppColor.colorLightYellow,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constant.appFontFamily,
                          ),
                        ),
                        Image.asset(AppAsset.starCoin, height: 18).paddingOnly(right: 3),
                        Text(
                          '${widget.todayCoin}/${EnumLocal.txtCoins.name.tr}',
                          style: const TextStyle(
                            color: AppColor.colorLightYellow,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constant.appFontFamily,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              if (_showLottie)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Lottie.asset(
                      "assets/lottie/cannon.json",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Close button — naturally below the card, no magic offsets
          GestureDetector(
            onTap: Get.back,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                AppAsset.icClose,
                color: AppColor.colorWhite,
                height: 22,
                width: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
