import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:story_box/payment/subscription/subscription_manager.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/utils.dart';

// Subscription Controller
class SubscriptionController extends GetxController {
  String selectedPlanIdentifier = ""; // Default to monthly plan
  bool isLoading = false;
  List<Package> packages = [];
  @override
  void onInit() {
    // TODO: implement onInit
    packages = PremiumManager.instance.availablePackages;
    Utils.showLog("Packages => ${packages.first.toString()}");
    super.onInit();
  }

  void selectPlan(int index) {
    selectedPlanIdentifier = packages[index].identifier;
    update();
  }

  Future<void> subscribeToPlan() async {
    isLoading = true;
    update();

    // Simulate API call

    bool? status = await PremiumManager.instance.processPurchase(packages.first);
    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    update();
    if (status == true) {
      // Show success message
      // Get.snackbar(
      //   "Success",
      //   "Successfully subscribed to plan!",
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );
      Utils.showToast(Get.context!, EnumLocal.txtSuccessfullySubscribedToPlan.name.tr);
    } else {
      // Get.snackbar(
      //   "Error",
      //   "Failed to subscribe to plan!",
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      Utils.showToast(Get.context!, EnumLocal.txtFailedToSubscribeToPlan.name.tr);
    }
  }
}

// Subscription Plan Model
class SubscriptionPlan {
  final String title;
  final String price;
  final String duration;
  final List<String> features;
  final bool isPopular;
  final String? discount;

  SubscriptionPlan({
    required this.title,
    required this.price,
    required this.duration,
    required this.features,
    this.isPopular = false,
    this.discount,
  });
}
