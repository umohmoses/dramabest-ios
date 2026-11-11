import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/shimmer/new_release_shimmer.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/home_page/explore/explore_controller.dart';
import 'package:story_box/ui/home_page/explore/explore_widgets.dart';
import 'package:story_box/ui/home_page/model/get_movies_grouped_by_category_model.dart';
import 'package:story_box/ui/home_page/widget/home_widget.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

import '../../episode_wise_reels_page/widget/episode_wise_reels_widget.dart';

class ExploreWidget extends StatelessWidget {
  const ExploreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      // dragging near the end loads the next "You Might Like" categories
      return NotificationListener<ScrollNotification>(
        onNotification: (n) => loadNearEnd(n, ExploreController.to.loadMoreYouMightLike),
        child: SingleChildScrollView(
        child: Column(
          children: [
            const CarouselBlurBackground(),
            Container(
              height: 40,
              width: Get.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(spreadRadius: 30, offset: Offset(5, 10), blurStyle: BlurStyle.normal, blurRadius: 50, color: AppColor.colorBlack.withValues(alpha: 0.8))
                ],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColor.colorBlack.withValues(alpha: 0.1),
                    AppColor.colorBlack.withValues(alpha: 0.3),
                    AppColor.colorBlack.withValues(alpha: 0.6),
                    AppColor.colorBlack.withValues(alpha: 0.85),
                    AppColor.colorBlack,
                  ],
                  stops: const [0.0, 0.1, 0.3, 0.6, 0.85, 1.0],
                ),
              ),
            ),
            Container(
              color: AppColor.colorBlack,
              child: Column(
                children: [
                  const ExploreTrendingSection(), // 9 trending today / this week / this month
                  ContinueWatchingBuilderView(),
                  const YouMightLikeSection(), // 7 trending titles per category, grows as you drag down
                  120.height
                ],
              ),
            ),
          ],
        ),
      ),
      );
    });
  }
}

class GroupBuilderView extends StatelessWidget {
  const GroupBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (logic) {
        if (logic.isLoadingMostTrending || logic.allMovies.isEmpty) {
          return const NewReleaseShimmer();
        }

        return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 8,
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          itemCount: logic.allMovies.length,
          itemBuilder: (context, index) {
            return GroupItemView(movies: logic.allMovies[index]);
          },
        );
      },
    );
  }
}

///   ------------>>>>>> New Release Item View <<<<<<<<<<-------------

class GroupItemView extends StatelessWidget {
  final Movies movies;

  const GroupItemView({super.key, required this.movies});

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
      child: Container(
        decoration: BoxDecoration(color: AppColor.colorLightBlack, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: SizedBox(
                height: 180,
                width: 200,
                child: Stack(
                  children: [
                    // Image
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
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.zero,
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.zero,
                              topRight: Radius.circular(10),
                            ),
                            color: AppColor.colorButtonPink),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                          child: Text(EnumLocal.newText.name.tr, style: AppFontStyle.styleW800(AppColor.colorWhite, 10)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [AppColor.colorBlack.withValues(alpha: 0.6), AppColor.colorBlack.withValues(alpha: 0.3), AppColor.colorBlack.withValues(alpha: 0)],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter),
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(4.0), bottomRight: Radius.circular(4.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                AppAsset.icViews,
                                height: 12,
                                width: 12,
                                color: AppColor.colorWhite,
                              ),
                              5.width,
                              Text(CustomFormatNumber.convert(movies.totalViews?.toInt() ?? 0), style: AppFontStyle.styleW800(AppColor.colorWhite, 13)),
                              10.width
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            6.height,
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                movies.name ?? "",
                // style: AppFontStyle.styleW800(AppColor.colorWhite, 13,),
                style: TextStyle(height: 1.2, color: AppColor.colorWhite, fontSize: 13, fontFamily: Constant.appFontFamily, fontWeight: FontWeight.w800),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            6.height,
            Container(
              padding: EdgeInsets.all(3),
              margin: EdgeInsets.only(left: 5, bottom: 5),
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
                    movies.languageName ?? "",
                    style: AppFontStyle.styleW600(AppColor.colorWhite.withValues(alpha: 0.7), 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
