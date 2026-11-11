import 'package:story_box/utils/app_updater.dart';

/// Invite-a-friend and rate-the-app settings from the admin "Invites & Rating" page,
/// sent with `retrieveSettingsForUser` -> `growth` (older servers do not send it: defaults apply).
class GrowthConfig {
  static bool referralEnabled = true;
  static int referrerCoins = 40;
  static int newUserCoins = 20;
  static int qualifyEpisodes = 1;

  /// Fewest coins that redeem a VIP plan (admin "VIP with coins"); 0 = coins cannot buy VIP.
  static int vipCoinPrice = 0;

  static bool ratingEnabled = true;
  static List<int> ratingDays = const [1, 3, 7, 14];

  /// "Share episode video" offered in the share menu (admin switch; off on servers that do not send it).
  static bool clipsEnabled = false;

  static void fromJson(dynamic json) {
    if (json is! Map) return;
    final r = json['referral'];
    if (r is Map) {
      if (r['enabled'] is bool) referralEnabled = r['enabled'];
      if (r['referrerCoins'] is num) referrerCoins = (r['referrerCoins'] as num).toInt();
      if (r['newUserCoins'] is num) newUserCoins = (r['newUserCoins'] as num).toInt();
      if (r['qualifyEpisodes'] is num) qualifyEpisodes = (r['qualifyEpisodes'] as num).toInt();
    }
    final v = json['vipCoins'];
    vipCoinPrice = (v is Map && v['minCoins'] is num) ? (v['minCoins'] as num).toInt() : 0;
    final t = json['rating'];
    if (t is Map) {
      if (t['enabled'] is bool) ratingEnabled = t['enabled'];
      final d = t['days'];
      if (d is List) {
        final days = d.whereType<num>().map((e) => e.toInt()).where((e) => e > 0).toSet().toList()..sort();
        ratingDays = days;
      }
    }
    final s = json['share'];
    if (s is Map && s['clipsEnabled'] is bool) clipsEnabled = s['clipsEnabled'];
    AppUpdater.fromJson(json['appUpdate']); // Google Play in-app update settings
  }
}
