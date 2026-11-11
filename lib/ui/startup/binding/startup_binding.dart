import 'package:get/get.dart';
import '../controller/startup_controller.dart';
import 'package:story_box/utils/global_video_manager.dart';

class StartupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StartupController>(StartupController(), permanent: true);
    Get.put<GlobalVideoManager>(GlobalVideoManager(), permanent: true);
  }
}
