import 'package:get/get.dart';
import 'package:story_box/ui/home_page/explore/explore_api.dart';

/// A list that grows page by page each time the user drags to its end.
class PagedList<T> {
  final Future<ExplorePage<T>?> Function(int start) fetch;
  PagedList(this.fetch);

  final List<T> items = [];
  int _next = 1;
  bool hasMore = true;
  bool loading = false;
  bool failed = false;

  bool get isFirstLoad => items.isEmpty && (loading || (hasMore && !failed));

  /// Returns true when something changed.
  Future<bool> loadMore() async {
    if (loading || !hasMore) return false;
    loading = true;
    failed = false;
    final page = await fetch(_next);
    loading = false;
    if (page == null) {
      failed = true;
      return true;
    }
    items.addAll(page.items);
    hasMore = page.hasMore && page.items.isNotEmpty;
    _next++;
    return true;
  }

  void reset() {
    items.clear();
    _next = 1;
    hasMore = true;
    loading = false;
    failed = false;
  }
}

class ExploreController extends GetxController {
  static const idTrending = "exploreTrending";
  static const idYouMightLike = "exploreYouMightLike";
  static const idNew = "exploreNew";
  static const periods = {"day": "Today", "week": "This Week", "month": "This Month"};

  static ExploreController get to => Get.isRegistered<ExploreController>() ? Get.find<ExploreController>() : Get.put(ExploreController(), permanent: true);

  String period = "day";
  List<ExploreTitle> trending = [];
  bool trendingLoading = true;

  final youMightLike = PagedList<ExploreGroup>((start) => ExploreApi.youMightLike(start: start));
  final newest = PagedList<ExploreTitle>((start) => ExploreApi.newest(start: start));

  @override
  void onInit() {
    super.onInit();
    loadTrending();
    loadMoreYouMightLike();
    loadMoreNew();
  }

  Future<void> loadTrending() async {
    trendingLoading = true;
    update([idTrending]);
    final list = await ExploreApi.trending(period: period);
    if (list != null) trending = list;
    trendingLoading = false;
    update([idTrending]);
  }

  void setPeriod(String p) {
    if (p == period || !periods.containsKey(p)) return;
    period = p;
    loadTrending();
  }

  Future<void> loadMoreYouMightLike() async {
    if (youMightLike.loading || !youMightLike.hasMore) return;
    update([idYouMightLike]);
    if (await youMightLike.loadMore()) update([idYouMightLike]);
  }

  Future<void> loadMoreNew() async {
    if (newest.loading || !newest.hasMore) return;
    update([idNew]);
    if (await newest.loadMore()) update([idNew]);
  }

  /// Pull-to-refresh on the home page: start every list again from the top.
  Future<void> refreshAll() async {
    youMightLike.reset();
    newest.reset();
    await Future.wait([loadTrending(), loadMoreYouMightLike(), loadMoreNew()]);
  }
}
