import 'package:get/get.dart';
import 'package:story_box/ui/category_page/controller/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryWiseController>(() => CategoryWiseController());
  }
}
