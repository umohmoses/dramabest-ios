import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:story_box/payment/controller/payment_controller.dart';
import 'package:story_box/ui/refill/controller/refill_controller.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/utils.dart';

class PaymentGatewayListPage extends StatelessWidget {
  PaymentGatewayListPage({super.key});

  final PaymentController paymentController = Get.put(PaymentController());
  final refillController = Get.find<RefillController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.65,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
        border: Border.all(
          color: AppColor.colorLightOrange.withValues(alpha: 0.3),
          width: 1.5,
        ),
        gradient: AppColor.luxuryBackgroundGradient,
      ),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 58,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.colorLightOrange.withValues(alpha: 0.15),
                  AppColor.colorLightYellow.withValues(alpha: 0.05),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColor.colorLightOrange.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(22),
                topLeft: Radius.circular(22),
              ),
            ),
            child: Center(
              child: Text(
                EnumLocal.selectPaymentOption.name.tr,
                style: AppFontStyle.styleW700(AppColor.colorLightYellow, 19),
              ),
            ),
          ),

          // ✅ Only list scrolls
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    if (Constant.stripeSwitch)
                      PaymentItemBuilder(
                        EnumLocal.stripe.name.tr,
                        AppAsset.stripe,
                        () async {
                          Get.back();
                          await paymentController.makePaymentViaStripe();
                        },
                      ),
                    if (Constant.googlePlaySwitch)
                      Platform.isAndroid
                          ? PaymentItemBuilder(
                              EnumLocal.inAppPurchase.name.tr,
                              AppAsset.inAppPurchase,
                              () async {
                                Get.back();
                                await _handleInAppPurchase();
                              },
                            )
                          : PaymentItemBuilder(
                              EnumLocal.applePurchase.name.tr,
                              AppAsset.applePay,
                              () async {
                                Get.back();
                                await _handleInAppPurchase();
                              },
                            ),
                    if (Constant.flutterWaveSwitch)
                      PaymentItemBuilder(
                        EnumLocal.flutterWave.name.tr,
                        AppAsset.flutterWave,
                        () async {
                          Get.back();
                          await paymentController.makePaymentViaFlutterWave();
                        },
                      ),
                    if (Constant.payStackSwitch)
                      PaymentItemBuilder(
                        EnumLocal.payStack.name.tr,
                        AppAsset.payStackImage,
                        () async {
                          Get.back();
                          await paymentController.makePaymentViaPayStack();
                        },
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleInAppPurchase() async {
    try {
      Utils.showLog("Starting in-app purchase process");

      if (refillController.selectedCoinPlan == null) {
        Utils.showLog("No coin plan selected");
        Utils.showToast(Get.context!, EnumLocal.txtPleaseSelectACoinPlanFirst.name.tr);
        return;
      }

      String productKey = refillController.selectedCoinPlan?.productKey ?? "";
      if (productKey.isEmpty) {
        Utils.showLog("Product key is empty for plan: ${refillController.selectedCoinPlan?.toJson()}");
        Utils.showToast(Get.context!, EnumLocal.txtProductKeyNotFoundForThisPlan.name.tr);
        return;
      }

      Utils.showLog("Initiating purchase for product: $productKey");
      Utils.showLog("Plan details: ${refillController.selectedCoinPlan?.toJson()}");

      await refillController.handleCoinPlanInAppPurchase();
    } catch (e) {
      Utils.showLog("Error in _handleInAppPurchase: $e");
      Utils.showToast(Get.context!, "${EnumLocal.txtFailedToStartPurchase.name.tr}: $e");
    }
  }
}

class PaymentItemBuilder extends StatelessWidget {
  final String name, icon;
  final Callback onTapItem;

  const PaymentItemBuilder(this.name, this.icon, this.onTapItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapItem,
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(1.2),
        decoration: BoxDecoration(
          gradient: AppColor.goldBorderGradient,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColor.luxuryCardSelected,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.colorLightOrange.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Center(
                  child: Image.asset(icon, height: 42, width: 42),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                name,
                style: AppFontStyle.styleW700(AppColor.colorWhite.withValues(alpha: 0.9), 16),
              ),
              const Spacer(),
              Image.asset(
                AppAsset.icRightArrow,
                width: 20,
                height: 20,
                color: AppColor.colorLightYellow,
              ).paddingOnly(right: 12),
            ],
          ),
        ),
      ),
    );
  }
}
