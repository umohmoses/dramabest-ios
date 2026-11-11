import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:story_box/ads/ads_bootstrap.dart';
import 'package:story_box/ads/google_ad_helper.dart';
import 'package:story_box/utils/monetisation_config.dart';
import 'package:story_box/utils/preference.dart';

/// Interstitial ad shown after every N completed episodes
/// (N = MonetisationConfig.interstitialEveryEpisodes, set by the admin).
/// VIP users never see interstitials. If no ad is ready, playback continues.
class GoogleInterstitialAd {
  static InterstitialAd? _ad;
  static bool _loading = false;
  static int _completedSinceAd = 0;

  static bool get _enabled {
    // Same rule as the existing rewarded ads: shown when an ad unit id is configured in admin settings.
    final id = GoogleAdHelper.interstitialAd;
    return !Preference.isVip && MonetisationConfig.interstitialEveryEpisodes > 0 && id.isNotEmpty && !id.endsWith('_interstitial_id') && !id.contains('Not Support');
  }

  static void preload() {
    if (!_enabled || _ad != null || _loading || !GoogleAdHelper.isValid(GoogleAdHelper.interstitialAd)) return;
    _loading = true;
    AdsBootstrap.ready.then((canRequest) {
      if (!canRequest) {
        _loading = false;
        return;
      }
      InterstitialAd.load(
        adUnitId: GoogleAdHelper.interstitialAd,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _loading = false;
            _ad = ad;
          },
          onAdFailedToLoad: (error) {
            _loading = false;
            _ad = null;
            debugPrint('Interstitial Ad failed to load => $error');
          },
        ),
      );
    });
  }

  /// Call when an episode finishes. Runs [then] (e.g. go to next episode)
  /// right away, or after the ad is closed when an ad is due.
  /// Only VIP removes ads: episodes unlocked with coins (bought or earned) still get interstitials.
  static void onEpisodeCompleted(VoidCallback then) {
    if (!_enabled) {
      then();
      return;
    }
    _completedSinceAd++;
    final due = _completedSinceAd >= MonetisationConfig.interstitialEveryEpisodes;
    final ad = _ad;
    if (!due || ad == null) {
      if (due) preload(); // not ready yet: try again after the next episode
      then();
      if (!due) preload();
      return;
    }
    _ad = null;
    _completedSinceAd = 0;
    var done = false;
    void finish() {
      if (done) return;
      done = true;
      then();
      preload();
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        finish();
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        a.dispose();
        finish();
      },
    );
    ad.show();
  }
}
