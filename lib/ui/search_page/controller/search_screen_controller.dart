import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/search_page/api/discover_api.dart';
import 'package:story_box/ui/search_page/api/search_movie_series_api.dart';
import 'package:story_box/ui/home_page/api/trending_movie_series_api.dart';
import 'package:story_box/ui/home_page/model/trending_movie_series_model.dart';
import 'package:story_box/ui/search_page/api/most_searched_api.dart';
import 'package:story_box/ui/search_page/api/search_api.dart';
import 'package:story_box/ui/search_page/model/most_searched_model.dart';
import 'package:story_box/ui/search_page/model/search_result.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class SearchScreenController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  TrendingMovieSeriesModel? trendingMovieSeriesModel;
  List<SearchResult> searchResults = [];
  List<String> searchHistory = <String>[].obs;
  bool isSearching = false;
  RxBool searchText = false.obs;
  bool isShowClearHistory = false;
  List<MostSearchedList> mostSearchedList = [];
  /// Titles found outside the published catalogue when nothing published matches (opened = imported).
  List<DiscoveredTitle> discovered = [];
  bool isDiscovering = false;
  int _searchSeq = 0;
  Timer? _discoverTimer;

  Future<void> searchContent(String searchString) async {
    final seq = ++_searchSeq;
    _discoverTimer?.cancel();
    discovered = [];
    isDiscovering = false;
    isSearching = true;
    update(['searchResults']);
    // String query = searchString.isEmpty ? "All" : searchString;

    final results = await SearchApi.findContentBySearch(Preference.userId, searchString);
    if (seq != _searchSeq) return; // the viewer kept typing
    searchResults = results;

    isSearching = false;
    final q = searchString.trim();
    if (results.isEmpty && q.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').length >= 3) {
      isDiscovering = true; // look further once typing pauses
      _discoverTimer = Timer(const Duration(milliseconds: 700), () => _discover(q, seq));
    }
    update(['searchResults']);
  }

  Future<void> _discover(String query, int seq) async {
    final found = await DiscoverApi.search(query);
    if (seq != _searchSeq) return;
    discovered = found;
    isDiscovering = false;
    update(['searchResults']);
  }

  /// Gets the discovered title ready (imported + published on the server) and opens it.
  Future<void> openDiscovered(DiscoveredTitle t) async {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: const [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 14),
            Text("Getting it ready…", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
          ]),
        ),
      ),
      barrierDismissible: false,
    );
    try {
      final id = await DiscoverApi.open(t.token);
      if (Get.isDialogOpen ?? false) Get.back();
      discovered.removeWhere((x) => x.token == t.token);
      update(['searchResults']);
      Get.toNamed(AppRoutes.episodeWiseReels, arguments: {"movieSeriesId": id, "totalVideos": 0});
      SearchMovieSeriesApi.callApi(loginUserId: Preference.userId, query: t.name, movieSeriesId: id);
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      if (Get.context != null) Utils.showToast(Get.context!, '$e');
    }
  }

  @override
  void onClose() {
    _discoverTimer?.cancel();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();

    searchHistory.addAll(Preference.getSearchHistory());
    searchController.addListener(() {
      searchText.value = searchController.text.isNotEmpty;
    });
    List<MostSearchedList> rawList = await MostSearchedApi.callApi(
      start: "1",
      limit: "20",
    );
    mostSearchedList = rawList.where((item) => item.movieSeriesId != null && item.movieSeriesId?.name != null).toList();
    update([Constant.idMostTrending]);
    trendingMovieSeriesModel = await TrendingMoviesSeriesApi.callApi(
      start: "1",
      limit: "10",
    );

    Utils.showLog("mostSearchedList ${mostSearchedList.toList()}");
    update([Constant.idMostTrending]);
  }

  void clearSearch() async {
    searchController.clear();
    searchText.value = false;
    trendingMovieSeriesModel = await TrendingMoviesSeriesApi.callApi(
      start: "1",
      limit: "10",
    );
  }

  void saveSearch(String searchTerm) async {
    if (searchTerm.isNotEmpty) {
      await Preference.addSearchToHistory(searchTerm);
      searchHistory.add(searchTerm);
      update(['searchHistory']);
    }
  }

  void deleteHistoryItem(String item) async {
    await Preference.deleteSearchFromHistory(item);
    searchHistory.remove(item);
    update(['searchResults', 'searchHistory']);
  }

  void clearAllHistory() async {
    await Preference.clearSearchHistory();
    searchHistory.clear();
    update(['searchResults', 'searchHistory']);
  }

  void onDeleteButtonClick() {
    isShowClearHistory = true;
    update(['searchResults', 'searchHistory']);
  }
}
