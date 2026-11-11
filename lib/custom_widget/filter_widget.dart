import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';

import 'package:story_box/ui/filter_page/model/filter_model.dart';

import 'package:story_box/ui/home_page/api/language_list_api.dart';
import 'package:story_box/ui/home_page/api/movie_category_api.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/home_page/model/get_all_category_model.dart';
import 'package:story_box/ui/home_page/model/language_list_model.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/utils.dart';

void showFilterBottomSheet(BuildContext context) {
  Get.bottomSheet(
    const FilterBottomSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    persistent: false, // Ye line add karo
    ignoreSafeArea: false,
  );
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Multi-select for both
  final Set<String> selectedCategoryIds = {};
  final Set<String> selectedCategoryNames = {};

  final Set<String> selectedLanguageIds = {};
  final Set<String> selectedLanguageNames = {};

  String selectedSort = '';

  final List<String> sortOptions = ['Popular', 'Latest'];

  // === CATEGORIES ===
  final List<CategoryList> categories = [];
  bool isCategoryLoading = true;
  bool isCategoryLoadingMore = false;
  bool hasMoreCategories = true;
  int categoryCurrentPage = 1;
  final int categoryLimit = 20;
  FilterWiseDataModel? filterWiseDataModel;
  // === LANGUAGES ===
  final List<Language> languages = [];
  bool isLanguageLoading = true;
  bool isLanguageLoadingMore = false;
  bool hasMoreLanguages = true;
  int languageCurrentPage = 1;
  final int languageLimit = 20;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeCategories();
    _initializeLanguages();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // ====================== CATEGORIES ======================
  Future<void> _initializeCategories() async {
    final controller = Get.find<HomeController>();
    final existingData = controller.allCategoryModel?.data ?? [];

    setState(() => isCategoryLoading = true);

    if (existingData.length >= categoryLimit) {
      hasMoreCategories = true;
      categoryCurrentPage = (existingData.length / categoryLimit).ceil() + 1;
    } else {
      hasMoreCategories = false;
    }

    setState(() {
      categories.clear();
      categories.addAll(existingData);
      isCategoryLoading = false;
    });
  }

  Future<void> _loadMoreCategories() async {
    if (isCategoryLoadingMore || !hasMoreCategories) return;
    setState(() => isCategoryLoadingMore = true);

    try {
      final response = await GetAllCategoryApi().callApi(
        start: categoryCurrentPage.toString(),
        limit: categoryLimit.toString(),
      );

      final newItems = response?.data ?? [];
      setState(() {
        categories.addAll(newItems);
        if (newItems.length < categoryLimit) {
          hasMoreCategories = false;
        } else {
          categoryCurrentPage++;
        }
      });
    } catch (e) {
      debugPrint("Category load error: $e");
    } finally {
      setState(() => isCategoryLoadingMore = false);
    }
  }

  // ====================== LANGUAGES ======================
  Future<void> _initializeLanguages() async {
    final controller = Get.find<HomeController>();
    final existingData = controller.languageListModel?.data ?? [];

    setState(() => isLanguageLoading = true);

    if (existingData.length >= languageLimit) {
      hasMoreLanguages = true;
      languageCurrentPage = (existingData.length / languageLimit).ceil() + 1;
    } else {
      hasMoreLanguages = false;
    }

    setState(() {
      languages.clear();
      languages.addAll(existingData);
      isLanguageLoading = false;
    });
  }

  Future<void> _loadMoreLanguages() async {
    if (isLanguageLoadingMore || !hasMoreLanguages) return;
    setState(() => isLanguageLoadingMore = true);

    try {
      final response = await GetAllLanguagesApi().callApi(
        start: languageCurrentPage.toString(),
        limit: languageLimit.toString(),
      );

      final newItems = response?.data ?? [];
      setState(() {
        languages.addAll(newItems);
        if (newItems.length < languageLimit) {
          hasMoreLanguages = false;
        } else {
          languageCurrentPage++;
        }
      });
    } catch (e) {
      debugPrint("Language load error: $e");
    } finally {
      setState(() => isLanguageLoadingMore = false);
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 300) {
      if (hasMoreCategories) _loadMoreCategories();
      if (hasMoreLanguages) _loadMoreLanguages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      blur: 2,
      color: AppColor.colorBlack.withAlpha(120),
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 30),
                Text(EnumLocal.txtApplyFilter.name.tr, style: AppFontStyle.styleW600(AppColor.colorWhite, 18)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.2)),
                    child: Icon(Icons.close, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          10.height,
          Divider(color: AppColor.colorWhite.withValues(alpha: 0.3), thickness: 1.5),

          Flexible(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,

                    // === CATEGORIES ===
                    if (categories.isNotEmpty || isCategoryLoading) ...[
                      Text(EnumLocal.txtCategories.name.tr, style: AppFontStyle.styleW600(AppColor.colorWhite, 18)),
                      5.height,
                      if (isCategoryLoading && categories.isEmpty) _buildShimmerGrid() else _buildCategoryGrid(),
                      24.height,
                    ],

                    // === LANGUAGES ===
                    if (languages.isNotEmpty || isLanguageLoading) ...[
                      if (isLanguageLoading && languages.isEmpty) _buildShimmerGrid() else _buildLanguageSection(),
                      24.height,
                    ],

                    // === SORT BY ===
                    Text(EnumLocal.txtSortBy.name.tr, style: AppFontStyle.styleW600(AppColor.colorWhite, 18)),
                    12.height,
                    Wrap(
                      spacing: 10,
                      children: sortOptions.map((sort) {
                        final isSelected = selectedSort == sort;
                        return GestureDetector(
                          onTap: () => setState(() => selectedSort = sort),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 50),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: isSelected ? AppColor.primaryGradient : null,
                              color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: isSelected ? Colors.white : Colors.white24),
                            ),
                            child: Text(sort, style: AppFontStyle.styleW600(isSelected ? Colors.white : Colors.white70, 14)),
                          ),
                        );
                      }).toList(),
                    ),
                    30.height,

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              selectedCategoryIds.clear();
                              selectedCategoryNames.clear();
                              selectedLanguageIds.clear();
                              selectedLanguageNames.clear();
                              selectedSort = '';
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Text(EnumLocal.txtReset.name.tr, style: AppFontStyle.styleW800(Colors.black, 16)),
                          ),
                        ),
                        15.width,
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (selectedCategoryIds.isEmpty || selectedLanguageIds.isEmpty) {
                                Utils.showToast(context, EnumLocal.txtPleaseSelectAtLeastOneCategory.name.tr);

                                return;
                              }

                              Get.back();
                              await Future.delayed(Duration(milliseconds: 100)); // chhota sa delay

                              Utils.showLog("SOLUL categories ==> ${selectedCategoryIds.toList()}");
                              Utils.showLog("SOLUL languages ==> ${selectedLanguageIds.toList()}");
                              Utils.showLog("SOLUL sort ==> $selectedSort");

                              Get.toNamed(
                                AppRoutes.filter, // Your route name
                                arguments: {
                                  "appliedFilters": {
                                    "categories": selectedCategoryIds.toList(),
                                    "languages": selectedLanguageIds.toList(),
                                    "sort": selectedSort,
                                  }
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.colorButtonPink,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Text(EnumLocal.txtConfirm.name.tr, style: AppFontStyle.styleW800(Colors.white, 16)),
                          ),
                        ),
                      ],
                    ),
                    20.height,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Shimmer
  Widget _buildShimmerGrid() => GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 35,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 9,
        itemBuilder: (_, __) => Container(decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(30))),
      );

  Widget _buildCategoryGrid() => Wrap(
        spacing: 10, // horizontal gap
        runSpacing: 10, // vertical gap (yehi tumhara mainAxisSpacing tha)
        children: [
          // Loading indicator (if needed)
          if (isCategoryLoadingMore)
            Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.colorButtonPink,
              ),
            ),

          // All categories
          ...categories.map((cat) {
            final isSelected = selectedCategoryIds.contains(cat.id);

            return GestureDetector(
              onTap: () => setState(() {
                if (isSelected) {
                  selectedCategoryIds.remove(cat.id);
                  selectedCategoryNames.remove(cat.name);
                } else {
                  selectedCategoryIds.add(cat.id ?? "");
                  selectedCategoryNames.add(cat.name ?? "");
                }
              }),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 150),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // perfect breathing
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColor.primaryGradient : null,
                  color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.white24,
                    width: isSelected ? 1.2 : 1,
                  ),
                ),
                child: Text(
                  cat.name ?? "",
                  style: AppFontStyle.styleW600(
                    isSelected ? Colors.white : Colors.white70,
                    13,
                  ),
                ),
              ),
            );
          }),
        ],
      );
  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(EnumLocal.language.name.tr, style: AppFontStyle.styleW600(AppColor.colorWhite, 18)),
          ],
        ),
        12.height,

        // First time loading — shimmer
        if (isLanguageLoading && languages.isEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(9, (_) => _shimmerChip()),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // Load more indicator
              if (isLanguageLoadingMore)
                Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.colorButtonPink,
                  ),
                ),

              // All languages
              ...languages.map((lang) {
                final isSelected = selectedLanguageIds.contains(lang.id);

                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) {
                      selectedLanguageIds.remove(lang.id);
                      selectedLanguageNames.remove(lang.name);
                    } else {
                      selectedLanguageIds.add(lang.id ?? "");
                      selectedLanguageNames.add(lang.name ?? "");
                    }
                  }),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColor.primaryGradient : null,
                      color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white24,
                        width: isSelected ? 1.2 : 1,
                      ),
                    ),
                    child: Text(
                      lang.name ?? "",
                      style: AppFontStyle.styleW600(
                        isSelected ? Colors.white : Colors.white70,
                        13,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
      ],
    );
  }

  Widget _shimmerChip() => Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white12, width: 1),
        ),
      );
}
