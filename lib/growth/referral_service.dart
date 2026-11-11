import 'dart:convert';
import 'dart:io';

import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/deep_link/share_manager/drama_share.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/guest_gate.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/session_token.dart';
import 'package:story_box/utils/utils.dart';

/// Invite a friend.
/// The sharer's link is the Play Store page with `referrer=ref=<code>`. On the friend's first launch,
/// Google Play hands that value to the app; it is kept until the friend signs in, then sent to the server,
/// which decides whether coins are paid (new account, one per phone, episodes watched ...).
class ReferralService {
  static const _pendingKey = 'invite_pending_code';
  static const _sourceKey = 'invite_pending_source';
  static const _checkedKey = 'invite_referrer_checked';
  static const _doneKey = 'invite_done';

  /// The server refused for good: no point in retrying.
  static const _final = {'OWN_CODE', 'ALREADY_USED', 'DEVICE_USED', 'SAME_DEVICE', 'TOO_LATE', 'INVALID_CODE', 'REFERRAL_OFF', 'BLOCKED', 'NOT_FOUND'};
  static bool _claiming = false;

  static String _base() => '${ApiConstant.getBaseURL()}api/client/referral';

  /// Reads the Play Store install referrer once (Android only).
  static Future<void> captureInstallReferrer() async {
    if (!Platform.isAndroid) return;
    final p = Preference.shared;
    if (p.getString(_checkedKey) == '1') return;
    try {
      final details = await AndroidPlayInstallReferrer.installReferrer;
      await p.setString(_checkedKey, '1');
      final code = parseCode(details.installReferrer);
      Utils.showLog('Install referrer => ${details.installReferrer} (code: $code)');
      if (code != null) await remember(code, 'install_referrer');
      final shared = parseShareCode(details.installReferrer);
      if (shared != null) DramaShare.openFromCode(shared); // installed from a shared movie: open that episode

    } catch (e) {
      Utils.showLog('Install referrer unavailable => $e'); // not installed from Play, or Play busy: try next start
    }
  }

  /// "ref=AB12CD" (also inside utm-style strings) -> "AB12CD".
  static String? parseCode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final q = Uri.splitQueryString(Uri.decodeComponent(raw));
      final code = (q['ref'] ?? q['referralCode'] ?? '').trim();
      return code.isEmpty || code.length > 64 ? null : code;
    } catch (_) {
      return null;
    }
  }

  /// "s=AB12CD" from a dramabest.com/r/ link -> "AB12CD" (the shared movie + episode).
  static String? parseShareCode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final s = (Uri.splitQueryString(Uri.decodeComponent(raw))['s'] ?? '').trim();
      return RegExp(r'^[A-Za-z0-9]{4,12}$').hasMatch(s) ? s : null;
    } catch (_) {
      return null;
    }
  }

  /// Keeps an invite code (from the install referrer or a shared link) until it can be used.
  static Future<void> remember(String code, String source) async {
    final p = Preference.shared;
    if (p.getString(_doneKey) == '1' || (p.getString(_pendingKey) ?? '').isNotEmpty) return;
    await p.setString(_pendingKey, code.trim());
    await p.setString(_sourceKey, source);
    tryClaimPending();
  }

  /// Sends a kept invite code once the user has a real (non-guest) account. Safe to call often.
  static Future<void> tryClaimPending() async {
    final p = Preference.shared;
    final code = p.getString(_pendingKey) ?? '';
    if (code.isEmpty || _claiming || Preference.userId.isEmpty || GuestGate.isGuest) return;
    _claiming = true;
    try {
      final r = await claim(code, source: p.getString(_sourceKey) ?? 'link');
      if (r.ok || _final.contains(r.code)) {
        await p.setString(_pendingKey, '');
        await p.setString(_doneKey, '1');
      }
      final context = Get.context;
      if (r.ok && context != null) Utils.showToast(context, r.message);
    } finally {
      _claiming = false;
    }
  }

  static Future<({bool ok, String code, String message})> claim(String code, {String source = 'manual'}) async {
    try {
      final headers = {'key': ApiConstant.SECRET_KEY, 'Content-Type': 'application/json', ...await SessionToken.headers()};
      final res = await http
          .post(Uri.parse('${_base()}/claim'), headers: headers, body: jsonEncode({'userId': Preference.userId, 'code': code, 'deviceId': Preference.identity, 'source': source}))
          .timeout(const Duration(seconds: 15));
      final body = jsonDecode(res.body);
      if (body is Map && body['status'] == true) {
        final data = body['data'];
        return (ok: true, code: '', message: '${data is Map ? data['message'] ?? 'Invite accepted.' : 'Invite accepted.'}');
      }
      return (ok: false, code: '${body is Map ? body['code'] ?? '' : ''}', message: '${body is Map ? body['message'] ?? 'Could not use this invite.' : 'Could not use this invite.'}');
    } catch (e) {
      return (ok: false, code: 'NETWORK', message: 'No connection. Please try again.');
    }
  }

  /// My invite link, share text and stats.
  static Future<Map<String, dynamic>?> summary() async {
    try {
      final res = await http
          .get(Uri.parse('${_base()}/summary?userId=${Uri.encodeQueryComponent(Preference.userId)}'), headers: {'key': ApiConstant.SECRET_KEY})
          .timeout(const Duration(seconds: 15));
      final body = jsonDecode(res.body);
      if (body is Map && body['status'] == true && body['data'] is Map) return Map<String, dynamic>.from(body['data']);
    } catch (e) {
      Utils.showLog('Invite summary failed => $e');
    }
    return null;
  }
}
