import 'package:get/get.dart';
import 'package:story_box/ui/earn_reward_page/controller/earn_reward_controller.dart';

class EranRewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EarnRewardController());
  }
}
