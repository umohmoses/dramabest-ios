import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/deep_link/services/deep_link_services.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/session_token.dart';
import 'package:story_box/utils/utils.dart';

/// Keeps the server's copy of this phone's push token current, and opens dramas from push taps.
class PushToken {
  static String _lastSent = '';
  static bool _listening = false;

  /// Call on every start (once signed in) and it also follows Firebase token rotation.
  static Future<void> sync() async {
    try {
      if (!_listening) {
        _listening = true;
        FirebaseMessaging.instance.onTokenRefresh.listen((t) => _report(t));
      }
      final t = await FirebaseMessaging.instance.getToken();
      if (t != null) await _report(t);
    } catch (e) {
      Utils.showLog('Push token sync failed => $e');
    }
  }

  static Future<void> _report(String token) async {
    final uid = Preference.userId;
    if (uid.isEmpty || token.isEmpty || token == _lastSent) return;
    try {
      final headers = {'key': ApiConstant.SECRET_KEY, 'Content-Type': 'application/json', ...await SessionToken.headers()};
      final res = await http
          .post(Uri.parse('${ApiConstant.getBaseURL()}api/client/user/updateFcmToken'), headers: headers, body: jsonEncode({'userId': uid, 'fcmToken': token}))
          .timeout(const Duration(seconds: 15));
      final body = jsonDecode(res.body);
      if (body is Map && body['status'] == true) _lastSent = token;
    } catch (e) {
      Utils.showLog('Push token report failed => $e');
    }
  }

  /// Push tap with {type: SERIES, movieSeriesId, playIndex, totalVideos}: open that drama (at that episode).
  static bool openSeries(Map<String, dynamic> data) {
    if ('${data['type']}' != 'SERIES') return false;
    final id = '${data['movieSeriesId'] ?? ''}';
    if (id.isEmpty) return false;
    final index = int.tryParse('${data['playIndex'] ?? 0}') ?? 0;
    final total = int.tryParse('${data['totalVideos'] ?? 0}') ?? 0;
    DeepLinkServices.isNavigationComplete = false;
    DeepLinkServices.eventId = id;
    DeepLinkServices.eventType = DeepLinkServices.episodeKey;
    DeepLinkServices.episodeNumber = index;
    DeepLinkServices.totalVideos = total;
    // App already open on the home screen: go now. Cold start: the home screen does it when it opens.
    if (Get.currentRoute == AppRoutes.bottomBarPage || Get.currentRoute == AppRoutes.episodeWiseReels) {
      DeepLinkServices.onChangeRoutes(isBottomBarRoutes: false);
    }
    return true;
  }
}
