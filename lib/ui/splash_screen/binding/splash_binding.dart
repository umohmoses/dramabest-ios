import 'package:get/get.dart';
import 'package:story_box/ui/splash_screen/controller/splash_controller.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
  }
}
