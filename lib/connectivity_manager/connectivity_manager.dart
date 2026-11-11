import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/utils/enums.dart';

import '../utils/utils.dart';

class InternetConnectivity {
  // ------------------ SINGLETON -----------------------
  static final InternetConnectivity _internetConnectivity = InternetConnectivity._internal();

  factory InternetConnectivity() {
    return _internetConnectivity;
  }

  InternetConnectivity._internal();

  static InternetConnectivity get shared => _internetConnectivity;

  static Connectivity? _connectivity;

  /* make connection with preference only once in application */
  Future<Connectivity?> instance() async {
    if (_connectivity != null) return _connectivity;

    _connectivity = Connectivity();

    return _connectivity;
  }

  static Future<List<ConnectivityResult>> getStatus() async {
    return await _connectivity!.checkConnectivity(); // Corrected to return a single ConnectivityResult
  }

  static Future<bool> isInternetConnect() async {
    List<ConnectivityResult> result = await getStatus();

    if (result.first == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  static Future isInternetAvailable(BuildContext context, {required Function success, required Function retry}) async {
    List<ConnectivityResult> result = await getStatus();
    Utils.showLog("result::::::::$result");
    if (result.first != ConnectivityResult.none) {
      success();
      return;
    }
    Utils.showToast(Get.context!, EnumLocal.txtNoInternetConnection.name.tr);
    // Get.defaultDialog(
    //   content: WillPopScope(
    //     onWillPop: () async {
    //       return false;
    //     },
    //     child: Material(
    //       color: AppColor.colorWhite,
    //       child: Container(
    //         padding: const EdgeInsets.symmetric(horizontal: 20),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             /*Image.asset(
    //               AppAsset.icNoInternetConnection,
    //               width: AppSizes.width_85,
    //             ),*/
    //             const SizedBox(height: 25),
    //             Text(
    //               "${EnumLocal.txtWhoops.name.tr}! ${EnumLocal.txtNoInternetConnection.name.tr}",
    //               textAlign: TextAlign.center,
    //               style: AppFontStyle.styleW600(AppColor.colorBlack, 14),
    //             ),
    //             const SizedBox(height: 15),
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 20),
    //               child: Text(
    //                 EnumLocal.txtDescNoInternetConnection.name.tr,
    //                 textAlign: TextAlign.center,
    //                 style: AppFontStyle.styleW500(AppColor.colorBlack, 12),
    //               ),
    //             ),
    //             Container(
    //               margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
    //               child: TextButton(
    //                 onPressed: () async {
    //                   if (await InternetConnectivity.isInternetConnect()) {
    //                     Get.back();
    //                     retry();
    //                   } else {
    //                     Utils.showToast(Get.context!, EnumLocal.toastPleaseCheckYourInternetConnection.name.tr);
    //                   }
    //                 },
    //                 style: ButtonStyle(
    //                   backgroundColor: MaterialStateProperty.all(AppColor.colorPrimary),
    //                   shadowColor: MaterialStateProperty.all(AppColor.colorPrimary),
    //                   elevation: MaterialStateProperty.all(2),
    //                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //                     RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(5.0),
    //                       side: const BorderSide(color: AppColor.colorPrimary, width: 0.7),
    //                     ),
    //                   ),
    //                 ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 8),
    //                   child: Text(
    //                     EnumLocal.txtTryAgain.name.tr.toUpperCase(),
    //                     textAlign: TextAlign.center,
    //                     style: AppFontStyle.styleW600(AppColor.colorBlack, 20),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    //   radius: 15,
    //   backgroundColor: AppColor.colorWhite,
    //   barrierDismissible: false,
    //   title: "",
    // );
  }
}
