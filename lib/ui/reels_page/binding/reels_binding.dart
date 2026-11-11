import 'package:get/get.dart';
import 'package:story_box/ui/reels_page/controller/reels_controller.dart';

class ReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsController>(() => ReelsController());
  }
}
