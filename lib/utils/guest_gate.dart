import 'dart:convert';

import 'package:get/get.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

/// Guests can browse and watch, but rewards, purchases and the profile need a real account:
/// payment gateways need a real email, and guests don't have one.
abstract class GuestGate {
  static const int _guestLoginType = 3;

  static bool get isGuest {
    final saved = Preference.shared.getInt(Preference.loginType);
    if (saved != null) return saved == _guestLoginType;
    try {
      final data = Preference.shared.getString(Preference.userData);
      if (data != null) return jsonDecode(data)['loginType'] == _guestLoginType;
    } catch (e) {
      Utils.showLog("Guest check failed :: $e");
    }
    return false;
  }

  /// True for a registered account. For a guest, opens sign-in and returns false.
  static bool allow() {
    if (!isGuest) return true;
    final context = Get.context;
    if (context != null) Utils.showToast(context, "Please sign in or create an account to continue.");
    if (Get.currentRoute != AppRoutes.login) Get.toNamed(AppRoutes.login);
    return false;
  }
}
