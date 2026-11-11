import 'dart:convert';

import 'package:in_app_review/in_app_review.dart';
import 'package:story_box/growth/growth_config.dart';
import 'package:story_box/utils/guest_gate.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

/// Rate the app: on the days set by the admin (default 1, 3, 7 and 14 days after sign-up),
/// shows Google Play's own in-app review window at a natural break (when the user leaves the player).
/// The user rates there and Google posts the review. Google decides whether the window appears
/// and never tells the app whether the user rated, so each day is tried once and then the schedule ends.
class RatingPrompt {
  static bool _askedThisSession = false;

  static String _shownKey(String uid) => 'rate_shown_$uid';
  static String _firstSeenKey(String uid) => 'rate_first_seen_$uid';

  static DateTime _signedUpAt(String uid) {
    final p = Preference.shared;
    try {
      final data = p.getString(Preference.userData);
      if (data != null) {
        final created = DateTime.tryParse('${jsonDecode(data)['createdAt']}');
        if (created != null) return created.toLocal();
      }
    } catch (_) {}
    final seen = DateTime.tryParse(p.getString(_firstSeenKey(uid)) ?? '');
    if (seen != null) return seen;
    final now = DateTime.now();
    p.setString(_firstSeenKey(uid), now.toIso8601String());
    return now;
  }

  static Future<void> maybeAsk() async {
    try {
      if (!GrowthConfig.ratingEnabled || GrowthConfig.ratingDays.isEmpty || _askedThisSession) return;
      final uid = Preference.userId;
      if (uid.isEmpty || GuestGate.isGuest) return;
      final days = DateTime.now().difference(_signedUpAt(uid)).inMinutes / (24 * 60);
      final p = Preference.shared;
      final shown = (p.getStringList(_shownKey(uid)) ?? const <String>[]).toSet();
      int? due;
      for (final d in GrowthConfig.ratingDays) {
        if (days >= d && !shown.contains('$d')) due = d;
      }
      if (due == null) return;
      _askedThisSession = true;
      // Every step up to today counts as done: someone back after 3 weeks sees one window, not four.
      for (final d in GrowthConfig.ratingDays) {
        if (d <= due) shown.add('$d');
      }
      await p.setStringList(_shownKey(uid), shown.toList());
      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
        Utils.showLog('Rating window requested (day $due)');
      }
    } catch (e) {
      Utils.showLog('Rating prompt failed => $e');
    }
  }
}
