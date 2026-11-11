import 'package:get/get.dart';
import 'package:story_box/ui/filter_page/controller/filter_controller.dart';

class FilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FilterController>(() => FilterController());
  }
}
