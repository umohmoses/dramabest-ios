import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/custom_widget/custom_gradiant_text.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/shimmer/new_release_shimmer.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/home_page/model/get_all_movie_ranking_model.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/font_style.dart';

///   ------------>>>>>> New Release View <<<<<<<<<<-------------

class AllRankingBuilderView extends StatelessWidget {
  const AllRankingBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (logic) {
        return SizedBox(
          height: Get.height,
          child: logic.isLoadingMostTrending
              ? const NewReleaseShimmer()
              : ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  itemCount: logic.allMovieRankingModel!.trending?.length ?? 0,
                  itemBuilder: (context, index) {
                    final trending = logic.allMovieRankingModel!.trending![index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AllRankingItemView(
                        index: index,
                        trending: trending,
                        view: trending.views.toString(),
                      ),
                    );
                  },
                ).paddingSymmetric(horizontal: 16),
        );
      },
    );
  }
}

class AllRankingItemView extends StatelessWidget {
  final Trending trending;
  // final TrendingMoviesSeriesData trending;
  final int index;
  final String view;

  const AllRankingItemView({
    super.key,
    required this.trending,
    required this.index,
    required this.view,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.episodeWiseReels,
          arguments: {
            "movieSeriesId": trending.id ?? "",
            "totalVideos": 0,
          },
        );
      },
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                // Movie Thumbnail Image

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    memCacheWidth: 540, // decode list posters at tile size: same look, less memory, smoother scrolling
                    imageUrl: trending.movie?.thumbnail ?? " ",
                    placeholder: (context, url) => Image.asset(
                      AppAsset.placeHolderImage,
                      color: AppColor.colorIconGrey,
                    ).paddingAll(12),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                    fit: BoxFit.cover,
                  ),
                ),
                // Triangle Badge
                Container(
                  height: 23,
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 6),
                  alignment: Alignment.center,
                  decoration: index < 3
                      ? BoxDecoration(gradient: AppColor.primaryGradient, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topLeft: Radius.circular(10)))
                      : BoxDecoration(
                          color: AppColor.colorWhite.withAlpha(90), borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topLeft: Radius.circular(10))),
                  child: Text(
                    "${index + 1}",
                    style: AppFontStyle.styleW800(AppColor.colorWhite, index < 10 ? 14 : 12),
                  ),
                )
              ],
            ),
            4.width,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trending.movie?.name ?? "",
                            style: AppFontStyle.styleW800(AppColor.colorWhite, 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              AppAsset.icViews,
                              height: 13,
                              width: 13,
                            ),
                            3.width,
                            GradientText(
                                text: (view).toString(),
                                style: TextStyle(fontFamily: Constant.appFontFamily, fontSize: 16, fontWeight: FontWeight.w800),
                                gradient: AppColor.viewsGradient)
                          ],
                        )
                      ],
                    ),
                    // const Spacer(),
                    Text(
                      trending.movie?.description ?? "",
                      style: TextStyle(
                          fontFamily: Constant.appFontFamily, fontWeight: FontWeight.w700, fontSize: 12, color: AppColor.colorWhite.withValues(alpha: 0.7), height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Row(
                    //   children: [
                    //     Container(
                    //       padding: EdgeInsets.all(3),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(6),
                    //         border: Border.all(color: AppColor.colorWhite.withAlpha(51)),
                    //         color: AppColor.colorWhite.withAlpha(25),
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Image.asset(
                    //             AppAsset.icLanguage,
                    //             height: 15,
                    //             width: 15,
                    //           ),
                    //           5.width,
                    //           Text(
                    //             (trending.movie?.languageName?.isNotEmpty ?? false) ? trending.movie?.languageName ?? "" : "Hindi",
                    //             style: AppFontStyle.styleW600(AppColor.colorWhite.withValues(alpha: 0.7), 11),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
