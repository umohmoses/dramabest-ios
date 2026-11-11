import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:story_box/custom_widget/block_user_dialog.dart';
import 'package:story_box/ui/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:story_box/ui/login_page/model/login_user_model.dart';
import 'package:story_box/ui/profile_page/api/profile_api.dart';
import 'package:story_box/ui/reels_page/api/fetch_favourite%20_video_api.dart';
import 'package:story_box/ui/reels_page/api/fetch_movie_series_trailer_api.dart';
import 'package:story_box/ui/reels_page/model/fetch_movie_series_trailer_model.dart';
import 'package:story_box/ui/reels_page/model/video.dart';
import 'package:story_box/ui/reels_page/widget/reels_widget.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class ReelsController extends GetxController {
  PreloadPageController preloadPageController = PreloadPageController();

  bool selectedIndexIsFavorite = false;
  int isFavoriteCount = 0;

  int currentPageIndex = 0;
  bool isLoadingReels = false;
  bool isLoadingMyList = false;
  bool isPaginationLoading = false;

  List<TrailerData> mainReels = [];
  FetchMovieSeriesTrailerModel? fetchMovieSeriesTrailerModel;

  List<Video> favoriteVideos = [];
  LoginUserModel? loginUserModel;

  // ✅ NEW: Track if Reels tab is currently active
  RxBool isReelsTabActive = true.obs;

  // ✅ NEW: Track all active video states for cleanup
  Map<int, GlobalKey<PreviewReelsViewState>> videoStateKeys = {};

  Future<void> init() async {
    currentPageIndex = 0;
    mainReels.clear();
    FetchMovieSeriesTrailerApi.startPagination = 0;
    isLoadingReels = true;
    update(["onGetReels"]);
    await onGetReels();
    isLoadingReels = false;
    update(["onGetReels"]);
  }

  @override
  Future<void> onInit() async {
    Utils.showLog("call reel controller");
    onGetFavVideo();

    // ✅ NEW: Listen to bottom bar changes
    _listenToBottomBarChanges();

    super.onInit();
  }

  @override
  void onClose() {
    disposeAllVideos();
    super.onClose();
  }

  // ✅ MODIFIED: Enhanced tab change listener with disposal
  void _listenToBottomBarChanges() {
    try {
      final bottomBarController = Get.find<BottomBarController>();

      ever(bottomBarController.selectedTabIndexRx, (index) {
        if (index == 1) {
          // Reels tab selected - allow playback
          isReelsTabActive.value = true;
          update(['onReelsTabActivated']);
        } else {
          // Other tab selected - DISPOSE all videos immediately
          isReelsTabActive.value = false;
          disposeAllVideos();
          update(['onReelsTabDeactivated']);
        }
      });
    } catch (e) {
      Utils.showLog("BottomBarController not found yet: $e");
    }
  }

  // ✅ NEW: Dispose all video controllers when leaving Reels
  void disposeAllVideos() {
    Utils.showLog("🛑 Disposing all video controllers");

    // Call dispose on all tracked video states
    videoStateKeys.forEach((index, key) {
      try {
        key.currentState?.onDisposeVideoPlayer();
      } catch (e) {
        Utils.showLog("Error disposing video at index $index: $e");
      }
    });

    // Clear the tracking map
    videoStateKeys.clear();
  }

  // ✅ NEW: Register video state for tracking
  void registerVideoState(int index, GlobalKey<PreviewReelsViewState> key) {
    videoStateKeys[index] = key;
  }

  // ✅ NEW: Unregister video state
  void unregisterVideoState(int index) {
    videoStateKeys.remove(index);
  }

  Future<void> blockFunction() async {
    loginUserModel = await ProfileApi.callApi();
    if (loginUserModel?.message == "you are blocked by the admin.") {
      showBlockedUserDialog();
    }
  }

  void onChangePage(int index) async {
    currentPageIndex = index;
    update(["onChangePage"]);
  }

  Future<void> onGetReels() async {
    fetchMovieSeriesTrailerModel = await FetchMovieSeriesTrailerApi.callApi(userId: Preference.userId);

    if (fetchMovieSeriesTrailerModel?.message == "You are blocked by admin.") {
      showBlockedUserDialog();
      return;
    }

    if (fetchMovieSeriesTrailerModel?.data?.isNotEmpty ?? false) {
      final paginationData = fetchMovieSeriesTrailerModel?.data ?? [];
      mainReels.addAll(paginationData);

      FetchMovieSeriesTrailerApi.startPagination += FetchMovieSeriesTrailerApi.limitPagination;
    }
    update(["onGetReels"]);
  }

  void onPagination(int value) async {
    if ((mainReels.length - 1) == value) {
      if (!isPaginationLoading) {
        isPaginationLoading = true;
        update(["onPagination"]);
        await onGetReels();
        isPaginationLoading = false;
        update(["onPagination"]);
      }
    }
  }

  Future<void> onGetFavVideo() async {
    isLoadingMyList = true;
    favoriteVideos = await GetFavoriteVideoApi.callApi();
    isLoadingMyList = false;
    update(["onGetFavVideo"]);
  }
}
