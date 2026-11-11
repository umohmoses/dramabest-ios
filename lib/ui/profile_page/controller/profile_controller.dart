import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:story_box/custom_widget/block_user_dialog.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/login_page/model/login_user_model.dart';
import 'package:story_box/ui/profile_page/api/profile_api.dart';
import 'package:story_box/utils/preference.dart';

class ProfileController extends GetxController {
  User? user;
  LoginUserModel? loginUserModel;
  bool isChecked = false;
  RxInt remainingTime = 10.obs;
  Timer? _timer;
  HomeController homeController = Get.put(HomeController());

  @override
  void onInit() async {
    await profileDataGet();

    loginUserModel = await ProfileApi.callApi();

    update(['userProfile']);
    if (loginUserModel?.message == "you are blocked by the admin.") {
      showBlockedUserDialog();

      return;
    }
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> profileDataGet() async {
    String? userDataJson = Preference.shared.getString(Preference.userData);
    if (userDataJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userDataJson);

      loginUserModel = LoginUserModel.fromJson(userMap);
    }
    update(["userProfile"]);
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingTime.value > 0) {
          remainingTime.value--;
        } else {
          _timer?.cancel();
        }
      },
    );
  }
}
