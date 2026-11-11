import 'package:get/get.dart';
import 'package:story_box/ui/filter_page/controller/filter_controller.dart';

import '../controller/home_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut<FilterController>(() => FilterController());
  }
}
