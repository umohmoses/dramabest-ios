// // ignore_for_file: must_be_immutable
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:story_box/custom_widget/custom_gradiant_text.dart';
// import 'package:story_box/main.dart';
// import 'package:story_box/ui/splash_screen/controller/splash_controller.dart';
// import 'package:story_box/utils/asset.dart';
// import 'package:story_box/utils/color.dart';
// import 'package:story_box/utils/enums.dart';
// import 'package:story_box/utils/font_style.dart';
//
// class SplashScreenView extends StatelessWidget {
//   SplashScreenView({super.key});
//   SplashScreenController splashScreenController =
//       Get.find<SplashScreenController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: AppColor.colorBlack,
//         // body: Center(
//         //   child: Column(
//         //     mainAxisAlignment: MainAxisAlignment.center,
//         //     children: [
//         //       Text(
//         //         EnumLocal.txtAppName.name.tr,
//         //         style: AppFontStyle.styleW700(AppColor.colorWhite, 40),
//         //       ),
//         //       50.height,
//         //       const CircularProgressIndicator(
//         //         color: AppColor.primaryColor,
//         //       ),
//         //     ],
//         //   ),
//         // ),
//         body: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Container(
//               height: Get.height,
//               width: Get.width,
//               decoration: const BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage(AppAsset.splashPlainBg),
//                       fit: BoxFit.cover)),
//             ),
//             Positioned(
//
//               child: Center(
//                 child: Image.asset(
//                   AppAsset.splashCenterIcon,
//                   width: 200,
//                   height: 200,
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }
// }
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/ui/splash_screen/controller/splash_controller.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  SplashScreenController splashScreenController =
  Get.find<SplashScreenController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true); // zoom in/out repeatedly

    _animation = Tween<double>(begin: 1.4, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAsset.splashPlainBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Center(
          //   child: ScaleTransition(
          //     scale: _animation,
          //     child: Image.asset(
          //       AppAsset.splashCenterIcon,
          //       width: 100,
          //       height: 100,
          //     ),
          //   ),
          // ),
          Align(
            alignment: const Alignment(0, -0.12),
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset(
                AppAsset.splashCenterIcon,
                width: 100,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
