import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:story_box/ui/setting_view_page/api/setting_api.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/splash_screen/controller/splash_controller.dart';
import 'package:story_box/utils/utils.dart';

/// Google Play in-app updates: the new version is downloaded and installed from inside the app
/// (no trip to the Play Store app). Settings come from the admin (retrieveSettingsForUser -> appUpdate):
///  - "flexible" (default): Play asks once in a small sheet, the update downloads while the user keeps
///    watching, then it is installed and the app restarts at a natural break (not during a video)
///  - "immediate": Play's full-screen update screen; the app cannot be used until it is updated
///  - forceBelow: versions older than this build number always get the immediate update
/// Works only for installs from Google Play (sideloaded APKs are skipped silently).
class AppUpdater {
  static String mode = 'flexible';
  static int forceBelow = 0;
  static bool enabled = true;
  static bool _checked = false;
  static Timer? _waiter;

  static void fromJson(dynamic json) {
    if (json is! Map) return;
    if (json['enabled'] is bool) enabled = json['enabled'];
    if (json['mode'] is String) mode = json['mode'];
    if (json['forceBelow'] is num) forceBelow = (json['forceBelow'] as num).toInt();
  }

  /// Once per app session (called when the home screen opens).
  static AppLifecycleListener? _lifecycle;

  static Future<void> check() async {
    // Coming back from the background (e.g. after days in memory) checks again.
    _lifecycle ??= AppLifecycleListener(onResume: () {
      if (_running) return; // returning from Play's own update screen
      _checked = false;
      check();
    });
    if (_blocking || _running) return;
    _running = true;
    try {
      await _check();
    } finally {
      _running = false;
    }
  }

  static bool _running = false;

  static Future<void> _check() async {
    if (await _belowRequiredVersion()) {
      _blockUntilUpdated();
      return;
    }
    if (_checked || !enabled || !Platform.isAndroid) return;
    _checked = true;
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.developerTriggeredUpdateInProgress) {
        await InAppUpdate.performImmediateUpdate(); // an immediate update was interrupted: resume it
        return;
      }
      if (info.installStatus == InstallStatus.downloaded) {
        _installWhenIdle(); // downloaded in an earlier session
        return;
      }
      if (info.updateAvailability != UpdateAvailability.updateAvailable) return;
      final current = int.tryParse((await PackageInfo.fromPlatform()).buildNumber) ?? 0;
      final mustUpdate = mode == 'immediate' || (forceBelow > 0 && current < forceBelow) || info.updatePriority >= 4;
      if (mustUpdate) {
        // Required: Play's full-screen update; if the viewer backs out (or Play can't run it),
        // the app stays blocked behind the update screen instead of carrying on.
        AppUpdateResult r = AppUpdateResult.inAppUpdateFailed;
        try {
          if (info.immediateUpdateAllowed) r = await InAppUpdate.performImmediateUpdate();
        } catch (e) {
          Utils.showLog('Immediate update not completed => $e'); // some versions throw when the viewer cancels
        }
        if (r != AppUpdateResult.success) _blockUntilUpdated();
      } else if (info.flexibleUpdateAllowed) {
        StreamSubscription<InstallStatus>? sub;
        sub = InAppUpdate.installUpdateListener.listen((s) {
          if (s == InstallStatus.downloaded) {
            sub?.cancel();
            _installWhenIdle();
          }
        });
        final r = await InAppUpdate.startFlexibleUpdate();
        if (r != AppUpdateResult.success) sub.cancel();
      }
    } catch (e) {
      Utils.showLog('In-app update skipped => $e'); // not installed from Play, or Play unavailable
    }
  }

  static bool _blocking = false;

  /// Admin "Android/iOS app version": anything older must update (re-read from the server).
  static Future<bool> _belowRequiredVersion() async {
    try {
      await SettingApi.callApi();
      final required = (Platform.isIOS ? SettingApi.setting?.iosAppVersion : SettingApi.setting?.androidAppVersion) ?? '';
      if (required.trim().isEmpty) return false;
      List<int> parts(String v) => v.trim().split('.').map((x) => int.tryParse(x.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0).toList();
      final cur = parts((await PackageInfo.fromPlatform()).version);
      final req = parts(required);
      for (int i = 0; i < req.length; i++) {
        final c = i < cur.length ? cur[i] : 0;
        if (c != req[i]) return c < req[i];
      }
    } catch (e) {
      Utils.showLog('Version check skipped => $e');
    }
    return false;
  }

  /// The same update screen the splash shows for outdated versions: cannot be closed, opens Play.
  static void _blockUntilUpdated() {
    if (_blocking) return;
    _blocking = true;
    Get.dialog(const ForceUpdateDialog(), barrierDismissible: false);
  }

  /// Installs (the app restarts) as soon as the user is not watching a video.
  static void _installWhenIdle() {
    _waiter?.cancel();
    void tryNow() {
      if (Get.currentRoute == AppRoutes.episodeWiseReels) return;
      _waiter?.cancel();
      InAppUpdate.completeFlexibleUpdate().catchError((e) => Utils.showLog('Update install failed => $e'));
    }

    tryNow();
    _waiter = Timer.periodic(const Duration(seconds: 15), (_) => tryNow());
  }
}
