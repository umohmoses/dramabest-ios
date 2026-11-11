import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/shimmer/new_release_shimmer.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/home_page/model/new_releases_video_model.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

import '../../episode_wise_reels_page/widget/episode_wise_reels_widget.dart';

///   ------------>>>>>> New Release View <<<<<<<<<<-------------

class NewReleaseBuilderView extends StatelessWidget {
  const NewReleaseBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (logic) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    Text(
                      EnumLocal.newRelease.name.tr,
                      style: AppFontStyle.styleW800(AppColor.colorWhite, 26),
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              GetBuilder<HomeController>(
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
                    itemCount: logic.newReleasesVideoModel!.videos!.length,
                    itemBuilder: (context, index) {
                      final video = logic.newReleasesVideoModel!.videos![index];
                      return NewReleaseItemView(
                        newReleasesVideos: video,
                      );
                    },
                  );
                },
              )
              // Expanded(
              //   child: logic.isLoadingMostTrending
              //       ? const NewReleaseShimmer()
              //       : LayoutBuilder(
              //           builder: (context, constraints) {
              //             // ✅ Dynamic item size calculation
              //             final double itemWidth = (constraints.maxWidth - 48) / 2;
              //             final double itemHeight = Get.height < 700
              //                 ? Get.height * 0.36 // Small devices
              //                 : Get.height * 0.30; // Large devices
              //
              //             final double aspectRatio = itemWidth / itemHeight;
              //
              //             return GridView.builder(
              //               padding: const EdgeInsets.fromLTRB(0, 8, 0, 30),
              //               physics: const BouncingScrollPhysics(),
              //               shrinkWrap: true,
              //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //                 crossAxisCount: 2,
              //                 mainAxisExtent: 250, // ✅ Fully responsive now
              //                 crossAxisSpacing: 16,
              //                 mainAxisSpacing: 10,
              //               ),
              //               itemCount: logic.newReleasesVideoModel?.videos?.length ?? 0,
              //               itemBuilder: (context, index) {
              //                 final video = logic.newReleasesVideoModel!.videos![index];
              //
              //                 return NewReleaseItemView(
              //                   newReleasesVideos: video,
              //                 );
              //               },
              //             );
              //           },
              //         ),
              // )
            ],
          ),
        );
      },
    );
  }
}

///   ------------>>>>>> New Release Item View <<<<<<<<<<-------------

class NewReleaseItemView extends StatelessWidget {
  final NewReleasesVideos newReleasesVideos;

  const NewReleaseItemView({super.key, required this.newReleasesVideos});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.episodeWiseReels,
          arguments: {
            "movieSeriesId": newReleasesVideos.id ?? "",
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
                width: 180,
                child: Stack(
                  children: [
                    // Image
                    CachedNetworkImage(
                      memCacheWidth: 540, // decode list posters at tile size: same look, less memory, smoother scrolling
                      imageUrl: newReleasesVideos.thumbnail ?? "",
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
                              Text(CustomFormatNumber.convert(newReleasesVideos.views?.toInt() ?? 0), style: AppFontStyle.styleW800(AppColor.colorWhite, 13)),
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
            const SizedBox(
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                newReleasesVideos.name ?? "",
                style: AppFontStyle.styleW800(AppColor.colorWhite, 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Container(
              padding: EdgeInsets.all(3),
              margin: EdgeInsets.only(left: 4, bottom: 5),
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
                    newReleasesVideos.languageName ?? "",
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
