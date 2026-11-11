import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/connectivity_manager/connectivity_manager.dart';
import 'package:story_box/custom_widget/block_user_dialog.dart';
import 'package:story_box/ui/filter_page/controller/filter_controller.dart';
import 'package:story_box/ui/home_page/api/all_movie_ranking_api.dart';
import 'package:story_box/ui/home_page/api/get_movies_grouped_by_category_api.dart';
import 'package:story_box/ui/home_page/api/get_movies_series_api.dart';
import 'package:story_box/ui/home_page/api/language_list_api.dart';
import 'package:story_box/ui/home_page/api/movie_category_api.dart';
import 'package:story_box/ui/home_page/api/new_releases_video_api.dart';
import 'package:story_box/ui/home_page/api/trending_movie_series_api.dart';
import 'package:story_box/ui/home_page/explore/explore_controller.dart';
import 'package:story_box/ui/home_page/model/get_all_category_model.dart';
import 'package:story_box/ui/home_page/model/get_all_movie_ranking_model.dart';
import 'package:story_box/ui/home_page/model/get_movies_grouped_by_category_model.dart';
import 'package:story_box/ui/home_page/model/get_movies_series_model.dart';
import 'package:story_box/ui/home_page/model/language_list_model.dart';
import 'package:story_box/ui/home_page/model/new_releases_video_model.dart';
import 'package:story_box/ui/home_page/model/trending_movie_series_model.dart';
import 'package:story_box/ui/login_page/model/login_user_model.dart';
import 'package:story_box/ui/profile_page/api/profile_api.dart';
import 'package:story_box/ui/reels_page/controller/reels_controller.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class HomeController extends GetxController {
  int initialPage = 0;
  CarouselSliderController controller = CarouselSliderController();
  ScrollController categoryScrollController = ScrollController();

  FilterController filterController = Get.isRegistered<FilterController>() ? Get.find<FilterController>() : Get.put(FilterController());

  double appBarOpacity = 0.0;
  bool isClaimed = false;

  bool isLoading = false;
  GetMoviesSeriesModel? getMoviesSeriesModel;
  GetMoviesGroupedByCategoryModel? getMoviesGroupedByCategoryModel;
  NewReleasesVideoModel? newReleasesVideoModel;
  AllCategoryModel? allCategoryModel;
  AllMovieRankingModel? allMovieRankingModel;
  LanguageListModel? languageListModel;
  TrendingMovieSeriesModel? trendingMovieSeriesModel;
  bool isLoadingMostTrending = false;
  bool isLoadingMostTrending1 = false;
  List<NewReleasesVideos> newReleasesVideos = [];
  List<CategoryList> allCategory = [];
  List<Trending> allRanking = [];
  List<Language> allLanguage = [];
  final ScrollController scrollController1 = ScrollController();
  List watchedVideos = [];

  int startNewReleaseCount = 1;
  int limitNewReleaseCount = 20;
  int startAllCategoryCount = 1;
  int limitAllCategoryCount = 20;
  int startAllLanguagesCount = 1;
  int limitAllLanguagesCount = 20;
  int startAllRankingCount = 1;
  int limitAllRankingCount = 20;

  final reelsController = Get.find<ReelsController>();
  // User? user;
  LoginUserModel? loginUserModel;
  String getMoviesGroupedByCategoryStart = "1";
  String getMoviesGroupedByCategoryLimit = "10";
  String getMoviesGroupedByCategoryMoviesStart = "1";
  String getMoviesGroupedByCategoryMoviesLimit = "10";
  late PageController pageController;
  int currentPageIndex = 0;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  List<Movies> allMovies = [];
  @override
  void onInit() async {
    InternetConnectivity.isInternetAvailable(
      Get.context!,
      success: () {
        Utils.showLog("message:::::::Success");
      },
      retry: () {
        Utils.showLog("message:::::::Retry");
      },
    );
    Utils.showLog("APP Open 01");
    final stopwatch = Stopwatch()..start();
    Utils.showLog("Enter in home controller");
    pageController = PageController(initialPage: 0);
    scrollController1.addListener(onPagination1);
    profileApiCall();

    Utils.showLog("APP Open 02 ${stopwatch.elapsedMilliseconds}");
    await homeApiCalls();
    Utils.showLog("APP Open 03 ${stopwatch.elapsedMilliseconds}");
    stopwatch.stop();
    othersApiCalls();

    super.onInit();
  }

  Future<void> homeApiCalls() async {
    isLoadingMostTrending = true;
    getMoviesSeriesModel = await GetMoviesSeriesApi.callApi();

    trendingMovieSeriesModel = await TrendingMoviesSeriesApi.callApi(
      start: "1",
      limit: "20",
    );
    isLoadingMostTrending = false;
    update([
      Constant.idMostTrending,
      Constant.idHomeBlurCarousel,
      Constant.idHomeCarousel,
    ]);
    Utils.showLog("APP Open 04 ");
  }

  Future<void> othersApiCalls() async {
    getMoviesGroupedByCategoryModel = await GetMoviesGroupedByCategoryApi.callApi(
      userId: Preference.userId,
      start: getMoviesGroupedByCategoryStart,
      limit: getMoviesGroupedByCategoryLimit,
      moviesStart: getMoviesGroupedByCategoryMoviesStart,
      moviesLimit: getMoviesGroupedByCategoryMoviesLimit,
    );
    for (var group in getMoviesGroupedByCategoryModel?.groupedMovies ?? []) {
      if (group.movies != null) {
        allMovies.addAll(group.movies!);
      }
    }
    newReleasesVideoModel = await NewReleasesVideoApi().callApi(
      userId: Preference.userId,
      start: startNewReleaseCount.toString(),
      limit: limitNewReleaseCount.toString(),
    );
    if (newReleasesVideoModel?.videos != null) {
      newReleasesVideos.addAll(newReleasesVideoModel?.videos ?? []);
    }

    allMovieRankingModel = await GetAllRankingApi().callApi(
      start: startAllRankingCount.toString(),
      limit: limitAllRankingCount.toString(),
    );
    if (allMovieRankingModel?.trending != null) {
      allRanking.addAll(allMovieRankingModel?.trending ?? []);
    }

    getHistory();

    allCategoryModel = await GetAllCategoryApi().callApi(
      start: startAllCategoryCount.toString(),
      limit: limitAllCategoryCount.toString(),
    );
    if (allCategoryModel?.data != null) {
      allCategory.addAll(allCategoryModel?.data ?? []);
    }
    languageListModel = await GetAllLanguagesApi().callApi(
      start: startAllLanguagesCount.toString(),
      limit: limitAllLanguagesCount.toString(),
    );
    if (languageListModel?.data != null) {
      allLanguage.addAll(languageListModel?.data ?? []);
    }
    update([
      Constant.idMostTrending,
      Constant.idHomeBlurCarousel,
      Constant.idHomeCarousel,
    ]);
  }

  Future<void> profileApiCall() async {
    // user = await ProfileApi.callApi();
    loginUserModel = await ProfileApi.callApi();

    Utils.showLog("user.isBlock: ${loginUserModel?.user?.isBlock}");
    Utils.showLog("loginUserModel.status: ${loginUserModel?.status}");

    if (loginUserModel?.message == "you are blocked by the admin.") {
      showBlockedUserDialog();

      return;
    }

    update(['userProfile']);

    String userDataJson = jsonEncode(loginUserModel?.user?.toJson());
    await Preference.shared.setString(Preference.userData, userDataJson);

    final isVip = loginUserModel?.user?.isVip ?? false;
    final coin = loginUserModel?.user?.coin ?? 0;

    await Preference.onIsVip(isVip);
    await Preference.onSetUserCoin(coin);
  }

  Future<void> onPagination1() async {
    if (scrollController1.position.pixels == scrollController1.position.maxScrollExtent) {
      isLoadingMostTrending1 = true;
      update();

      final model = await NewReleasesVideoApi().callApi(
        userId: Preference.userId,
        start: startNewReleaseCount.toString(),
        limit: limitNewReleaseCount.toString(),
      );
      if (model?.videos != null) {
        newReleasesVideos.addAll(model?.videos ?? []);
      }
      isLoadingMostTrending1 = false;
      update();
    }
  }

  void updateAppBarOpacity(double offset) {
    appBarOpacity = (offset / 100).clamp(0.0, 0.5);
    appBarOpacity = appBarOpacity + (appBarOpacity * 0.3);
    update([Constant.onChangeTab]);
    update();

    Utils.showLog("appBarOpacity: $appBarOpacity");
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    initialPage = index;
    update([
      Constant.idHomeCarousel,
      Constant.idHomeBlurCarousel,
    ]);
  }

  void toggleClaim() {
    isClaimed = !isClaimed;
    update([Constant.idHomeCarousel]);
  }

  Future<void> getHistory() async {
    watchedVideos = await Preference.getWatchedVideos();
    update([Constant.idGetHistory, Constant.idFavourite]);
  }

  Future<void> onRefresh() async {
    ExploreController.to.refreshAll(); // Trending, You Might Like and New start again from the top
    getMoviesSeriesModel = await GetMoviesSeriesApi.callApi();

    getMoviesGroupedByCategoryModel = await GetMoviesGroupedByCategoryApi.callApi(
      userId: Preference.userId,
      start: getMoviesGroupedByCategoryStart,
      limit: getMoviesGroupedByCategoryLimit,
      moviesStart: getMoviesGroupedByCategoryMoviesStart,
      moviesLimit: getMoviesGroupedByCategoryMoviesLimit,
    );

    newReleasesVideoModel = await NewReleasesVideoApi().callApi(
      userId: Preference.userId,
      start: "1",
      limit: "20",
    );

    allCategoryModel = await GetAllCategoryApi().callApi(
      start: "1",
      limit: "20",
    );
    allMovieRankingModel = await GetAllRankingApi().callApi(
      start: "1",
      limit: "20",
    );
    if (newReleasesVideoModel?.videos != null) {
      newReleasesVideos.addAll(newReleasesVideoModel?.videos ?? []);
    }
    if (allCategoryModel?.data != null) {
      allCategory.addAll(allCategoryModel?.data ?? []);
    }
    if (allMovieRankingModel?.trending != null) {
      allRanking.addAll(allMovieRankingModel?.trending ?? []);
    }
    trendingMovieSeriesModel = await TrendingMoviesSeriesApi.callApi(
      start: "1",
      limit: "20",
    );
    isLoadingMostTrending = false;
    getHistory();
    update([
      Constant.idMostTrending,
      Constant.idGetHistory,
      Constant.idHomeCarousel,
      Constant.idHomeBlurCarousel,
    ]);
  }

  Future<void> likeUnlikeEpisode(int index) async {
    watchedVideos[index]['isLike'] = !watchedVideos[index]['isLike'];
    try {
      Map<String, dynamic> updatedVideo = watchedVideos[index];
      await Preference.addVideoToHistory(updatedVideo);
      update([Constant.idFavourite, Constant.idGetHistory]);
    } catch (e) {
      watchedVideos[index]['isLike'] = !watchedVideos[index]['isLike'];
      update([Constant.idFavourite, Constant.idMostTrending]);
      Utils.showLog("Error updating video in history: $e");
    }
  }

  int selectedTabIndex = 0;
  bool isPageAnimating = false;
  void onTapChangeTab(int value) async {
    if (value == selectedTabIndex) return;

    isPageAnimating = true;
    selectedTabIndex = value;

    await pageController.animateToPage(
      value,
      duration: 250.milliseconds,
      curve: Curves.ease,
    );

    isPageAnimating = false;

    update([Constant.onChangeTab, Constant.idHomeBlurCarousel]);
  }

  void onPageChangedTab(int value) async {
    if (isPageAnimating) return; // ✅ prevents loop
    if (value == selectedTabIndex) return;

    selectedTabIndex = value;
    update([Constant.onChangeTab, Constant.idHomeBlurCarousel]);
  }
}
