import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:story_box/utils/utils.dart';

bool isRevenueCatReady = false;
RxBool hasActiveSubscription = false.obs;

class PremiumManager {
  static var instance = PremiumManager();
  List<Package> availablePackages = [];
  List<Package> currentOffering = [];

  final RxBool hasActiveSubscription = false.obs;
  Stream<bool> get subscriptionStream => hasActiveSubscription.stream;

  bool validateSubscriptionStatus(CustomerInfo userInfo) {
    // RevenueCat handles entitlements - use their built-in system
    Utils.showLog('🔔 Subscription Status: ${userInfo.entitlements.active}');
    if (userInfo.entitlements.active.isNotEmpty) {
      hasActiveSubscription.value = true;
      Utils.showLog('🔔 Subscription Status: Active via Entitlements');
      Utils.showLog('🔔 Subscription Status: ${userInfo.entitlements.active}');
      final premiumEntitlement = userInfo.entitlements.active["premium"];
      if (premiumEntitlement != null) {
        hasActiveSubscription.value = true;

        Utils.showLog('🔔 Premium Subscription Active');
        Utils.showLog('   Identifier: ${premiumEntitlement.identifier}');
        Utils.showLog('   Product ID: ${premiumEntitlement.productIdentifier}');
        Utils.showLog('   Will Renew: ${premiumEntitlement.willRenew}');
        Utils.showLog('   Expires: ${premiumEntitlement.expirationDate}');
        Utils.showLog('   Is Active: ${premiumEntitlement.isActive}');

        return true;
      }
      Utils.showLog('🔔 Subscription Status: ${userInfo.entitlements.active.keys.toList()} ${userInfo.latestExpirationDate} ${DateTime.parse(userInfo.latestExpirationDate!).toLocal()}');
      return true;
    }

    // Fallback to expiration date check
    if (userInfo.latestExpirationDate == null || userInfo.latestExpirationDate!.isEmpty) {
      hasActiveSubscription.value = false;
      Utils.showLog('🔔 Subscription Status: InActive (No expiration date)');
      return false;
    }

    final expiryDate = DateTime.parse(userInfo.latestExpirationDate!).toLocal();
    final currentTime = DateTime.now();
    final isActive = expiryDate.isAfter(currentTime);

    hasActiveSubscription.value = isActive;

    final remainingSeconds = expiryDate.difference(currentTime).inSeconds;
    Utils.showLog('⏱️ Expire Time: $expiryDate | Current Time: $currentTime | Time Left: ${remainingSeconds > 0 ? remainingSeconds : 0}s');
    Utils.showLog('🔔 Subscription Status: ${isActive ? "Active" : "InActive"}');

    return isActive;
  }

  Future<void> setupRevenueCatSDK() async {
    PurchasesConfiguration config;

    if (Platform.isAndroid) {
      if (Utils.revenueCatAndroidApiKey.isNotEmpty) {
        config = PurchasesConfiguration(Utils.revenueCatAndroidApiKey)..appUserID = null;

        Purchases.setLogLevel(LogLevel.debug);
        await Purchases.configure(config);
      }
    } else if (Platform.isIOS) {
      if (Utils.revenueCatAppleApiKey.isNotEmpty) {
        config = PurchasesConfiguration(Utils.revenueCatAppleApiKey)..appUserID = null;

        Purchases.setLogLevel(LogLevel.debug);
        await Purchases.configure(config);
      }
    }

    await verifyConfiguration();
    await getAvailableProducts();

    // ✅ Start listening AFTER configuration
    await startSubscriptionTracking();

    // ✅ Check initial status
    await getCurrentSubscriptionStatus();
  }
  // bool validateSubscriptionStatus(CustomerInfo userInfo) {
  //   if (userInfo.latestExpirationDate == null || userInfo.latestExpirationDate!.isEmpty) {
  //     hasActiveSubscription.value = false;
  //   } else {
  //     DateTime expiryDate = DateTime.parse(userInfo.latestExpirationDate ?? '').toLocal();
  //     DateTime currentTime = DateTime.now();
  //
  //     int remainingSeconds = expiryDate.difference(currentTime).inSeconds;
  //     Utils.showLog('⏱️ Expire Time : $expiryDate == Current Time : $currentTime || Time Left: ${remainingSeconds > 0 ? remainingSeconds : 0} seconds');
  //
  //     if (expiryDate.compareTo(currentTime) < 0) {
  //       hasActiveSubscription.value = false;
  //     }
  //     if (expiryDate.compareTo(currentTime) > 0) {
  //       hasActiveSubscription.value = true;
  //     }
  //   }
  //
  //   Utils.showLog('🔔 Subscription Status : ${hasActiveSubscription.value ? 'Active' : 'InActive'}');
  //   return hasActiveSubscription.value;
  // }

  Future<void> startSubscriptionTracking() async {
    try {
      Purchases.addCustomerInfoUpdateListener((userInfo) async {
        // int verificationStatus = validateSubscriptionStatus(userInfo) ? 1 : 0;
        Utils.showLog('📱 CustomerInfo Updated - Checking subscription status...');

        final isActive = validateSubscriptionStatus(userInfo);
        final verificationStatus = isActive ? 1 : 0;

        Utils.showLog('✅ Verification Status: $verificationStatus');
        Utils.showLog('🔑 Active Entitlements: ${userInfo.entitlements.active.keys.toList()}');
        Utils.showLog('📅 Latest Expiration: ${userInfo.latestExpirationDate}');

        // User? currentUser = SessionManager.instance.getUser();
        // if (currentUser?.isVerify == verificationStatus) {
        //   return;
        // }
        // UserService.instance.updateUserDetails(isVerify: verificationStatus);
      });
    } on PlatformException catch (e) {
      // Error fetching purchaser info
      Utils.showLog('RevenueCat Error : ${e.message.toString()}');
    }
  }

  Future<void> verifyConfiguration() async {
    isRevenueCatReady = await Purchases.isConfigured;
    Utils.showLog('isRevenueCatReady  :$isRevenueCatReady');
  }

  Future<LogInResult> authenticateUser(String userId) async {
    return await Purchases.logIn(userId);
  }

  Future<(Offering?, String?)> getAvailableProducts() async {
    try {
      Offerings productOfferings = await Purchases.getOfferings();
      // Display current offering with offerings.current
      currentOffering.addAll(productOfferings.current?.availablePackages.where((element) => element.packageType == PackageType.custom) ?? []);

      availablePackages.addAll(productOfferings.current?.availablePackages.where((element) => element.packageType != PackageType.custom) ?? []);
      availablePackages.sort((a, b) => b.storeProduct.price.compareTo(a.storeProduct.price));

      return (productOfferings.current, null);
    } on PlatformException catch (e) {
      // Error restoring purchases
      Utils.showLog('Fetch Offering : ${e.message.toString()}');
      return (null, e.message);
    }
  }

  Future<bool?> getCurrentSubscriptionStatus() async {
    try {
      Utils.showLog("getCurrentSubscriptionStatus: 01");
      CustomerInfo userInfo = await Purchases.getCustomerInfo();
      Utils.showLog("getCurrentSubscriptionStatus: 001 ${userInfo.entitlements.verification} ${userInfo.entitlements.props.toList()} ${userInfo.entitlements.all}");
      return validateSubscriptionStatus(userInfo);
    } on PlatformException catch (e) {
      Utils.showLog("getCurrentSubscriptionStatus:error ${e.message.toString()}");
      // Error fetching purchaser info
    }
    return null;
  }

  bool isProActive(CustomerInfo info) {
    final entitlement = info.entitlements.active['pro'];
    final entitlementOne = info.entitlements.active['plus'];
    Utils.showLog("entitlementOne : $entitlementOne");
    return entitlement != null && entitlement.isActive;
  }

  /// subscription
  Future<bool?> processPurchase(Package selectedPackage) async {
    try {
      PurchaseResult userInfo = await Purchases.purchasePackage(selectedPackage);
      return validateSubscriptionStatus(userInfo.customerInfo);
    } on PlatformException catch (e) {
      Utils.showLog("processPurchase $e");

      return null;
    }
  }

  /// in app purchase
  Future<CustomerInfo?> executeCustomPurchase(Package selectedPackage) async {
    try {
      PurchaseResult purchaseInfo = await Purchases.purchasePackage(selectedPackage);
      return purchaseInfo.customerInfo;
    } on PlatformException catch (e) {
      Utils.showLog("executeCustomPurchase: ${e.message}");
      return null;
    }
  }

  static Future<bool> onCheckSubscriptionIsActive() async {
    final CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    final bool isActiveSubscription = customerInfo.entitlements.all["Membership Access"]?.isActive ?? false;

    Utils.showLog("Check Subscription Is Active => $isActiveSubscription");
    return isActiveSubscription;
  }
}

// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:story_box/utils/utils.dart';

// class PremiumManager {
//   static var instance = PremiumManager();
//   static bool isRevenueCatReady = false;
//   static RxBool hasActiveSubscription = false.obs;
//
//   static List<Package> availablePackages = [];
//   static List<Package> currentOffering = [];
//
//   static Future<void> onSetupRevenueCatSDK() async {
//     try {
//       PurchasesConfiguration config;
//
//       if (Platform.isAndroid) {
//         if (Utils.revenueCatAndroidApiKey.isNotEmpty) {
//           config = PurchasesConfiguration(Utils.revenueCatAndroidApiKey);
//           Purchases.setLogLevel(LogLevel.debug);
//           await Purchases.configure(config);
//         }
//       } else if (Platform.isIOS) {
//         if (Utils.revenueCatAppleApiKey.isNotEmpty) {
//           config = PurchasesConfiguration(Utils.revenueCatAppleApiKey);
//           Purchases.setLogLevel(LogLevel.debug);
//           await Purchases.configure(config);
//         }
//       }
//
//       await onVerifyConfiguration();
//       await onGetAvailableProducts();
//     } catch (e) {
//       Utils.showLog("❌ Setup RevenueCatSDK Failed => $e");
//     }
//   }
//
//   static Future<bool> onCheckSubscriptionIsActive() async {
//     final CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//     final bool isActiveSubscription = customerInfo.entitlements.all["Membership Access"]?.isActive ?? false;
//
//     Utils.showLog("Check Subscription Is Active => $isActiveSubscription");
//     return isActiveSubscription;
//   }
//
//   static bool validateSubscriptionStatus(CustomerInfo userInfo) {
//     if (userInfo.latestExpirationDate == null || userInfo.latestExpirationDate!.isEmpty) {
//       hasActiveSubscription.value = false;
//     } else {
//       DateTime expiryDate = DateTime.parse(userInfo.latestExpirationDate ?? '').toLocal();
//       DateTime currentTime = DateTime.now();
//
//       int remainingSeconds = expiryDate.difference(currentTime).inSeconds;
//       Utils.showLog('⏱️ Expire Time : $expiryDate == Current Time : $currentTime || Time Left: ${remainingSeconds > 0 ? remainingSeconds : 0} seconds');
//
//       if (expiryDate.compareTo(currentTime) < 0) {
//         hasActiveSubscription.value = false;
//       }
//       if (expiryDate.compareTo(currentTime) > 0) {
//         hasActiveSubscription.value = true;
//       }
//     }
//
//     Utils.showLog("🔔 Subscription Status => ${hasActiveSubscription.value}");
//
//     return hasActiveSubscription.value;
//   }
//
//   static Future<void> onStartSubscriptionTracking() async {
//     try {
//       Purchases.addCustomerInfoUpdateListener((userInfo) async {
//         int verificationStatus = validateSubscriptionStatus(userInfo) ? 1 : 0;
//
//         Utils.showLog("🔔 Verification Status => $verificationStatus");
//
//         // User? currentUser = SessionManager.instance.getUser();
//         // if (currentUser?.isVerify == verificationStatus) {
//         //   return;
//         // }
//         // UserService.instance.updateUserDetails(isVerify: verificationStatus);
//       });
//     } catch (e) {
//       Utils.showLog("❌ Start Subscription Tracking Failed => $e");
//     }
//   }
//
//   static Future<void> onVerifyConfiguration() async {
//     isRevenueCatReady = await Purchases.isConfigured;
//     Utils.showLog("🔔 Verify Configuration => RevenueCatReady => $isRevenueCatReady");
//   }
//
//   static Future<LogInResult> onAuthenticateUser(String userId) async {
//     return await Purchases.logIn(userId);
//   }
//
//   static Future<(Offering?, String?)> onGetAvailableProducts() async {
//     try {
//       Offerings productOfferings = await Purchases.getOfferings();
//
//       currentOffering.addAll(productOfferings.getOffering("plus")?.availablePackages.where((element) => element.packageType == PackageType.custom) ?? []);
//
//       availablePackages.addAll(productOfferings.getOffering("plus")?.availablePackages.where((element) => element.packageType != PackageType.custom) ?? []);
//
//       availablePackages.sort((a, b) => b.storeProduct.price.compareTo(a.storeProduct.price));
//
//       Utils.showLog("✅ Get Available Products => ${currentOffering.length} *** ${availablePackages.length}");
//       return (productOfferings.current, null);
//     } catch (e) {
//       Utils.showLog("❌ Get Available Products Failed => $e");
//       return (null, null);
//     }
//   }
//
//   static Future<bool?> onGetCurrentSubscriptionStatus() async {
//     try {
//       CustomerInfo userInfo = await Purchases.getCustomerInfo();
//
//       return validateSubscriptionStatus(userInfo);
//     } catch (e) {
//       Utils.showLog("❌ Get Current Subscription Status Failed => $e");
//       return null;
//     }
//   }
//
//   // *** Subscription ***
//
//   static Future<bool?> onProcessPurchase(Package selectedPackage) async {
//     try {
//       PurchaseResult purchaseResult = await Purchases.purchasePackage(selectedPackage);
//       return validateSubscriptionStatus(purchaseResult.customerInfo);
//     } catch (e) {
//       Utils.showLog("❌ Process Purchase Failed => $e");
//       return null;
//     }
//   }
//
//   // *** In App Purchase ***
//
//   static Future<CustomerInfo?> onExecuteCustomPurchase(Package selectedPackage) async {
//     try {
//       PurchaseResult purchaseResult = await Purchases.purchasePackage(selectedPackage);
//
//       return purchaseResult.customerInfo;
//     } catch (e) {
//       Utils.showLog("❌ Execute Custom Purchase Failed => $e");
//       return null;
//     }
//   }
//
//   static Future<bool?> onRecoverPurchases() async {
//     try {
//       CustomerInfo recoveredInfo = await Purchases.restorePurchases();
//       return validateSubscriptionStatus(recoveredInfo);
//     } catch (e) {
//       Utils.showLog("❌ Recover Purchases Failed => $e");
//       return null;
//     }
//   }
// }
