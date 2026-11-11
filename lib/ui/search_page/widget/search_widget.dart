import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/shimmer/search_item_shmmer.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/home_page/model/trending_movie_series_model.dart';
import 'package:story_box/ui/search_page/api/search_movie_series_api.dart';
import 'package:story_box/ui/search_page/controller/search_screen_controller.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';

class SearchTextField extends StatelessWidget {
  final VoidCallback onSearch;

  SearchTextField({
    super.key,
    required this.onSearch,
  });

  final controller = Get.find<SearchScreenController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColor.colorWhite),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Obx(
            () => TextFormField(
              controller: controller.searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade900,
                hintText: EnumLocal.searchByTitleTheme.name.tr,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.primaryColor),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  color: AppColor.colorWhite,
                  onPressed: onSearch,
                ),
                suffixIcon: controller.searchText.value
                    ? GestureDetector(
                        onTap: () {
                          controller.clearSearch();
                          controller.update([
                            Constant.idMostTrending,
                            'searchResults',
                          ]);
                        },
                        child: const Icon(Icons.close))
                    : null,
              ),
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  controller.saveSearch(value);
                }
              },
              onChanged: (value) {
                controller.searchContent(value);
                controller.update();
              },
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchBuilder extends StatelessWidget {
  const SearchBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchScreenController>(
      id: 'searchResults',
      builder: (controller) {
        if (controller.isSearching) {
          return const SearchItemShimmer();
        }
        if (controller.searchController.text.isNotEmpty && controller.searchResults.isEmpty) {
          // nothing published matches: keep searching further (looks the same as the normal search)
          if (controller.isDiscovering) return const SearchItemShimmer();
          if (controller.discovered.isNotEmpty) return DiscoveredResults(controller: controller);
          return Center(
              child: Text(
            EnumLocal.noResultsFound.name.tr,
            style: AppFontStyle.styleW800(AppColor.colorIconGrey, 14),
          ));
        }
        return controller.searchController.text.isEmpty
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.searchHistory.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              EnumLocal.searchHistory.name.tr,
                              style: AppFontStyle.styleW800(AppColor.colorWhite, 22),
                            ),
                            16.height,
                            if (!controller.isShowClearHistory)
                              GestureDetector(
                                onTap: () {
                                  controller.onDeleteButtonClick();
                                },
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white54,
                                  size: 22,
                                ),
                              )
                            else
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.isShowClearHistory = false;
                                      controller.update(['searchResults', 'searchHistory']);
                                    },
                                    child: Text(
                                      EnumLocal.cancel.name.tr,
                                      style: AppFontStyle.styleW800(AppColor.colorWhite, 16),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                    child: VerticalDivider(
                                      color: AppColor.greyColor,
                                      thickness: 1,
                                      width: 26,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.clearAllHistory();
                                    },
                                    child: Text(
                                      EnumLocal.clearAll.name.tr,
                                      style: AppFontStyle.styleW800(AppColor.primaryColor, 16),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        16.height,
                        const SearchHistoryChips(),
                        16.height,
                      ],
                      // 16.height,
                      GetBuilder<SearchScreenController>(
                          id: Constant.idMostTrending,
                          builder: (controller) {
                            return controller.mostSearchedList.isEmpty
                                ? SizedBox()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        EnumLocal.txtMostSearched.name.tr,
                                        style: AppFontStyle.styleW800(AppColor.colorWhite, 22),
                                      ),
                                      // 5.height,
                                      const MostSearched(),
                                      // 5.height,
                                    ],
                                  );
                          }),

                      GetBuilder<HomeController>(
                        id: Constant.idMostTrending,
                        builder: (logic) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                EnumLocal.txtRecommendedForYou.name.tr,
                                style: AppFontStyle.styleW800(AppColor.colorWhite, 22),
                              ).paddingOnly(bottom: 16),
                              GetBuilder<HomeController>(
                                builder: (logic) {
                                  final int itemCount = logic.trendingMovieSeriesModel?.data?.length ?? 0;
                                  final int gridItemCount = (itemCount / 2).ceil(); // Calculate rows needed

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: gridItemCount,
                                    itemBuilder: (context, rowIndex) {
                                      final int leftIndex = rowIndex * 2;
                                      final int rightIndex = leftIndex + 1;

                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              // Left item
                                              Expanded(
                                                child: leftIndex < itemCount
                                                    ? Builder(
                                                        builder: (context) {
                                                          final data = logic.trendingMovieSeriesModel?.data?[leftIndex] ?? TrendingMoviesSeriesData();
                                                          return SearchItemView(
                                                            data: data,
                                                            isShowCategory: true,
                                                            index: leftIndex + 1,
                                                          );
                                                        },
                                                      )
                                                    : const SizedBox.shrink(),
                                              ),
                                              const SizedBox(width: 16),
                                              // Right item
                                              Expanded(
                                                child: rightIndex < itemCount
                                                    ? Builder(
                                                        builder: (context) {
                                                          final data = logic.trendingMovieSeriesModel?.data?[rightIndex] ?? TrendingMoviesSeriesData();
                                                          return SearchItemView(
                                                            data: data,
                                                            isShowCategory: true,
                                                            index: rightIndex + 1,
                                                          );
                                                        },
                                                      )
                                                    : const SizedBox.shrink(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      EnumLocal.peopleAreSearching.name.tr,
                      style: AppFontStyle.styleW800(AppColor.colorIconGrey, 22),
                    ).paddingOnly(top: 10, left: 16, bottom: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.searchResults.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = controller.searchResults[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.episodeWiseReels,
                                arguments: {
                                  "movieSeriesId": data.sId ?? "",
                                  "totalVideos": 0,
                                },
                              );

                              SearchMovieSeriesApi.callApi(loginUserId: Preference.userId, query: data.name ?? "", movieSeriesId: data.sId ?? "");
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    height: 140,
                                    width: 110,
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: data.thumbnail ?? '',
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                          placeholder: (context, url) => Center(
                                            child: Image.asset(
                                              AppAsset.placeHolderImage,
                                              color: AppColor.colorIconGrey,
                                            ).paddingAll(16),
                                          ),
                                          errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppColor.colorBlack.withValues(alpha: 0.6),
                                                  AppColor.colorBlack.withValues(alpha: 0.3),
                                                  AppColor.colorBlack.withValues(alpha: 0),
                                                ],
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                              ),
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(4.0),
                                                bottomRight: Radius.circular(4.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        data.name ?? '',
                                        style: AppFontStyle.styleW600(AppColor.colorWhite, 16),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryColor.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          capitalizeFirstLetter(data.category ?? ''),
                                          style: AppFontStyle.styleW500(AppColor.primaryColor, 11),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        data.description ?? '',
                                        style: AppFontStyle.styleW500(AppColor.colorIconGrey, 13),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ).paddingSymmetric(horizontal: 10),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }
}

/// Titles found beyond the published catalogue; tapping one gets it ready and opens it.
class DiscoveredResults extends StatelessWidget {
  final SearchScreenController controller;
  const DiscoveredResults({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            EnumLocal.peopleAreSearching.name.tr,
            style: AppFontStyle.styleW800(AppColor.colorIconGrey, 22),
          ).paddingOnly(top: 10, left: 16, bottom: 16),
          for (final data in controller.discovered)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.openDiscovered(data),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 140,
                        width: 110,
                        child: data.thumbnail.isEmpty
                            ? Container(color: AppColor.colorLightBlack, child: Image.asset(AppAsset.placeHolderImage, color: AppColor.colorIconGrey).paddingAll(16))
                            : CachedNetworkImage(
                                imageUrl: data.thumbnail,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(child: Image.asset(AppAsset.placeHolderImage, color: AppColor.colorIconGrey).paddingAll(16)),
                                errorWidget: (context, url, error) => Container(color: AppColor.colorLightBlack),
                              ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(data.name, style: AppFontStyle.styleW600(AppColor.colorWhite, 16), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(children: [
                            if (data.category.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: AppColor.primaryColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(5)),
                                child: Text(data.category, style: AppFontStyle.styleW500(AppColor.primaryColor, 11)),
                              ),
                            if (data.totalEpisodes > 0) Text("${data.totalEpisodes} episodes", style: AppFontStyle.styleW500(AppColor.colorIconGrey, 11)),
                          ]),
                          const SizedBox(height: 6),
                          Text(data.description, style: AppFontStyle.styleW500(AppColor.colorIconGrey, 13), maxLines: 3, overflow: TextOverflow.ellipsis),
                        ],
                      ).paddingSymmetric(horizontal: 10),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SearchItemView extends StatelessWidget {
  final TrendingMoviesSeriesData data;
  final bool isShowCategory;
  final int index;

  const SearchItemView({
    super.key,
    required this.data,
    this.isShowCategory = false,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(
            AppRoutes.episodeWiseReels,
            arguments: {
              "movieSeriesId": data.id ?? "",
              "totalVideos": 0,
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 0.785, // 110/140 ratio for maintaining the same proportions
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: data.thumbnail ?? '',
                      placeholder: (context, url) => Center(
                        child: Image.asset(
                          AppAsset.placeHolderImage,
                          color: AppColor.colorIconGrey,
                        ).paddingAll(16),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColor.colorTextRed),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   left: 0,
                    //   child: ClipPath(
                    //     clipper: BadgeTriangleClipper(),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         gradient: getGradientForIndex(index),
                    //       ),
                    //       width: 30,
                    //       height: 30,
                    //     ),
                    //   ),
                    // ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.colorBlack.withValues(alpha: 0.6),
                              AppColor.colorBlack.withValues(alpha: 0.3),
                              AppColor.colorBlack.withValues(alpha: 0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(4.0),
                            bottomRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            6.height,
            Text(
              data.name ?? '',
              style: AppFontStyle.styleW600(AppColor.colorWhite, 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchHistoryChips extends StatelessWidget {
  const SearchHistoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchScreenController>(
      id: 'searchHistory',
      builder: (controller) {
        return Wrap(
          spacing: 8.0,
          children: controller.searchHistory.map((term) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: AppColor.colorWhite.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColor.colorWhite.withValues(alpha: 0.2),
                  )),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.searchController.text = term;
                      controller.searchContent(term);
                    },
                    child: Text(
                      term,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (controller.isShowClearHistory) ...[
                    6.width,
                    GestureDetector(
                      onTap: () {
                        controller.deleteHistoryItem(term);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColor.colorIconGrey),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class MostSearched extends StatelessWidget {
  const MostSearched({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchScreenController>(
      id: Constant.idMostTrending,
      builder: (controller) {
        if (controller.mostSearchedList.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 100, // Enough for exactly 2 rows (40 + 40 + spacing)
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First row
                buildRow(controller.mostSearchedList, startIndex: 0),
                10.height,
                // Second row
                buildRow(controller.mostSearchedList, startIndex: 1),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildRow(List<dynamic> list, {required int startIndex}) {
    final items = <Widget>[];
    for (int i = startIndex; i < list.length; i += 2) {
      final item = list[i];
      String title = item.movieSeriesId?.name;

      items.add(
        IntrinsicWidth(
          // Makes chip only as wide as its text (looks cleaner)
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Get.find<SearchScreenController>().searchController.text = title;
                Get.find<SearchScreenController>().searchContent(title);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1.2,
                  ),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColor.colorWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Add spacing between chips (except after last one)
      if (i + 2 < list.length) {
        items.add(10.width);
      }
    }

    return Row(children: items);
  }
}
