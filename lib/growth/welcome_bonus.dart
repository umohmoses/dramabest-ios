import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/growth/growth_config.dart';
import 'package:story_box/ui/referral_page/referral_view.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/guest_gate.dart';

/// After a new account is created with a sign-up bonus: one welcome message on the home screen
/// ("you earned N coins, invite friends to earn more and swap coins for VIP").
class WelcomeBonus {
  static int _pendingCoins = 0;

  /// Called by the login API when the server reports a brand-new (registered) account.
  static void signedUp(int coins) {
    if (coins > 0) _pendingCoins = coins;
  }

  /// Called when the home screen opens; shows the message once.
  static void showIfPending() {
    final coins = _pendingCoins;
    if (coins <= 0) return;
    _pendingCoins = 0;
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (Get.isDialogOpen ?? false) return;
      final invite = GrowthConfig.referralEnabled;
      final vip = GrowthConfig.vipCoinPrice > 0;
      Get.dialog(
        Dialog(
          backgroundColor: const Color(0xff1c1816),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('🎁', style: TextStyle(fontSize: 46)),
              const SizedBox(height: 8),
              Text('You earned $coins coins!', textAlign: TextAlign.center, style: AppFontStyle.styleW800(AppColor.colorWhite, 22)),
              const SizedBox(height: 10),
              Text(
                [
                  'Welcome to Dramabest. Your sign-up bonus is in your wallet.',
                  if (invite) 'Invite friends with the Share button and earn ${GrowthConfig.referrerCoins} coins for each friend who joins.',
                  if (vip) 'Collect ${GrowthConfig.vipCoinPrice} coins and swap them for VIP: every episode unlocked, no ads.',
                ].join('\n\n'),
                textAlign: TextAlign.center,
                style: AppFontStyle.styleW500(Colors.white70, 14),
              ),
              const SizedBox(height: 20),
              if (invite)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    icon: const Icon(Icons.share_rounded),
                    label: Text('Invite friends', style: AppFontStyle.styleW700(AppColor.colorWhite, 15)),
                    onPressed: () {
                      Get.back();
                      if (GuestGate.allow()) Get.to(() => const ReferralView());
                    },
                  ),
                ),
              TextButton(onPressed: () => Get.back(), child: Text(invite ? 'Later' : 'Start watching', style: AppFontStyle.styleW600(Colors.white70, 14))),
            ]),
          ),
        ),
      );
    });
  }
}
