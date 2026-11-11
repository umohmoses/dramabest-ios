import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:story_box/custom_widget/no_data_widget.dart';
import 'package:story_box/ui/filter_page/controller/filter_controller.dart';
import 'package:story_box/ui/filter_page/widget/filter_widget.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

class CategoryBuilderView extends StatelessWidget {
  const CategoryBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (logic) {
        return Stack(
          children: [
            SingleChildScrollView(
              controller: logic.categoryScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [FilterView(), FilterLoading(), FilterVideoView()],
              ),
            ),
            // Positioned(
            //   top: 0,
            //   left: 0,
            //   right: 20,
            //   bottom: 30,
            //   child: Container(
            //     height: 40,
            //     width: 40,
            //     decoration: BoxDecoration(color: AppColor.primaryColor, shape: BoxShape.circle),
            //     child: Icon(
            //       Icons.arrow_upward_sharp,
            //       size: 20,
            //     ),
            //   ),
            // )
          ],
        );
      },
    );
  }
}

class FilterView extends StatelessWidget {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilterController>(
        id: Constant.onGetFilter,
        builder: (controller) {
          return Container(
              padding: EdgeInsets.all(10),
              child: GetBuilder<HomeController>(
                builder: (homeController) {
                  final categories = homeController.allCategoryModel?.data ?? [];
                  final languages = homeController.languageListModel?.data ?? [];

                  return Container(
                    color: AppColor.colorBlack,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildFilterRow(
                          title: "Categories",
                          items: ['All', ...categories.map((e) => e.name ?? '')],
                          selectedItems: controller.selectedCategoryIds,
                          onTap: (item, index) {
                            if (index == 0) {
                              // All selected
                              controller.selectedCategoryIds.clear();
                            } else {
                              controller.selectedCategoryIds.clear();
                              final categoryId = categories[index - 1].id ?? '';
                              controller.selectedCategoryIds.add(categoryId);
                            }
                            controller.applyNewFilters(
                                categories: controller.selectedCategoryIds, languages: controller.selectedLanguageIds, sort: controller.selectedSort);

                            controller.update([Constant.onGetFilter]);
                          },
                          categoryIds: categories.map((e) => e.id ?? '').toList(),
                        ),

                        // Languages Row
                        buildFilterRow(
                          title: "Languages",
                          items: ['All', ...languages.map((e) => e.name ?? '')],
                          selectedItems: controller.selectedLanguageIds,
                          onTap: (item, index) {
                            if (index == 0) {
                              // All selected
                              controller.selectedLanguageIds.clear();
                            } else {
                              controller.selectedLanguageIds.clear();
                              final languageId = languages[index - 1].id ?? '';
                              controller.selectedLanguageIds.add(languageId);
                            }
                            controller.applyNewFilters(
                                categories: controller.selectedCategoryIds, languages: controller.selectedLanguageIds, sort: controller.selectedSort);

                            controller.update([Constant.onGetFilter]);
                          },
                          categoryIds: languages.map((e) => e.id ?? '').toList(),
                        ),

                        // Sort Row
                        buildFilterRow(
                          title: "Sort By",
                          items: ['Popular', 'Latest'],
                          selectedItems: {controller.selectedSort},
                          onTap: (item, index) {
                            controller.selectedSort = item.toLowerCase();
                            controller.applyNewFilters(
                                categories: controller.selectedCategoryIds, languages: controller.selectedLanguageIds, sort: controller.selectedSort);
                            controller.update([Constant.onGetFilter]);
                          },
                          categoryIds: [],
                          isSingleSelect: true,
                        ),
                      ],
                    ),
                  );
                },
              ));
        });
  }

  Widget buildFilterRow({
    required String title,
    required List<String> items,
    required Set<String> selectedItems,
    required Function(String item, int index) onTap,
    required List<String> categoryIds,
    bool isSingleSelect = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isAll = index == 0;

                bool isSelected;
                if (isSingleSelect) {
                  isSelected = selectedItems.contains(item.toLowerCase());
                } else if (isAll) {
                  isSelected = selectedItems.isEmpty;
                } else {
                  final itemId = categoryIds.isNotEmpty && index > 0 ? categoryIds[index - 1] : '';
                  isSelected = selectedItems.contains(itemId);
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onTap(item, index),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColor.primaryGradient : null,
                        color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.white24,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        item,
                        style: AppFontStyle.styleW600(
                          isSelected ? Colors.white : Colors.white70,
                          14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterVideoView extends StatelessWidget {
  const FilterVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GetBuilder<FilterController>(
      id: Constant.onGetFilter,
      builder: (logic) {
        if (logic.videos.isEmpty) {
          return SizedBox(height: Get.height * 0.5, child: Center(child: NoDataWidget(text: EnumLocal.nothingHereYetTxt.name.tr)));
        }

        return MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 8,
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          itemCount: logic.videos.length,
          itemBuilder: (context, index) {
            return FilterItemView(
              filterData: logic.videos[index],
            );
          },
        );
      },
    );
  }
}

class FilterLoading extends StatelessWidget {
  const FilterLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GetBuilder<FilterController>(
      id: Constant.onGetFilter,
      builder: (logic) {
        if (logic.isLoading) {
          return Center(
            child: LoadingAnimationWidget.halfTriangleDot(
              color: AppColor.colorPrimary,
              size: 30,
            ),
          );
        }

        return SizedBox();
      },
    );
  }
}
