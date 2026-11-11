import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Asks for ad consent where the law requires it (Google UMP), then starts the Mobile Ads SDK.
/// Ads wait for [ready]. If ads were blocked (consent lookup failed, timed out, or the SDK did
/// not start), the next [ready] call tries again instead of keeping ads off for the whole session.
class AdsBootstrap {
  static Completer<bool>? _run;
  static bool _sdkStarted = false;
  static DateTime? _lastAttempt;

  /// Why ads were last blocked (shown in the "ad not ready" message), or null if they are allowed.
  static String? lastBlockReason;

  static Future<bool> get ready {
    final run = _run;
    if (run == null) return _start();
    if (!run.isCompleted) return run.future;
    // Last attempt blocked ads: retry, at most every 20 seconds.
    if (lastBlockReason != null &&
        (_lastAttempt == null || DateTime.now().difference(_lastAttempt!) > const Duration(seconds: 20))) {
      return _start();
    }
    return run.future;
  }

  static void start() => ready;

  static Future<bool> _start() {
    final run = Completer<bool>();
    _run = run;
    _lastAttempt = DateTime.now();
    if (kDebugMode) {
      MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: ["27725C0BA50B789AA8A8833105F99920"]),
      );
    }
    String? consentError;
    // A slow consent lookup must never hold the app back for long.
    Timer(const Duration(seconds: 15), () => _finish(run, consentError ?? 'consent lookup timed out'));
    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () => ConsentForm.loadAndShowConsentFormIfRequired((error) {
          if (error != null) {
            consentError = 'consent form: ${error.message}';
            debugPrint('Ad consent form => ${error.message}');
          }
          _finish(run, consentError);
        }),
        (error) {
          consentError = 'consent lookup: ${error.message}';
          debugPrint('Ad consent update => ${error.message}');
          _finish(run, consentError);
        },
      );
    } catch (e) {
      _finish(run, 'consent failed: $e');
    }
    return run.future;
  }

  static Future<void> _finish(Completer<bool> run, String? consentError) async {
    if (run.isCompleted) return;
    var canRequest = false;
    String? reason;
    try {
      final status = await ConsentInformation.instance.getConsentStatus();
      canRequest = await ConsentInformation.instance.canRequestAds();
      if (!canRequest) reason = 'consent status ${status.name}${consentError != null ? ' ($consentError)' : ''}';
      if (canRequest && !_sdkStarted) {
        await MobileAds.instance.initialize();
        _sdkStarted = true;
      }
    } catch (e) {
      debugPrint('Ads start failed => $e');
      reason = 'ads SDK did not start: $e';
      canRequest = false;
    }
    lastBlockReason = canRequest ? null : reason;
    if (!run.isCompleted) run.complete(canRequest);
  }
}
