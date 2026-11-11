import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:story_box/payment/subscription/subscription_manager.dart';
import 'package:story_box/payment/secure_checkout/secure_checkout.dart';
import 'package:story_box/ui/refill/api/store_api.dart';
import 'package:story_box/ui/refill/model/coin_plan.dart';
import 'package:story_box/ui/refill/model/vip_plan.dart';
import 'package:story_box/ui/setting_view_page/api/setting_api.dart';
import 'package:story_box/ui/setting_view_page/model/setting.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/payment/in_app_purchase/iap_callback.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:story_box/utils/utils.dart';

class RefillController extends GetxController {
  List<CoinPlan> coinPlan = [];
  List<VipPlan> vipPlan = [];
  bool isLoadingVipPlan = false;
  bool isLoadingCoinPlan = false;
  CoinPlan? selectedCoinPlan;
  VipPlan? selectedVipPlan;

  Setting? setting;
  List<Package> packages = [];
  List<Package> offerings = [];
  bool isActive = false;
  @override
  void onInit() async {
    packages = PremiumManager.instance.availablePackages;
    List<Package> items = PremiumManager.instance.currentOffering;
    offerings.addAll(items);

    refreshPlans();
    SettingApi.callApi();
    isActive = await PremiumManager.onCheckSubscriptionIsActive();
    super.onInit();

    Utils.showLog("Constant.stripeSwitch${Constant.stripeSwitch}");
    Utils.showLog("Constant.googlePlaySwitch${Constant.googlePlaySwitch}");
    Utils.showLog("Constant.googlePlaySwitch${SettingApi.setting?.flutterWaveSwitch}");
  }

  DateTime? _plansLoadedAt;

  /// Re-reads plans and local prices from the server, so admin changes show without restarting the app.
  Future<void> refreshPlans() async {
    final now = DateTime.now();
    if (_plansLoadedAt != null && now.difference(_plansLoadedAt!).inSeconds < 30) return;
    _plansLoadedAt = now;
    await SecureCheckout.loadCatalog();
    await Future.wait([getCoinPlanApi(), getVipPlanApi()]);
  }

  Future<void> getCoinPlanApi() async {
    isLoadingCoinPlan = true;
    coinPlan = await StoreApi.fetchCoinPlanApi();
    await _applyLocalPrices();
    for (var plan in coinPlan) {
      Utils.showLog("Coin Plan ID: ${plan.sId}");
    }
    isLoadingCoinPlan = false;
    update(['coinPlan']);
  }

  Future<void> getVipPlanApi() async {
    isLoadingVipPlan = true;
    vipPlan = await StoreApi.fetchVipPlanApi();
    await _applyLocalPrices();
    isLoadingVipPlan = false;
    update(['vipPlan']);
  }

  /// Show prices in the buyer's currency (from the server catalogue); the server charges exactly this.
  Future<void> _applyLocalPrices() async {
    if (SecureCheckout.catalog == null) await SecureCheckout.loadCatalog();
    final cat = SecureCheckout.catalog;
    if (cat == null) return;
    for (final p in coinPlan) {
      final lp = SecureCheckout.localPrice('coin', p.sId);
      if (lp != null) {
        p.price = lp['price'];
        p.offerPrice = lp['price'];
      }
    }
    for (final p in vipPlan) {
      final lp = SecureCheckout.localPrice('vip', p.sId);
      if (lp != null) {
        p.price = lp['price'];
        p.offerPrice = lp['price'];
      }
    }
    if (cat['symbol'] is String) Constant.currencyIcon = cat['symbol'];
  }

  void selectCoinPlan(int index) {
    selectedCoinPlan = coinPlan[index];
    Utils.showLog("Selected Coin Plan ID: ${selectedCoinPlan?.sId}");
    update(['coinPlan']);
  }

  void selectVipPlan(int index) {
    selectedVipPlan = vipPlan[index];
    update(['coinPlan']);
  }

  // Method to handle in-app purchase for coin plans
  // Future<void> handleCoinPlanInAppPurchase() async {
  //   try {
  //     if (selectedCoinPlan == null) {
  //       Utils.showLog("No coin plan selected");
  //       return;
  //     }
  //
  //     String productKey = selectedCoinPlan!.productKey ?? "";
  //     if (productKey.isEmpty) {
  //       Utils.showLog("Product key is empty for coin plan");
  //       return;
  //     }
  //
  //     List<String> kProductIds = <String>[productKey];
  //
  //     // Initialize with custom callback
  //     InAppPurchaseHelper().init(
  //       paymentType: "In App Purchase",
  //       userId: Preference.userId,
  //       productKey: kProductIds,
  //       rupee: selectedCoinPlan!.offerPrice?.toDouble() ?? 0.0,
  //     );
  //
  //     // Setup purchase listener with callback for coin plan
  //     InAppPurchaseHelper().setupPurchaseListener(CoinPlanIAPCallback(
  //       coinPlanId: selectedCoinPlan!.sId ?? '',
  //       refillController: this,
  //     ));
  //
  //     Utils.showLog("Coin plan initialization completed");
  //
  //     // Wait for store info to load
  //     bool storeInitialized = await InAppPurchaseHelper().initStoreInfo();
  //
  //     if (!storeInitialized) {
  //       Utils.showLog("Store initialization failed");
  //       return;
  //     }
  //
  //     Utils.showLog("selectedCoinPlan.productKey :: $productKey");
  //
  //     ProductDetails? product = InAppPurchaseHelper().getProductDetail(productKey);
  //     if (product != null) {
  //       Utils.showLog("Product details retrieved successfully for :: ${product.id}");
  //       await InAppPurchaseHelper().buyProduct(product);
  //     } else {
  //       Utils.showLog("Product is null for :: $productKey");
  //     }
  //   } catch (e) {
  //     Utils.showLog("Error in handleCoinPlanInAppPurchase: $e");
  //     Utils.showToast(Get.context!, "Error initiating purchase");
  //   }
  // }

  Future<void> handleCoinPlanInAppPurchase() async {
    try {
      if (selectedCoinPlan == null) {
        Utils.showLog("No coin plan selected");
        return;
      }

      String productKey = selectedCoinPlan!.productKey ?? "";

      Package package = offerings.firstWhere((element) => element.storeProduct.identifier == productKey);
      PremiumManager.instance.executeCustomPurchase(package).then((value) {
        if (value != null) {
          Utils.showLog("In-app purchase completed for product: $productKey");

          recordCoinPlanHistoryApi("in_app_purchase");
          Utils.showToast(Get.context!, "In-app purchase Successfully for product: $productKey");
        } else {
          Utils.showLog("In-app purchase failed for product: $productKey");
          Utils.showToast(Get.context!, "In-app purchase failed for product");
        }
      });
    } catch (e) {
      Utils.showLog("Error in handleCoinPlanInAppPurchase: $e");
      Utils.showToast(Get.context!, "Error initiating purchase");
    }
  }

  Future<bool> recordCoinPlanHistoryApi(String paymentType) async {
    final isSuccess = await StoreApi.recordCoinPlanHistory(
      loginUserId: Preference.userId,
      coinPlanId: selectedCoinPlan?.sId ?? '',
      paymentType: paymentType,
    );

    if (isSuccess) {
      update(['updateCoin']);
    }

    return isSuccess;
  }

  Future<void> recordVipPlanHistoryApi(String paymentType, String id) async {
    await StoreApi.recordVipPlanHistory(
      loginUserId: Preference.userId,
      vipPlanId: id,
      paymentType: paymentType,
    );
    Utils.showLog("Call Payment Type $paymentType");
    Preference.isVip;
    update(['vipPlan']);
  }

  Future<void> onSubscription({String? productKey, required VipPlan plan}) async {
    for (var element in packages) {
      Utils.showLog("Looking for productKey: 01 ${element.identifier}");
    }
    // Utils.showLog("Looking for productKey: ${}");
    try {
      Utils.showLog("Subscription packages >>>> ${packages.map((e) => e.toString()).toList()}");
      Utils.showLog("Looking for productKey: $productKey");

      // Find matching package by comparing productKey with storeProduct.identifier
      Package? matchedPackage = packages.firstWhere(
        (package) {
          Utils.showLog("message>>>> ${package.storeProduct.identifier}");
          return package.identifier == productKey;
        },
      );

      Utils.showLog("Matched package identifier: ${matchedPackage.identifier}");
      bool? status = await PremiumManager.instance.processPurchase(matchedPackage);
      if (status == true) {
        recordVipPlanHistoryApi("In App Purchase", plan.sId ?? "");

        Get.snackbar(
          "Success",
          "Successfully subscribed to plan!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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
    } catch (e) {
      Utils.showLog("Error in onSubscription: $e");
      Get.snackbar(
        "Error",
        "An error occurred while subscribing!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class CoinPlanIAPCallback extends IAPCallback {
  final String coinPlanId;
  final RefillController refillController;

  CoinPlanIAPCallback({
    required this.coinPlanId,
    required this.refillController,
  });

  @override
  void onSuccessPurchase(PurchaseDetails product) {
    Utils.showLog("Coin Plan purchase successful: ${product.productID}");

    // Call the API to record coin plan history
    refillController.recordCoinPlanHistoryApi(
      "in_app_purchase",
    );

    // Show success message
    Utils.showToast(Get.context!, "Coins purchased successfully!");

    // Navigate back or refresh UI if needed
    Get.back();
  }

  @override
  void onBillingError(dynamic error) {
    Utils.showLog("Coin Plan purchase error: $error");
    Utils.showToast(Get.context!, "Purchase failed. Please try again.");
  }

  @override
  void onPending(PurchaseDetails product) {
    Utils.showLog("Coin Plan purchase pending: ${product.productID}");
    Utils.showToast(Get.context!, "Purchase is pending...");
  }
}
