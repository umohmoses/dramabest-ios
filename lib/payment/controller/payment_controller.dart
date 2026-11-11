import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:story_box/deep_link/share_manager/pure_flutter_share_service.dart';
import 'package:story_box/payment/common_payment/common_payment.dart';
import 'package:story_box/payment/in_app_purchase/iap_callback.dart';
import 'package:story_box/payment/in_app_purchase/in_app_purchase.dart';
import 'package:story_box/ui/refill/controller/refill_controller.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/progress_dialog.dart';
import 'package:story_box/utils/utils.dart';

class PaymentController extends GetxController implements IAPCallback {
  final refillController = Get.find<RefillController>();

  bool isPremium = false;
  bool isProcessingPayment = false;

  Map<String, PurchaseDetails>? purchases;

  Future<void> makePaymentViaStripe() async {
    if (isProcessingPayment) {
      Utils.showLog("Payment already in progress");
      return;
    }

    try {
      isProcessingPayment = true;

      num amount = refillController.selectedCoinPlan?.offerPrice ?? 0.0;
      Utils.showLog("Stripe payment amount: $amount");

      int amountInCents = (amount * 1).toInt(); // Convert to cents
      Utils.showLog("Amount in cents: $amountInCents");

      Get.dialog(ProgressDialog(), barrierDismissible: false);

      stripe(
        amount: amount,
        onPaymentSuccess: () async {
          Utils.showLog("Stripe Payment Success Method Called....");
          Get.dialog(const LoadingWidget(), barrierDismissible: false); // Start Loading...
          final isSuccess = await refillController.recordCoinPlanHistoryApi("Stripe");

          Get.back(); // Stop Loading...
          if (isSuccess) {
            Utils.showToast(Get.context!, EnumLocal.txtPaymentSuccessfully.name.tr);
            Get.close(2);
          } else {
            Utils.showToast(Get.context!, EnumLocal.txtSomeThingWentWrong.name.tr);
          }
        },
      ).then((value) async {
        Utils.showLog("Stripe Payment Successfully");
      }).catchError((e) {
        Utils.showLog("Stripe Payment Error !!!");
      });
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Utils.showLog("Error in Stripe payment: $e");

      Fluttertoast.showToast(
        msg: "${EnumLocal.txtPaymentError.name.tr}: $e",
        backgroundColor: AppColor.darkRed,
        textColor: AppColor.colorWhite,
        fontSize: 16.0,
      );
    } finally {
      isProcessingPayment = false;
    }
  }

  Future<void> makePaymentViaFlutterWave() async {
    if (isProcessingPayment) {
      Utils.showLog("Payment already in progress");
      return;
    }

    try {
      isProcessingPayment = true;

      num amount = refillController.selectedCoinPlan?.offerPrice ?? 0.0;
      Utils.showLog("Stripe payment amount: $amount");

      int amountInCents = (amount * 1).toInt(); // Convert to cents
      Utils.showLog("Amount in cents: $amountInCents");

      Get.dialog(ProgressDialog(), barrierDismissible: false);

      flutterWave(
        amount: amount,
        onPaymentSuccess: () async {
          Utils.showLog("Flutter Wave Payment Successfully");

          Get.dialog(const LoadingWidget(), barrierDismissible: false); // Start Loading...

          final isSuccess = await refillController.recordCoinPlanHistoryApi("FlutterWave");

          Get.back(); // Stop Loading...

          if (isSuccess) {
            Utils.showToast(Get.context!, EnumLocal.txtPaymentSuccessfully.name.tr);
            Get.close(2);
          } else {
            Utils.showToast(Get.context!, EnumLocal.txtSomeThingWentWrong.name.tr);
          }
        },
      ).then((value) async {
        Utils.showLog("Stripe Payment Successfully");
      }).catchError((e) {
        Utils.showLog("Stripe Payment Error !!!");
      });
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Utils.showLog("Error in Stripe payment: $e");

      Fluttertoast.showToast(
        msg: "${EnumLocal.txtPaymentError.name.tr}: $e",
        backgroundColor: AppColor.darkRed,
        textColor: AppColor.colorWhite,
        fontSize: 16.0,
      );
    } finally {
      isProcessingPayment = false;
    }
  }

  Future<void> makePaymentViaPayStack() async {
    if (isProcessingPayment) {
      Utils.showLog("Payment already in progress");
      return;
    }

    try {
      isProcessingPayment = true;

      num amount = refillController.selectedCoinPlan?.offerPrice ?? 0.0;
      Utils.showLog("Stripe payment amount: $amount");

      int amountInCents = (amount * 1).toInt(); // Convert to cents
      Utils.showLog("Amount in cents: $amountInCents");

      Get.dialog(ProgressDialog(), barrierDismissible: false);

      payStack(
        amount: amountInCents,
        onPaymentSuccess: () async {
          Utils.showLog("pay stack Payment Successfully");

          Get.dialog(const LoadingWidget(), barrierDismissible: false); // Start Loading...

          final isSuccess = await refillController.recordCoinPlanHistoryApi("PayStack");

          Get.back(); // Stop Loading...

          if (isSuccess) {
            Utils.showToast(Get.context!, EnumLocal.txtPaymentSuccessfully.name.tr);
            Get.close(2);
          } else {
            Utils.showToast(Get.context!, EnumLocal.txtSomeThingWentWrong.name.tr);
          }
        },
      ).then((value) async {
        Utils.showLog("Stripe Payment Successfully");
      }).catchError((e) {
        Utils.showLog("Stripe Payment Error !!!");
      });
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      log("Error in Stripe payment: $e");

      Fluttertoast.showToast(
        msg: "${EnumLocal.txtPaymentError.name.tr}: $e",
        backgroundColor: AppColor.darkRed,
        textColor: AppColor.colorWhite,
        fontSize: 16.0,
      );
    } finally {
      isProcessingPayment = false;
    }
  }

  Future<void> makeInAppPurchase(String productKey) async {
    if (isProcessingPayment) {
      log("Payment already in progress");
      return;
    }

    try {
      isProcessingPayment = true;
      log("Starting in-app purchase for product: $productKey");

      // Validate selected plan
      if (refillController.selectedCoinPlan == null) {
        throw Exception("No coin plan selected");
      }
      inAppPurchase(
          amount: refillController.selectedCoinPlan?.offerPrice?.toDouble() ?? 0.0,
          onPaymentSuccess: () async {
            Utils.showLog("In App Purchase Payment Successfully");

            Get.dialog(const LoadingWidget(), barrierDismissible: false); // Start Loading...
            final isSuccess = await refillController.recordCoinPlanHistoryApi("In App Purchase");

            Get.back(); // Stop Loading...
            if (isSuccess) {
              Utils.showToast(Get.context!, EnumLocal.txtPaymentSuccessfully.name.tr);
              Get.close(2);
            } else {
              Utils.showToast(Get.context!, EnumLocal.txtSomeThingWentWrong.name.tr);
            }
          });

      InAppPurchaseHelper().initStoreInfo();

      await Future.delayed(const Duration(seconds: 1));

      ProductDetails? product = InAppPurchaseHelper().getProductDetail(productKey);

      if (product != null) {
        InAppPurchaseHelper().buyProduct(
          product,
        );
      }
    } catch (e) {
      isProcessingPayment = false;
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      log("Error in in-app purchase: $e");
      Fluttertoast.showToast(
        msg: "Purchase failed: $e",
        backgroundColor: AppColor.darkRed,
        textColor: AppColor.colorWhite,
        fontSize: 16.0,
      );
    }
  }

  /*Future<void> _handlePaymentSuccess(String paymentMethod) async {
    try {
      log("Handling payment success for method: $paymentMethod");

      // Call the API to record the purchase
      await refillController.recordCoinPlanHistoryApi(paymentMethod);

      // Show success message
      Fluttertoast.showToast(
        msg: "Payment successful!",
        backgroundColor: AppColor.darkGreen,
        textColor: AppColor.colorWhite,
        fontSize: 16.0,
      );

      // Update UI or navigate as needed
      // You might want to close dialogs, refresh data, etc.

      log("Payment success handled successfully");
    } catch (e) {
      log("Error handling payment success: $e");
      // Even if API call fails, we should still show success to user
      // since the payment was processed
      Fluttertoast.showToast(
        msg: "Payment successful! (Recording pending)",
        backgroundColor: AppColor.colorSecondary,
        textColor: AppColor.colorWhite,
        fontSize: 16.0,
      );
    }
  }*/

  // IAP Callback implementations

  Future<void> restorePurchases() async {
    try {
      log("Restoring purchases");
      Get.dialog(ProgressDialog(), barrierDismissible: false);

      await InAppPurchaseHelper().initStoreInfo();

      // Wait a moment for the restore process
      await Future.delayed(Duration(seconds: 2));

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Fluttertoast.showToast(
        msg: "Restore completed",
        backgroundColor: AppColor.blue,
        textColor: AppColor.colorWhite,
      );
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      log("Error restoring purchases: $e");
      Fluttertoast.showToast(
        msg: "Restore failed: $e",
        backgroundColor: AppColor.darkRed,
        textColor: AppColor.colorWhite,
      );
    }
  }

  @override
  void onBillingError(error) {
    // TODO: implement onBillingError
  }

  @override
  void onLoaded(bool initialized) {
    // TODO: implement onLoaded
  }

  @override
  void onPending(PurchaseDetails product) {
    // TODO: implement onPending
  }

  @override
  void onSuccessPurchase(PurchaseDetails product) {
    // TODO: implement onSuccessPurchase
  }
}
