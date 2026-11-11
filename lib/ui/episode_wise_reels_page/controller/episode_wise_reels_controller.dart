import 'package:story_box/utils/monetisation_config.dart';
import 'package:story_box/growth/rating_prompt.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:story_box/ads/google_reward_ad.dart';
import 'package:story_box/ui/episode_wise_reels_page/api/fetch_episode_wise_reels_api.dart';
import 'package:story_box/ui/episode_wise_reels_page/api/unlock_episodes_auto_api.dart';
import 'package:story_box/ui/episode_wise_reels_page/api/watch_ad_unlock_video_api.dart';
import 'package:story_box/ui/episode_wise_reels_page/api/watch_short_video_api.dart';
import 'package:story_box/ui/episode_wise_reels_page/model/fetch_episode_wise_reels_model.dart';
import 'package:story_box/ui/episode_wise_reels_page/widget/episode_wise_reels_widget.dart';
import 'package:story_box/ui/my_wallet/api/episode_auto_unlock_api.dart';
import 'package:story_box/ui/profile_page/controller/profile_controller.dart';
import 'package:story_box/ui/reels_page/api/create_favorite_video_api.dart';
import 'package:story_box/ui/reels_page/api/video_view_api.dart';
import 'package:story_box/ui/reels_page/controller/reels_controller.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/custom_progress_dialog.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';
import 'package:vibration/vibration.dart';

class EpisodeWiseReelsController extends GetxController {
  @override
  void onClose() {
    RatingPrompt.maybeAsk(); // rate-the-app: natural break when the user leaves the player
    super.onClose();
  }

  PreloadPageController preloadPageController = PreloadPageController();

  final profileController = Get.find<ProfileController>();

  // ── State ──────────────────────────────────────────────────────────────────
  int currentPageIndex = 0;
  String? movieSeriesId;
  int? totalVideos;
  bool isNavigateOnHome = false;

  bool isLoadingReels = false;
  bool isPaginationLoading = false;
  bool isVideoCompleted = false;

  // Cache local overrides to prevent backend stale data or controller re-initialization from reverting the user's explicit toggle
  static final Map<String, bool> localAutoUnlockOverrides = {};

  // Auto-unlock toggle — per web-series from API response
  bool get isAutoUnlock {
    final override = localAutoUnlockOverrides[movieSeriesId ?? ''];
    if (override != null) {
      return override;
    }
    return fetchEpisodeWiseReelsModel?.isAutoUnlockEnabled ?? false;
  }

  List<Videos> mainReels = [];
  FetchEpisodeWiseReelsModel? fetchEpisodeWiseReelsModel;

  int episodeUnlockAdsCount = 0;

  RxBool isFavorite = false.obs;
  RxInt favoriteCount = 0.obs;

  // Mutex: prevents overlapping unlock/page-change operations
  bool isPageChanging = false;

  // ── Init ───────────────────────────────────────────────────────────────────
  Future<void> init() async {
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    if (args.isNotEmpty) {
      movieSeriesId = args['movieSeriesId']?.toString() ?? movieSeriesId;
      totalVideos = args['totalVideos'] as int? ?? totalVideos;
      isNavigateOnHome = (args['isNavigateOnHome'] as bool?) ?? isNavigateOnHome;
    }

    currentPageIndex = 0;
    mainReels.clear();
    isLoadingReels = true;
    update(['reels']);

    FetchEpisodeWiseReelsApi.startPagination = 0;

    try {
      final autoUnlockHistory = await EpisodeAutoUnlockApi().callApi(
        userId: Preference.userId,
        start: '1',
        limit: '100',
      );
      bool isAutoUnlockedFromApi = false;
      for (var item in autoUnlockHistory) {
        if (item.movieSeriesId == movieSeriesId) {
          isAutoUnlockedFromApi = true;
          break;
        }
      }
      localAutoUnlockOverrides[movieSeriesId ?? ''] = isAutoUnlockedFromApi;
    } catch (e) {
      log('Error fetching auto unlock history: $e');
    }

    await fetchReels();

    // The page view opens at the chosen episode (playIndex), not at 0.
    // currentPageIndex must match it, or that episode is never treated as the
    // current one: it would not auto-play (or show its unlock sheet) until tapped.
    if (mainReels.isNotEmpty) {
      final start = preloadPageController.initialPage;
      currentPageIndex = start.clamp(0, mainReels.length - 1);
      update(['pageIndex']);
    }

    // Show episode list if deep-linked
    if (isNavigateOnHome) {
      WidgetsBinding.instance.addPostFrameCallback((e) {
        Get.bottomSheet(const ShowAllEpisodeBottomSheet());
      });
    }

    GoogleRewardAd.loadAd();
  }

  Future<void> fetchReels() async {
    fetchEpisodeWiseReelsModel = await FetchEpisodeWiseReelsApi.callApi(
      loginUserId: Preference.userId,
      videoId: '',
      movieSeriesId: movieSeriesId ?? '',
    );

    final videos = fetchEpisodeWiseReelsModel?.data?.videos ?? [];
    if (videos.isNotEmpty) {
      mainReels.addAll(videos);
      totalVideos = fetchEpisodeWiseReelsModel?.totalVideosCount ?? totalVideos;
      episodeUnlockAdsCount = fetchEpisodeWiseReelsModel?.userInfo?.episodeUnlockAds ?? 0;
      isFavorite.value = fetchEpisodeWiseReelsModel?.data?.isAddedList ?? false;
      favoriteCount.value = fetchEpisodeWiseReelsModel?.data?.totalAddedToList ?? 0;
    }

    isLoadingReels = false;
    update(['reels', 'favCount']);
  }

  // ── Page change — the core gate ────────────────────────────────────────────
  // Called ONLY from onPageChanged in the view, never from build()
  Future<void> onChangePage(int index) async {
    // Always record the new page, even while an unlock is in progress: dropping it
    // left the visible episode "not current", so it did not auto-play.
    if (index < 0 || index >= mainReels.length) return; // guard
    currentPageIndex = index;
    update(['pageIndex']); // lightweight — only updates current index display
  }

  // ── Scroll Settled — the core gate for locked videos ───────────────────────
  bool _isBottomSheetOpen = false;

  Future<void> onScrollSettled(int index) async {
    if (index < 0 || index >= mainReels.length) return;

    final video = mainReels[index];
    if (video.isLocked != true) return;

    // VIP — silently unlock, no bottom sheet (when the admin's VIP access is on)
    if (MonetisationConfig.vipUnlocks) {
      await silentUnlock(index);
      return;
    }

    // Auto-unlock is ON and there are enough coins — silently unlock
    if (isAutoUnlock && (video.coin ?? 0) <= Preference.userCoin.value) {
      await silentUnlock(index);
      return;
    }

    // Show block screen to ask for coins/ads
    if (!_isBottomSheetOpen && (Get.isBottomSheetOpen != true)) {
      _isBottomSheetOpen = true;
      await Get.bottomSheet(
        PremiumBottomSheet(
          shortVideoId: video.id,
          coin: video.coin ?? 0,
          videoId: video.id,
          episodeUnlockCount: fetchEpisodeWiseReelsModel?.userInfo?.episodeUnlockAds ?? 0,
          maxCount: fetchEpisodeWiseReelsModel?.data?.movieSeriesMaxAdsForFreeView ?? 0,
          callback: () {
            if (!MonetisationConfig.vipUnlocks) {
              unlockWithCoins(
                index: index,
                onSuccess: () {
                  Get.back();
                },
                onInsufficientCoins: () {
                  Get.back();
                  Get.bottomSheet(
                    UnlockNowBottomSheet(
                      coin: video.coin ?? 0,
                    ),
                  );
                },
              );
            }
          },
          adCallback: () async {
            await unlockWithAd(videoId: video.id, index: index);
          },
        ),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: AppColor.transparent,
      ).whenComplete(() {
        _isBottomSheetOpen = false;
      });
    }
  }

  // Silent unlock: deduct coins, mark unlocked, pre-unlock next
  Future<void> silentUnlock(int index) async {
    isPageChanging = true;
    try {
      final video = mainReels[index];
      if (video.isLocked != true) return; // already unlocked, skip

      await autoDeductWatchVideoApi(videoId: video.id);
      video.isLocked = false;

      // Pre-unlock next episode if auto-unlock is on
      if (isAutoUnlock && !MonetisationConfig.vipUnlocks) {
        await preUnlockNext(index);
      }

      update(['pageIndex']);
    } finally {
      isPageChanging = false;
    }
  }

  // Pre-unlocks N+1 silently — called after current episode is unlocked
  Future<void> preUnlockNext(int currentIndex) async {
    final nextIndex = currentIndex + 1;
    if (nextIndex >= mainReels.length) return;

    final next = mainReels[nextIndex];
    if (next.isLocked != true) return; // already unlocked

    if ((next.coin ?? 0) <= (profileController.loginUserModel?.user?.coin ?? 0)) {
      await autoDeductWatchVideoApi(videoId: next.id);
      next.isLocked = false;
    } else {
      Utils.showToast(Get.context!, 'Not enough coins to unlock next episode');
    }
  }

  // ── Called from PremiumBottomSheet coin option ─────────────────────────────
  Future<void> unlockWithCoins({
    required int index,
    required VoidCallback onSuccess,
    required VoidCallback onInsufficientCoins,
  }) async {
    final video = mainReels[index];
    final cost = video.coin ?? 0;

    // ✅ Validate balance BEFORE making any API call
    if (Preference.userCoin.value < cost) {
      onInsufficientCoins();
      return;
    }

    await deductWatchVideoApi(videoId: video.id);

    // deductWatchVideoApi marks isLocked=false internally on API success
    if (video.isLocked == false) {
      if (isAutoUnlock) {
        await preUnlockNext(index);
      }
      onSuccess();
    } else {
      // API failed — don't show success UI
      onInsufficientCoins();
    }
  }

  // ── Called from PremiumBottomSheet ad option ───────────────────────────────
  Future<void> unlockWithAd({required String? videoId, int? index}) async {
    // nonce ties this ad to Google's server-side verification callback
    final nonce = '${DateTime.now().microsecondsSinceEpoch}${videoId ?? ''}'.hashCode.toUnsigned(32).toRadixString(16) + DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    await GoogleRewardAd.showAd(
        ssvUserId: Preference.userId,
        ssvCustomData: '${videoId ?? ''}:${movieSeriesId ?? ''}:$nonce',
        fun: () async {
      var r = await WatchAdUnlockVideoApi.callApi(
        loginUserId: Preference.userId,
        movieWebseriesId: movieSeriesId ?? '',
        shortVideoId: videoId ?? '',
        nonce: nonce,
      );
      // Server waits for Google's verification: poll briefly
      for (var i = 0; i < 8 && r != null && r.pending == true; i++) {
        await Future.delayed(const Duration(milliseconds: 1500));
        r = await WatchAdUnlockVideoApi.callApi(
          loginUserId: Preference.userId,
          movieWebseriesId: movieSeriesId ?? '',
          shortVideoId: videoId ?? '',
          nonce: nonce,
          closeSheet: false,
        );
      }
      if (r != null && r.pending == true) {
        Utils.showToast(Get.context!, "Your ad is being verified. The episode will unlock shortly.");
        return;
      }
      if (r == null || r.status != true) {
        // limit reached, ad not finished, or network error: stay locked
        if (r?.message != null) Utils.showToast(Get.context!, r!.message!);
        return;
      }
      episodeUnlockAdsCount++;
      final bonus = r.coinsEarned ?? 0;
      if (bonus > 0) await Preference.onSetUserCoin(Preference.userCoin.value + bonus);
      // Older servers do not send `unlocked`: one ad unlocked the episode
      final isUnlocked = r.unlocked ?? true;
      if (isUnlocked) {
        mainReels[index ?? 0].isLocked = false;
        // one reward can unlock several premium episodes
        for (final e in mainReels) {
          if (r.unlockedVideoIds.contains(e.id)) e.isLocked = false;
        }
        if (r.unlockedVideoIds.length > 1) Utils.showToast(Get.context!, "${r.unlockedVideoIds.length} episodes unlocked");
      } else {
        Utils.showToast(Get.context!, "${r.message ?? ''}${bonus > 0 ? ' (+$bonus coins)' : ''}");
      }
      update(['reels', 'onGetReels']);
    });
  }

  // ── Auto-unlock toggle (from PremiumBottomSheet checkbox) ──────────────────
  Future<void> setAutoUnlock({
    required bool value,
    String? shortVideoId,
    String? movieWebSeriesId,
  }) async {
    if (movieWebSeriesId != null) {
      localAutoUnlockOverrides[movieWebSeriesId] = value;
      fetchEpisodeWiseReelsModel?.isAutoUnlockEnabled = value;
      await Preference.onIsAutoCheck(value);
      await UnlockEpisodesAutoApi.callApi(
        loginUserId: Preference.userId,
        movieWebSeriesId: movieWebSeriesId,
        type: value,
      );
      update(['reels']);
    } else {
      localAutoUnlockOverrides[movieSeriesId ?? ''] = value;
      // Update model immediately so isAutoUnlock getter reflects the change
      fetchEpisodeWiseReelsModel?.isAutoUnlockEnabled = value;
      await Preference.onIsAutoCheck(value);
      await UnlockEpisodesAutoApi.callApi(
        loginUserId: Preference.userId,
        movieWebSeriesId: movieSeriesId ?? '',
        type: value,
        shortVideoId: shortVideoId ?? '',
      );
      update(['reels']);
    }
  }

  // ── API wrappers ───────────────────────────────────────────────────────────
  Future<void> deductWatchVideoApi({required String? videoId}) async {
    try {
      Get.dialog(const CustomProgressDialog(), barrierDismissible: false);
      final success = await VideoViewApi.callApi(
        shortVideoId: videoId ?? '',
        loginUserId: Preference.userId,
      );
      // Mark as unlocked only if API succeeded
      if (success == true) {
        final idx = mainReels.indexWhere((v) => v.id == videoId);
        if (idx != -1) mainReels[idx].isLocked = false;
      }
    } catch (e) {
      log('deductWatchVideoApi error: $e');
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  Future<void> autoDeductWatchVideoApi({required String? videoId}) async {
    await VideoViewApi.callApi(
      shortVideoId: videoId ?? '',
      loginUserId: Preference.userId,
    );
  }

  Future<void> watchVideoApi({int? currentWatchTime, String? videoId}) async {
    await WatchShortVideoApi.callApi(
      currentWatchTime: currentWatchTime ?? 0,
      videoId: videoId ?? '',
      loginUserId: Preference.userId,
    );
  }

  // ── Pagination ─────────────────────────────────────────────────────────────
  Future<void> onPagination(int value) async {
    if (mainReels.length - 1 != value) return;
    if (isPaginationLoading) return;

    isPaginationLoading = true;
    update(['pagination']);
    await fetchReels();
    isPaginationLoading = false;
    update(['pagination']);
  }

  // ── Jump to episode (from ShowAllEpisodeBottomSheet) ───────────────────────
  void jumpPage(int index) {
    preloadPageController.jumpToPage(index);
    Get.back();
  }

  // ── Favorite ───────────────────────────────────────────────────────────────
  Future<void> onClickFavorite() async {
    // Optimistic update
    final wasLiked = isFavorite.value;
    isFavorite.value = !wasLiked;
    favoriteCount.value += wasLiked ? -1 : 1;
    favoriteCount.value = favoriteCount.value.clamp(0, 999999);

    fetchEpisodeWiseReelsModel?.data?.isAddedList = isFavorite.value;
    fetchEpisodeWiseReelsModel?.data?.totalAddedToList = favoriteCount.value;

    if (Get.isRegistered<ReelsController>()) {
      final rc = Get.find<ReelsController>();
      rc.selectedIndexIsFavorite = isFavorite.value;
      rc.isFavoriteCount = favoriteCount.value;
    }

    Vibration.vibrate(duration: 50, amplitude: 128);

    try {
      await CreateFavoriteVideoApi.callApi(
        loginUserId: Preference.userId,
        movieSeriesId: fetchEpisodeWiseReelsModel?.data?.id ?? '',
      );
    } catch (e) {
      // Revert on failure
      isFavorite.value = wasLiked;
      favoriteCount.value += wasLiked ? 1 : -1;
      log('onClickFavorite error: $e');
    }

    update(['favCount']);
  }

  // ─── ADD: simple watch time tracker per index ───
  final Map<int, int> _watchedSeconds = {};

  void updateWatchedTime(int index, int seconds) {
    _watchedSeconds[index] = (_watchedSeconds[index] ?? 0) + seconds;
  }

  int getWatchedTime(int index) => _watchedSeconds[index] ?? 0;

  Future<void> flushWatchHistory(int index) async {
    final seconds = getWatchedTime(index);
    final videoId = mainReels[index].id ?? "";
    if (seconds > 0 && videoId.isNotEmpty) {
      log("Flush watch history => index:$index seconds:$seconds");
      _watchedSeconds.remove(index); // clear before call — prevent double flush
      await watchVideoApi(currentWatchTime: seconds, videoId: videoId);
    }
  }
}
