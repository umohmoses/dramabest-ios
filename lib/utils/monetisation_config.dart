import 'package:story_box/utils/preference.dart';

/// Global monetisation settings sent by the server in
/// `retrieveSettingsForUser` -> `monetisation` (additive field).
/// Older servers do not send it: the defaults keep the previous behaviour
/// (VIP unlocks everything) plus one interstitial after every 2 episodes.
class MonetisationConfig {
  static int interstitialEveryEpisodes = 2; // 0 = interstitials off
  static bool vipAccess = true; // VIP users watch locked episodes without coins
  static int adsPerEpisode = 1; // rewarded ads needed for one unlock (server: rewardedAdsRequired)
  static int episodesPerReward = 2; // premium episodes unlocked by one completed reward
  static int dailyRewardedAdLimit = 6;
  static int freePercent = 70;
  static int coinsPerAd = 0; // bonus coins for every rewarded ad (credited by the server)

  static void fromJson(dynamic json) {
    if (json is! Map) return;
    final every = json['interstitialEveryEpisodes'];
    if (every is num && every >= 0) interstitialEveryEpisodes = every.toInt();
    final vip = json['vipAccess'];
    if (vip is bool) vipAccess = vip;
    final ads = json['rewardedAdsRequired'] ?? json['adsPerEpisode'];
    if (ads is num && ads >= 1) adsPerEpisode = ads.toInt();
    final per = json['episodesPerReward'];
    if (per is num && per >= 1) episodesPerReward = per.toInt();
    final daily = json['dailyRewardedAdLimit'];
    if (daily is num && daily >= 0) dailyRewardedAdLimit = daily.toInt();
    final fp = json['freePercent'];
    if (fp is num && fp >= 0 && fp <= 100) freePercent = fp.toInt();
    final bonus = json['coinsPerAd'];
    if (bonus is num && bonus >= 0) coinsPerAd = bonus.toInt();
  }

  /// True when the current user's VIP plan unlocks locked episodes.
  static bool get vipUnlocks => Preference.isVip && vipAccess;
}
