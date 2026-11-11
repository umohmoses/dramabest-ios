import 'package:get/get.dart';
import 'package:story_box/ui/language_page/controller/language_controller.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageController>(() => LanguageController());
  }
}
