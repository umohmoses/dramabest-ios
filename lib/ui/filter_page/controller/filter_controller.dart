import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:story_box/ui/filter_page/api/filtered_wase_api.dart';
import 'package:story_box/ui/filter_page/model/filter_model.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/utils.dart';

class FilterController extends GetxController {
  FilterWiseDataModel? filterWiseDataModel;
  List<FilterData> videos = [];

  bool isLoading = false;
  bool hasMoreData = true;
  bool isLoadingMore = false;
  bool _isDisposed = false; // ✅ Add this flag

  // Applied filters
  Set<String> selectedLanguageIds = {};
  Set<String> selectedCategoryIds = {};
  String selectedSort = '';

  // Pagination
  int currentPage = 0;
  final int limit = 20;

  ScrollController scrollController = ScrollController();
  List<String> get activeFilterLabels {
    final list = <String>[];
    if (selectedCategoryIds.isNotEmpty) list.add('Category');
    if (selectedLanguageIds.isNotEmpty) list.add('Language');
    if (selectedSort.isNotEmpty) list.add('Sort: $selectedSort');
    return list;
  }

  void removeChip(String label) {
    if (label == 'Category') selectedCategoryIds.clear();
    if (label == 'Language') selectedLanguageIds.clear();
    if (label.startsWith('Sort')) selectedSort = '';
    applyNewFilters(
      categories: selectedCategoryIds,
      languages: selectedLanguageIds,
      sort: selectedSort,
    );
    update([Constant.onGetFilter]);
    // hide sticky bar + scroll to top
  }

  @override
  void onInit() {
    super.onInit();
    initializeFilters();
    setupScrollListener();
    loadInitialData();
  }

  // ✅ Safe update method
  void safeUpdate([List<Object>? ids, bool condition = true]) {
    if (!_isDisposed) {
      update(ids, condition);
    }
  }

  void initializeFilters() {
    try {
      Utils.showLog("hELLOW");
      final args = Get.arguments as Map<String, dynamic>?;

      if (args == null) {
        Utils.showLog("❌ No arguments received");
        return;
      }

      final filters = args["appliedFilters"] as Map<String, dynamic>?;
      if (filters != null) {
        final categories = filters["categories"];
        if (categories is List) {
          selectedCategoryIds = categories.map((e) => e.toString()).toSet();
        }

        final languages = filters["languages"];
        if (languages is List) {
          selectedLanguageIds = languages.map((e) => e.toString()).toSet();
        }

        selectedSort = filters["sort"]?.toString() ?? '';
      }

      Utils.showLog("📊 Filters Initialized:");
      Utils.showLog("Categories: $selectedCategoryIds");
      Utils.showLog("Languages: $selectedLanguageIds");
      Utils.showLog("Sort: $selectedSort");
    } catch (e, stackTrace) {
      Utils.showLog("❌ Error initializing filters: $e");
      Utils.showLog("Stack: $stackTrace");
    }
  }

  Future<void> loadInitialData() async {
    isLoading = true;
    safeUpdate(); // ✅ Use safeUpdate

    try {
      Utils.showLog("📥 Loading initial data...");

      final result = await FilterWiseDataApi.callApi(
        start: "1",
        limit: limit.toString(),
        selectedCategoryIDs: selectedCategoryIds.isEmpty ? null : selectedCategoryIds,
        selectedLanguageIDs: selectedLanguageIds.isEmpty ? null : selectedLanguageIds,
        sortBy: selectedSort.toLowerCase(),
      );

      if (result != null && result.filterData != null) {
        filterWiseDataModel = result;
        videos = List<FilterData>.from(result.filterData!);
        hasMoreData = result.filterData!.length >= limit;

        Utils.showLog("✅ Initial data loaded: ${videos.length} videos");
        safeUpdate([Constant.onGetFilter]); // ✅ Use safeUpdate
      } else {
        Utils.showLog("❌ No data received from API");
        hasMoreData = false;
      }
    } catch (e, stackTrace) {
      Utils.showLog("❌ Error loading initial data: $e");
      Utils.showLog("Stack: $stackTrace");
    } finally {
      isLoading = false;
      safeUpdate([Constant.onGetFilter]); // ✅ Use safeUpdate
    }
  }

  Future<void> initialFilterData() async {
    isLoading = true;
    safeUpdate(); // ✅ Use safeUpdate

    try {
      Utils.showLog("📥 Loading initial data...");

      final result = await FilterWiseDataApi.callApi(
        start: "1",
        limit: limit.toString(),
        selectedCategoryIDs: selectedCategoryIds.isEmpty ? null : selectedCategoryIds,
        selectedLanguageIDs: selectedLanguageIds.isEmpty ? null : selectedLanguageIds,
        sortBy: selectedSort.toLowerCase(),
      );

      if (result != null && result.filterData != null) {
        videos.clear();
        filterWiseDataModel = result;
        videos = List<FilterData>.from(result.filterData!);
        hasMoreData = result.filterData!.length >= limit;

        Utils.showLog("✅ Initial data loaded: ${videos.length} videos");
        safeUpdate([Constant.onGetFilter]); // ✅ Use safeUpdate
      } else {
        Utils.showLog("❌ No data received from API");
        hasMoreData = false;
      }
    } catch (e, stackTrace) {
      Utils.showLog("❌ Error loading initial data: $e");
      Utils.showLog("Stack: $stackTrace");
    } finally {
      isLoading = false;
      safeUpdate([Constant.onGetFilter]); // ✅ Use safeUpdate
    }
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (!isLoadingMore && hasMoreData && videos.isNotEmpty) {
          loadMoreVideos();
        }
      }
    });
  }

  Future<void> loadMoreVideos() async {
    if (isLoadingMore || !hasMoreData || _isDisposed) return; // ✅ Check disposed

    isLoadingMore = true;
    safeUpdate(); // ✅ Use safeUpdate

    try {
      currentPage++;
      final startIndex = currentPage * limit;

      Utils.showLog("📥 Loading page $currentPage, start: $startIndex");

      final result = await FilterWiseDataApi.callApi(
        start: startIndex.toString(),
        limit: limit.toString(),
        selectedCategoryIDs: selectedCategoryIds.isEmpty ? null : selectedCategoryIds,
        selectedLanguageIDs: selectedLanguageIds.isEmpty ? null : selectedLanguageIds,
        sortBy: selectedSort.toLowerCase(),
      );

      if (result != null && result.filterData != null) {
        if (result.filterData!.isEmpty || result.filterData!.length < limit) {
          hasMoreData = false;
          Utils.showLog("✅ No more videos available");
        }

        if (result.filterData!.isNotEmpty) {
          videos.addAll(result.filterData!);
          Utils.showLog("✅ Loaded ${result.filterData!.length} more videos. Total: ${videos.length}");
        }
      } else {
        hasMoreData = false;
        Utils.showLog("❌ No result from API");
      }
    } catch (e) {
      Utils.showLog("❌ Error loading more: $e");
      currentPage--;
    } finally {
      isLoadingMore = false;
      safeUpdate(); // ✅ Use safeUpdate
    }
  }

  Future<void> applyNewFilters({
    Set<String>? categories,
    Set<String>? languages,
    String? sort,
  }) async {
    if (categories != null) selectedCategoryIds = categories;
    if (languages != null) selectedLanguageIds = languages;
    if (sort != null) selectedSort = sort;

    currentPage = 0;

    hasMoreData = true;

    initialFilterData();
    Utils.showLog("🔄 Applying new filters...");
  }

  Future<void> refreshVideos() async {
    currentPage = 0;
    videos.clear();
    hasMoreData = true;
  }

  @override
  void onClose() {
    _isDisposed = true; // ✅ Mark as disposed
    scrollController.dispose();
    super.onClose();
  }
}

// class FilterController extends GetxController {
//   FilterWiseDataModel? filterWiseDataModel;
//   List<FilterData> videos = [];
//
//   bool isLoading = false;
//   bool hasMoreData = true;
//   bool isLoadingMore = false;
//
//   // Applied filters
//   Set<String> selectedLanguageIds = {};
//   Set<String> selectedCategoryIds = {};
//   String selectedSort = 'popular';
//
//   // Pagination
//   int currentPage = 0;
//   final int limit = 20;
//
//   ScrollController scrollController = ScrollController();
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     initializeFilters();
//     setupScrollListener();
//     loadInitialData(); // ✅ Initial API call
//   }
//
//   // ✅ Get filters from arguments
//   void initializeFilters() {
//     try {
//       Utils.showLog("hELLOW");
//       final args = Get.arguments as Map<String, dynamic>?;
//
//       if (args == null) {
//         Utils.showLog("❌ No arguments received");
//         return;
//       }
//
//       final filters = args["appliedFilters"] as Map<String, dynamic>?;
//       if (filters != null) {
//         // Convert List to Set
//         final categories = filters["categories"];
//         if (categories is List) {
//           selectedCategoryIds = categories.map((e) => e.toString()).toSet();
//         }
//
//         final languages = filters["languages"];
//         if (languages is List) {
//           selectedLanguageIds = languages.map((e) => e.toString()).toSet();
//         }
//
//         selectedSort = filters["sort"]?.toString() ?? 'popular';
//       }
//
//       Utils.showLog("📊 Filters Initialized:");
//       Utils.showLog("Categories: $selectedCategoryIds");
//       Utils.showLog("Languages: $selectedLanguageIds");
//       Utils.showLog("Sort: $selectedSort");
//     } catch (e, stackTrace) {
//       Utils.showLog("❌ Error initializing filters: $e");
//       Utils.showLog("Stack: $stackTrace");
//     }
//   }
//
//   // ✅ Load initial data
//   Future<void> loadInitialData() async {
//     isLoading = true;
//     update();
//
//     try {
//       Utils.showLog("📥 Loading initial data...");
//
//       final result = await FilterWiseDataApi.callApi(
//         start: "1",
//         limit: limit.toString(),
//         selectedCategoryIDs: selectedCategoryIds.isEmpty ? null : selectedCategoryIds,
//         selectedLanguageIDs: selectedLanguageIds.isEmpty ? null : selectedLanguageIds,
//         sortBy: selectedSort.toLowerCase(),
//       );
//
//       if (result != null && result.filterData != null) {
//         filterWiseDataModel = result;
//         videos = List<FilterData>.from(result.filterData!);
//         hasMoreData = result.filterData!.length >= limit;
//
//         Utils.showLog("✅ Initial data loaded: ${videos.length} videos");
//         update([Constant.onGetFilter]);
//       } else {
//         Utils.showLog("❌ No data received from API");
//         hasMoreData = false;
//       }
//     } catch (e, stackTrace) {
//       Utils.showLog("❌ Error loading initial data: $e");
//       Utils.showLog("Stack: $stackTrace");
//     } finally {
//       isLoading = false;
//       update([Constant.onGetFilter]);
//     }
//   }
//
//   // ✅ Setup scroll listener for pagination
//   void setupScrollListener() {
//     scrollController.addListener(() {
//       if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
//         if (!isLoadingMore && hasMoreData && videos.isNotEmpty) {
//           loadMoreVideos();
//         }
//       }
//     });
//   }
//
//   // ✅ Load more videos (pagination)
//   Future<void> loadMoreVideos() async {
//     if (isLoadingMore || !hasMoreData) return;
//
//     isLoadingMore = true;
//     update();
//
//     try {
//       currentPage++;
//       final startIndex = currentPage * limit;
//
//       Utils.showLog("📥 Loading page $currentPage, start: $startIndex");
//
//       final result = await FilterWiseDataApi.callApi(
//         start: startIndex.toString(),
//         limit: limit.toString(),
//         selectedCategoryIDs: selectedCategoryIds.isEmpty ? null : selectedCategoryIds,
//         selectedLanguageIDs: selectedLanguageIds.isEmpty ? null : selectedLanguageIds,
//         sortBy: selectedSort.toLowerCase(),
//       );
//
//       if (result != null && result.filterData != null) {
//         if (result.filterData!.isEmpty || result.filterData!.length < limit) {
//           hasMoreData = false;
//           Utils.showLog("✅ No more videos available");
//         }
//
//         if (result.filterData!.isNotEmpty) {
//           videos.addAll(result.filterData!);
//           Utils.showLog("✅ Loaded ${result.filterData!.length} more videos. Total: ${videos.length}");
//         }
//       } else {
//         hasMoreData = false;
//         Utils.showLog("❌ No result from API");
//       }
//     } catch (e) {
//       Utils.showLog("❌ Error loading more: $e");
//       currentPage--; // Rollback on error
//     } finally {
//       isLoadingMore = false;
//       update();
//     }
//   }
//
//   // ✅ Apply new filters and reload
//   Future<void> applyNewFilters({
//     Set<String>? categories,
//     Set<String>? languages,
//     String? sort,
//   }) async {
//     // Update filters
//     if (categories != null) selectedCategoryIds = categories;
//     if (languages != null) selectedLanguageIds = languages;
//     if (sort != null) selectedSort = sort;
//
//     // Reset state
//     currentPage = 0;
//     videos.clear();
//     hasMoreData = true;
//
//     Utils.showLog("🔄 Applying new filters...");
//
//     // await loadInitialData();
//   }
//
//   // ✅ Pull to refresh
//   Future<void> refreshVideos() async {
//     currentPage = 0;
//     videos.clear();
//     hasMoreData = true;
//
//     // await loadInitialData();
//   }
//
//   @override
//   void onClose() {
//     scrollController.dispose();
//     super.onClose();
//   }
// }
