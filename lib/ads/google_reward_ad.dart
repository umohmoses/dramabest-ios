import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:story_box/ads/ads_bootstrap.dart';
import 'package:story_box/ads/google_ad_helper.dart';
import 'package:story_box/ui/setting_view_page/api/setting_api.dart';
import 'package:story_box/utils/utils.dart';

class GoogleRewardAd {
  static RewardedAd? _ad; // a loaded ad, ready to show
  static bool _loading = false;
  static int _failures = 0;
  static Timer? _retry;
  static Callback function = () {}; // runs only after a completed ad
  static bool _earned = false; // true only when the user completed the ad (reward earned)

  /// Loads in the background; failures retry quietly with growing waits (30s, 60s ... up to 5 minutes).
  static void loadAd() {
    if (_ad != null || _loading) return;
    _loading = true;
    _retry?.cancel();
    AdsBootstrap.ready.then((canRequest) {
      if (!canRequest) {
        _loading = false;
        return;
      }
      if (!GoogleAdHelper.isValid(GoogleAdHelper.rewardedAd)) {
        // Settings did not arrive at startup: fetch them again, then retry.
        if (SettingApi.setting == null) SettingApi.callApi();
        _loading = false;
        _scheduleRetry();
        return;
      }
      try {
        RewardedAd.load(
          adUnitId: GoogleAdHelper.rewardedAd,
          request: const AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) {
              _loading = false;
              _failures = 0;
              _ad = ad;
              _lastError = null;
            },
            onAdFailedToLoad: (LoadAdError error) {
              debugPrint('Rewarded Ad Loading Failed => $error');
              _lastError = error;
              _loading = false;
              _scheduleRetry();
            },
          ),
        );
      } catch (e) {
        Utils.showLog('ERROR :: $e');
        _loading = false;
        _scheduleRetry();
      }
    });
  }

  static void _scheduleRetry() {
    _failures++;
    final seconds = min(300, 30 * pow(2, min(_failures - 1, 4)).toInt());
    _retry?.cancel();
    _retry = Timer(Duration(seconds: seconds), loadAd);
  }

  static void _notReady() {
    final context = Get.context;
    final code = _lastError;
    final blocked = AdsBootstrap.lastBlockReason;
    final noUnit = !GoogleAdHelper.isValid(GoogleAdHelper.rewardedAd);
    final msg = blocked != null
        ? "Ads are blocked on this device: $blocked"
        : noUnit
            ? "Ads are not set up yet (no rewarded ad unit received from the server)."
            : code == null
        ? "The ad isn't ready yet. Please try again in a moment."
        : code.code == 3
            ? "No ad is available right now. Please try again later. (code 3)"
            : "The ad could not load. Please try again later. (code ${code.code}: ${code.message})";
    if (context != null) Utils.showToast(context, msg);
    _failures = 0;
    loadAd();
  }

  static LoadAdError? _lastError;

  /// Starts a fresh load and waits up to [timeout] for it, with a spinner on screen.
  static Future<RewardedAd?> _waitForAd({Duration timeout = const Duration(seconds: 12)}) async {
    _failures = 0;
    _retry?.cancel();
    loadAd();
    var dialog = false;
    if (Get.context != null && !(Get.isDialogOpen ?? false)) {
      dialog = true;
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    }
    final end = DateTime.now().add(timeout);
    while (_ad == null && DateTime.now().isBefore(end)) {
      await Future.delayed(const Duration(milliseconds: 300));
      // The load failed or ads are blocked: stop waiting.
      if (!_loading && _ad == null && (_lastError != null || AdsBootstrap.lastBlockReason != null)) break;
    }
    if (dialog && (Get.isDialogOpen ?? false)) Get.back();
    return _ad;
  }

  /// [ssvUserId]/[ssvCustomData]: sent by Google to our server-side verification callback.
  static Future<void> showAd({required Callback fun, String? ssvUserId, String? ssvCustomData}) async {
    var ad = _ad;
    if (ad == null) {
      _lastError = null;
      ad = await _waitForAd();
    }
    if (ad == null) {
      _notReady();
      return;
    }
    _ad = null; // an ad can only be shown once
    function = fun;
    _earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdFailedToShowFullScreenContent: (shown, error) {
        debugPrint("Rewarded Ad Show Failed => $error");
        shown.dispose();
        _notReady();
      },
      onAdDismissedFullScreenContent: (shown) {
        shown.dispose();
        loadAd();
        // Only a completed ad (reward earned) counts; closing early gives nothing.
        if (_earned) function.call();
        _earned = false;
      },
    );
    if (ssvUserId != null) {
      try {
        await ad.setServerSideOptions(ServerSideVerificationOptions(userId: ssvUserId, customData: ssvCustomData));
      } catch (e) {
        Utils.showLog('SSV options failed: $e');
      }
    }
    ad.show(onUserEarnedReward: (shownAd, reward) {
      _earned = true;
    });
  }
}
