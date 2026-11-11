import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/profile_page/api/profile_api.dart';
import 'package:story_box/ui/refill/model/vip_plan.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/guest_gate.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

/// VIP with coins (e.g. coins earned by inviting friends). The admin sets the coin price per plan;
/// the server checks the balance, deducts the coins and activates VIP.
class VipCoins {
  static bool _busy = false;

  static Future<void> redeem(VipPlan plan, {VoidCallback? onDone}) async {
    if (_busy || plan.coinPrice <= 0) return;
    if (!GuestGate.allow()) return; // registered accounts only
    final have = Preference.userCoin.value;
    final ctx = Get.context;
    if (ctx == null) return;
    if (have < plan.coinPrice) {
      Utils.showToast(ctx, 'You need ${plan.coinPrice} coins for this plan. You have $have. Invite friends to earn more!');
      return;
    }
    final ok = await Get.dialog<bool>(AlertDialog(
      title: const Text('Get VIP with coins'),
      content: Text('Use ${plan.coinPrice} of your $have coins for ${plan.validity ?? 1} ${plan.validityType ?? 'month'} of VIP?\n\nAll episodes unlocked. No ads.'),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
        TextButton(onPressed: () => Get.back(result: true), child: const Text('Use coins', style: TextStyle(fontWeight: FontWeight.w800))),
      ],
    ));
    if (ok != true) return;
    _busy = true;
    try {
      final r = await http
          .post(Uri.parse('${ApiConstant.getBaseURL()}api/client/vipPlan/redeemWithCoins'),
              headers: {'key': ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'}, body: jsonEncode({'userId': Preference.userId, 'vipPlanId': plan.sId}))
          .timeout(const Duration(seconds: 30));
      final j = jsonDecode(r.body);
      final msg = (j is Map && j['message'] is String) ? j['message'] as String : 'Something went wrong. Please try again.';
      if (j is Map && j['status'] == true) {
        await Preference.onIsVip(true);
        if (j['coin'] is num) await Preference.onSetUserCoin((j['coin'] as num).toInt());
        final model = await ProfileApi.callApi(); // refreshes coins and VIP dates
        if (Get.isRegistered<HomeController>()) {
          final home = Get.find<HomeController>();
          if (model != null) home.loginUserModel = model;
          home.update(['userProfile']);
        }
        onDone?.call();
      }
      if (Get.context != null) Utils.showToast(Get.context!, msg);
    } catch (e) {
      Utils.showLog('VIP coin redeem failed => $e');
      if (Get.context != null) Utils.showToast(Get.context!, 'Check your connection and try again.');
    } finally {
      _busy = false;
    }
  }
}
