import 'dart:io';

import 'package:story_box/ui/setting_view_page/api/setting_api.dart';

/// Ad unit IDs always come from the latest settings sent by the admin dashboard.
class GoogleAdHelper {
  static String get rewardedAd {
    final setting = SettingApi.setting;
    if (setting == null) return "";
    return Platform.isAndroid
        ? setting.android.google.reward
        : Platform.isIOS
            ? setting.ios.google.reward
            : "";
  }

  static String get interstitialAd {
    final setting = SettingApi.setting;
    if (setting == null) return "";
    return Platform.isAndroid
        ? setting.android.google.interstitial
        : Platform.isIOS
            ? setting.ios.google.interstitial
            : "";
  }

  static bool isValid(String id) => id.startsWith('ca-app-pub-');
}
