import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:story_box/custom_widget/filter_widget.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/shimmer/carousel_shimmer.dart';
import 'package:story_box/shimmer/most_trending_shimmer.dart';
import 'package:story_box/shimmer/new_release_shimmer.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/home_page/explore/explore_controller.dart';
import 'package:story_box/ui/home_page/model/get_movies_grouped_by_category_model.dart';
import 'package:story_box/ui/home_page/model/trending_movie_series_model.dart';
import 'package:story_box/ui/home_page/view/view_all_page.dart';
import 'package:story_box/utils/app_button.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/dummy_data.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/guest_gate.dart';
import 'package:story_box/utils/utils.dart';

///   ------------>>>>>> Home App Bar <<<<<<<<<<-------------
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return SliverAppBar(
          backgroundColor: Colors.black.withValues(alpha: controller.appBarOpacity),
          pinned: true,
          expandedHeight: 98.0,
          toolbarHeight: 98,
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ClipRect(
                child: Container(
                  // color: Colors.black.withValues(alpha: controller.appBarOpacity),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 14.0,
                      top: 25.0,
                      left: 14.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          EnumLocal.txtAppName.name.tr,
                          style: AppFontStyle.styleW800(AppColor.colorWhite, 26),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              if (GuestGate.allow()) Get.toNamed(AppRoutes.rewards);
                            },
                            child: Lottie.asset(AppAsset.lottieGift, height: 45, width: 45)),
                        4.width,
                        GestureDetector(
                            onTap: () {
                              showFilterBottomSheet(context);
                            },
                            child: Image.asset(AppAsset.icFilter, width: 28, color: AppColor.colorWhite)),
                      ],
                    ),
                        6.height,
                        const HomeSearchBar(), // full-width search bar right under the app name
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

///   ------------>>>>>> Search bar (opens the search page; the hint cycles through trending titles) <<<<<<<<<<-------------
class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  Timer? timer;
  int hint = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted && ExploreController.to.trending.length > 1) setState(() => hint++);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final names = ExploreController.to.trending.map((t) => t.name).where((n) => n.isNotEmpty).toList();
    final text = names.isEmpty ? "Search dramas" : names[hint % names.length];
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.search),
      child: Container(
        height: 38,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColor.colorWhite.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(AppAsset.icSearch, width: 18, color: AppColor.colorWhite.withValues(alpha: 0.6)),
            10.width,
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Text(
                  text,
                  key: ValueKey(text),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.styleW500(AppColor.colorWhite.withValues(alpha: 0.55), 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///   ------------>>>>>> Carousel <<<<<<<<<<-------------
class CarouselImageView extends StatelessWidget {
  const CarouselImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: Constant.idHomeCarousel,
      builder: (logic) {
        final movies = logic.getMoviesSeriesModel?.data;

        if (movies == null || movies.isEmpty) {
          return const CarouselShimmer();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider(
              carouselController: logic.controller,
              items: movies.map((movie) {
                if (movie.thumbnail == null) {
                  // Handle null thumbnail case
                  return Center(
                    child: Text(
                      EnumLocal.noImage.name.tr,
                      style: const TextStyle(color: AppColor.colorWhite),
                    ),
                  );
                }
                return Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: AppColor.colorWhite.withValues(alpha: 0.4),
                            width: 1.0,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.episodeWiseReels,
                              arguments: {
                                "movieSeriesId": movie.id ?? "",
                                "totalVideos": 0,
                              },
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: CachedNetworkImage(
                              imageUrl: movie.thumbnail!,
                              placeholder: (context, url) => Image.asset(
                                AppAsset.placeHolderImage,
                                // fit: BoxFit.cover,
                                height: 40, width: 50,
                                color: AppColor.colorIconGrey,
                              ),
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColor.colorTextRed),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: Get.height * 0.40,
                viewportFraction: 0.7,

                enlargeStrategy: CenterPageEnlargeStrategy.scale,
                autoPlay: true,
                // enlargeCenterPage: true,

                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  logic.onPageChanged(index, reason);
                },
              ),
            ),
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: movies.asMap().entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(left: 3, right: 3, top: 12),
                  height: logic.initialPage == entry.key ? 4 : 3,
                  width: logic.initialPage == entry.key ? 22 : 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: logic.initialPage == entry.key ? AppColor.colorTextRed : Colors.white.withAlpha(51),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

/// ------------>>>>>> Carousel Blur Background <<<<<<<<----------------

class CarouselBlurBackground extends StatelessWidget {
  const CarouselBlurBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: Constant.idHomeBlurCarousel,
      builder: (logic) {
        return const Padding(
          padding: EdgeInsets.only(top: 18.0),
          child: CarouselImageView(),
        );
      },
    );
  }
}

/// ------------>>>>>> Top Tab Bar Background <<<<<<<<----------------

class TopTabBar extends StatelessWidget {
  const TopTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List tabTitles = [EnumLocal.txtExplore.name.tr, EnumLocal.txtNew.name.tr, EnumLocal.txtCategories.name.tr, EnumLocal.txtRanking.name.tr];
    return GetBuilder<HomeController>(
      id: Constant.onChangeTab,
      builder: (controller) {
        return Container(
          color: Colors.black.withValues(alpha: controller.appBarOpacity),
          padding: EdgeInsetsGeometry.only(bottom: 6, left: 6, right: 6),
          height: 36,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tabTitles.length,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => controller.onTapChangeTab(index),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                          child: Align(
                            alignment: Alignment.center,
                            child: controller.selectedTabIndex == index
                                ? ShaderMask(
                                    shaderCallback: (bounds) => AppColor.primaryGradient.createShader(bounds),
                                    child: Text(
                                      tabTitles[index],
                                      style: AppFontStyle.styleW700(AppColor.colorWhite, 18).copyWith(color: AppColor.colorWhite),
                                    ),
                                  )
                                : Text(
                                    tabTitles[index],
                                    style: AppFontStyle.styleW600(AppColor.colorWhite.withValues(alpha: 0.7), 18),
                                  ),
                          ),
                        ),
                        2.height,
                        Visibility(
                          visible: controller.selectedTabIndex == index,
                          child: Container(
                            height: 3,
                            width: controller.selectedTabIndex == 0
                                ? 30
                                : controller.selectedTabIndex == 1
                                    ? 20
                                    : controller.selectedTabIndex == 2
                                        ? 40
                                        : 30,
                            decoration: controller.selectedTabIndex == index
                                ? BoxDecoration(gradient: AppColor.primaryGradient, borderRadius: BorderRadius.circular(10))
                                : BoxDecoration(
                                    color: AppColor.colorWhite,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

///   ------------>>>>>> Most Trending View <<<<<<<<<<-------------

class MostTrendingBuilderView extends StatelessWidget {
  MostTrendingBuilderView({super.key});

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    if (homeController.trendingMovieSeriesModel?.data != null && homeController.trendingMovieSeriesModel!.data!.isNotEmpty) {
      const SizedBox.shrink();
    }
    return GetBuilder<HomeController>(
      id: Constant.idMostTrending,
      builder: (logic) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${EnumLocal.mostTrending.name.tr} 🚀",
              style: AppFontStyle.styleW800(AppColor.colorWhite, 24),
            ),
            10.height,
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    AppColor.colorButtonPink.withValues(alpha: 0.2),
                    AppColor.colorBlack.withValues(alpha: 0.1),
                    AppColor.colorBlack.withValues(alpha: 0.2),
                    AppColor.colorBlack.withValues(alpha: 0.0)
                  ],
                ),
              ),
              height: Get.height * 0.4,
              child: logic.isLoadingMostTrending
                  ? const MostTrendingShimmer()
                  : GridView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: logic.trendingMovieSeriesModel?.data?.length ?? 0,
                      itemBuilder: (context, index) => GetBuilder<HomeController>(
                        builder: (logic) {
                          return MostTrendingItemView(
                            language: logic.trendingMovieSeriesModel?.data?[index].language?.name ?? "",
                            view: logic.trendingMovieSeriesModel?.data?[index].viewsLabel ?? "",
                            index: index + 1,
                            trendingMoviesSeriesData: logic.trendingMovieSeriesModel?.data?[index] ?? TrendingMoviesSeriesData(),
                          );
                        },
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of rows
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 200, // Width of each item
                      ),
                    ),
            ),
          ],
        ).paddingOnly(left: 12, bottom: 18);
      },
    );
  }
}

///   ------------>>>>>> Most Trending Item View <<<<<<<<<<-------------

class MostTrendingItemView extends StatelessWidget {
  final TrendingMoviesSeriesData trendingMoviesSeriesData;
  final int index;
  final String view;
  final String language;

  const MostTrendingItemView({super.key, required this.trendingMoviesSeriesData, required this.index, required this.view, required this.language});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.episodeWiseReels,
          arguments: {
            "movieSeriesId": trendingMoviesSeriesData.id ?? "",
            "totalVideos": 0,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // Movie Thumbnail Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    memCacheWidth: 540, // decode list posters at tile size: same look, less memory, smoother scrolling
                    imageUrl: trendingMoviesSeriesData.thumbnail ?? " ",
                    placeholder: (context, url) => Image.asset(
                      AppAsset.placeHolderImage,
                      color: AppColor.colorIconGrey,
                    ).paddingAll(12),
                    errorWidget: (context, url, error) => Icon(Icons.error, color: AppColor.colorTextRed),
                    height: 110,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                // Triangle Badge
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: ClipPath(
                    clipper: BadgeTriangleClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: getGradientForIndex(index),
                      ),
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                // Text Half on Triangle and Half on Image
                Positioned(
                  bottom: index <= 3 ? -14 : 1,
                  left: index <= 3
                      ? 2
                      : index >= 10
                          ? 1
                          : 5,
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: AppColor.colorWhite,
                      fontSize: index <= 3 ? 60 : 12,
                      fontWeight: index <= 3 ? FontWeight.bold : FontWeight.w400,
                      fontStyle: index <= 3 ? FontStyle.italic : FontStyle.normal,
                      shadows: index <= 3
                          ? [
                              Shadow(
                                offset: const Offset(1, 1),
                                blurRadius: 3,
                                color: index == 1
                                    ? AppColor.mostTrending1
                                    : index == 2
                                        ? AppColor.mostTrending2
                                        : AppColor.mostTrending3,
                              ),
                            ]
                          : [],
                    ),
                  ),
                ),
              ],
            ),
            4.width,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trendingMoviesSeriesData.name ?? "",
                      style: AppFontStyle.styleW800(AppColor.colorWhite, 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Hidden when a title has no language set, rather than showing a guess.
                    if (language.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColor.colorWhite.withAlpha(51)),
                          color: AppColor.colorWhite.withAlpha(25),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppAsset.icLanguage,
                              height: 15,
                              width: 15,
                            ),
                            5.width,
                            Text(
                              language,
                              style: AppFontStyle.styleW600(AppColor.colorWhite.withValues(alpha: 0.7), 11),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          view,
                          style: AppFontStyle.styleW600(AppColor.colorWhite.withValues(alpha: 0.7), 11),
                        ),
                        Text(
                          trendingMoviesSeriesData.category?.name ?? "",
                          style: AppFontStyle.styleW600(AppColor.colorWhite.withValues(alpha: 0.7), 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient getGradientForIndex(int index) {
    if (index == 1) {
      return const LinearGradient(
        colors: [Colors.orangeAccent, Colors.yellow],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (index == 2) {
      return const LinearGradient(
        colors: [Color(0xff64B5F6), Color(0xffE3F2FD)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (index == 3) {
      return const LinearGradient(
        colors: [Color(0xffEF9A9A), Color(0xffFFEBEE)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return const LinearGradient(
        colors: [
          AppColor.colorPrimary,
          AppColor.colorSecondary,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }
}

class BadgeTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double cornerRadius = 10.0;

    Path path = Path();
    path.moveTo(0, size.height - cornerRadius);
    path.quadraticBezierTo(0, size.height, cornerRadius, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BadgeTriangleClipper oldClipper) => false;
}

///   ------------>>>>>> Continue Watching View <<<<<<<<<<-------------

class ContinueWatchingBuilderView extends StatelessWidget {
  const ContinueWatchingBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: Constant.idGetHistory,
      builder: (homeController) {
        if (homeController.watchedVideos.isEmpty) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              EnumLocal.continueWatching.name.tr,
              style: AppFontStyle.styleW800(AppColor.colorWhite, 24),
            ),
            10.height,
            SizedBox(
              height: 225,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: homeController.watchedVideos.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ContinueWatchingItemView(
                    data: homeController.watchedVideos[index],
                  );
                },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 12);
      },
    );
  }
}

///   ------------>>>>>> Continue Watching Item View <<<<<<<<<<-------------

class ContinueWatchingItemView extends StatelessWidget {
  final dynamic data;

  const ContinueWatchingItemView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // double progressValue = 0.4;

    double progressValue = 0.0;
    int totalEpisodes = data['totalEpisodes'] ?? 0;
    int lastEpisode = data['lastEpisode'] ?? 0;

    if (totalEpisodes > 0) {
      progressValue = lastEpisode / totalEpisodes;
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.episodeWiseReels,
          arguments: {
            "movieSeriesId": data['id'] ?? "",
            "totalVideos": data['totalEpisodes'] ?? 0,
            "playIndex": data['lastEpisode'] ?? 0,
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 150,
                  width: 110,
                  child: Stack(
                    children: [
                      // Image
                      CachedNetworkImage(
                        memCacheWidth: 540, // decode list posters at tile size: same look, less memory, smoother scrolling
                        imageUrl: data['thumbnail'],
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
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                          child: const Icon(Icons.play_arrow_rounded, color: AppColor.colorWhite, size: 25),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColor.colorButtonPink),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              6.height,
              Flexible(
                child: Text(
                  data['title'],
                  style: AppFontStyle.styleW800(AppColor.colorWhite, 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'EP.${data['lastEpisode']}', style: AppFontStyle.styleW600(AppColor.colorButtonPink, 11)),
                    TextSpan(
                      text: '/EP.${data['totalEpisodes']}',
                      style: AppFontStyle.styleW600(AppColor.colorWhite, 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///   ------------>>>>>> Coming Soon Builder View <<<<<<<<<<-------------

class ComingSoonBuilderView extends StatelessWidget {
  const ComingSoonBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${EnumLocal.comingSoon.name.tr} 🌸",
          style: AppFontStyle.styleW800(AppColor.colorWhite, 24),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 285, // Set a fixed height for the ListView
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: DummyData.imageList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                // Normal item display
                return ComingSoonItemView(
                  image: DummyData.imageList[index],
                );
              }),
        ),
      ],
    ).paddingSymmetric(horizontal: 12);
  }
}

///   ------------>>>>>> Coming Soon Item View <<<<<<<<<<-------------

class ComingSoonItemView extends StatelessWidget {
  final String image;

  const ComingSoonItemView({super.key, this.image = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "2 Oct",
                  style: AppFontStyle.styleW400(AppColor.colorWhite, 12),
                ),
                const Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Divider(
                    thickness: 0.5,
                  ),
                )),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8), // Ensuring the image and progress bar have rounded corners
              child: SizedBox(
                height: 210, // Set height for each item if needed
                width: 140,
                child: Stack(
                  children: [
                    // Image
                    CachedNetworkImage(
                      imageUrl: image,
                      placeholder: (context, url) => Center(
                        child: Image.asset(
                          AppAsset.placeHolderImage,
                          color: AppColor.colorIconGrey,
                        ).paddingAll(16),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.colorBlack.withValues(alpha: 0.9),
                                AppColor.colorBlack.withValues(alpha: 0),
                              ],
                              stops: const [0.3, 0.9], // You can adjust these based on your design.
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(4.0), bottomRight: Radius.circular(4.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppButton(
                              backgroundColor: AppColor.colorWhite.withValues(alpha: 0.6),
                              icon: Icons.notifications_rounded,
                              iconColor: AppColor.colorWhite,
                              text: "Remind Me",
                              textColor: AppColor.colorWhite,
                              iconSize: 14,
                              textSize: 12,
                              borderRadius: 6.0,
                              onPressed: () {
                                // Add notify me button action here
                              },
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Flexible(
              child: Text(
                'The Virgin and The Billionaire',
                style: AppFontStyle.styleW800(AppColor.colorWhite, 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///   ------------>>>>>> Custom Category Wise Builder View <<<<<<<<<<-------------

class CustomCategoryWiseBuilderView extends StatelessWidget {
  final String title;
  final List<Movies> moviesList;
  final int maxItemsToShow;

  const CustomCategoryWiseBuilderView({
    super.key,
    required this.title,
    required this.moviesList,
    this.maxItemsToShow = 10, // Changed to show more items in grid
  });

  @override
  Widget build(BuildContext context) {
    final bool hasMoreItems = moviesList.length > maxItemsToShow;
    final int itemCount = hasMoreItems ? maxItemsToShow : moviesList.length;
    final int gridItemCount = (itemCount / 2).ceil(); // Calculate rows needed

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title.capitalizeFirst ?? '',
              style: AppFontStyle.styleW800(AppColor.colorWhite, 24),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.to(
                  () => ViewAllPage(
                    videos: moviesList.map((video) => video.toJson()).toList(),
                    title: title,
                  ),
                );
              },
              child: Container(
                color: AppColor.transparent,
                child: const Padding(
                  padding: EdgeInsets.only(left: 16, top: 5, bottom: 5),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.colorWhite,
                    size: 14,
                  ),
                ),
              ),
            )
          ],
        ),
        10.height,
        GetBuilder<HomeController>(
          builder: (logic) {
            return logic.isLoadingMostTrending
                ? const NewReleaseShimmer()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
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
                                child: leftIndex < itemCount ? CategoryWiseItemView(movies: moviesList[leftIndex]) : const SizedBox.shrink(),
                              ),
                              const SizedBox(width: 16),
                              // Right item
                              Expanded(
                                child: rightIndex < itemCount ? CategoryWiseItemView(movies: moviesList[rightIndex]) : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
        // Show more button if there are more items
        if (hasMoreItems)
          Center(
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => ViewAllPage(
                    videos: moviesList.map((video) => video.toJson()).toList(),
                    title: title,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: AppFontStyle.styleW600(AppColor.colorWhite, 14),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios, color: AppColor.colorWhite, size: 14),
                  ],
                ),
              ),
            ),
          ),
      ],
    ).paddingSymmetric(horizontal: 12);
  }
}

/// --------------->>>>>> Category Wise Item View <<<<<<<<<<<

class CategoryWiseItemView extends StatelessWidget {
  final Movies movies;

  const CategoryWiseItemView({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.episodeWiseReels,
          arguments: {
            "movieSeriesId": movies.id ?? "",
            "totalVideos": 0,
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 0.73, // Maintains a good movie poster ratio
              child: Stack(
                children: [
                  CachedNetworkImage(
                    memCacheWidth: 540, // decode list posters at tile size: same look, less memory, smoother scrolling
                    imageUrl: movies.thumbnail ?? "",
                    placeholder: (context, url) => Center(
                      child: Image.asset(
                        AppAsset.placeHolderImage,
                        color: AppColor.colorIconGrey,
                      ).paddingAll(16),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.play_arrow_rounded, color: AppColor.colorWhite, size: 22),
                            const SizedBox(width: 4),
                            Text(
                              CustomFormatNumber.convert(movies.totalViews?.toInt() ?? 0),
                              style: AppFontStyle.styleW800(AppColor.colorWhite, 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            movies.name ?? "",
            style: AppFontStyle.styleW800(AppColor.colorWhite, 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
