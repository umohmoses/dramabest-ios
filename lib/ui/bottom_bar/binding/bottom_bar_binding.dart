import 'package:get/get.dart';
import 'package:story_box/ui/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:story_box/ui/earn_reward_page/controller/earn_reward_controller.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/profile_page/controller/profile_controller.dart';
import 'package:story_box/ui/reels_page/controller/reels_controller.dart';
import 'package:story_box/ui/refill/controller/refill_controller.dart';

class BottomBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomBarController());
    Get.lazyPut(() => HomeController());
    Get.put(ReelsController());
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => EarnRewardController(), fenix: true);
    Get.put(RefillController());
  }
}
