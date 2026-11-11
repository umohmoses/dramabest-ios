import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/custom_widget/no_data_widget.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/shimmer/my_list_shimmer.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/reels_page/api/create_favorite_video_api.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';
import 'package:vibration/vibration.dart';
import '../../reels_page/controller/reels_controller.dart';
import '../../reels_page/model/video.dart';

///   ------------>>>>>> My List View <<<<<<<<<<-------------

class MyListBuilderView extends StatelessWidget {
  MyListBuilderView({super.key});

  final ReelsController controller = Get.put(ReelsController());
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    controller.onGetFavVideo();
    return GetBuilder<ReelsController>(
      id: "onGetFavVideo",
      builder: (controller) {
        return controller.isLoadingMyList
            ? const MyListShimmer()
            : controller.favoriteVideos.isEmpty
                ? NoDataWidget(
                    text: EnumLocal.nothingHereYetTxt.name.tr,
                  )
                : GridView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: controller.favoriteVideos.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.56,
                    ),
                    itemBuilder: (context, index) {
                      final video = controller.favoriteVideos[index];
                      final history = homeController.watchedVideos.firstWhere(
                        (history) => history['id'] == video.movieSeries?.sId,
                        orElse: () => null,
                      );
                      return MyListItemView(
                        video: controller.favoriteVideos[index],
                        history: history,
                      );
                    },
                  ).paddingSymmetric(horizontal: 12, vertical: 10);
      },
    );
  }
}

///   ------------>>>>>> My List Item View <<<<<<<<<<-------------

class MyListItemView extends StatelessWidget {
  final Video video;
  final Map<String, dynamic>? history;

  const MyListItemView({
    super.key,
    required this.video,
    this.history,
  });

  @override
  Widget build(BuildContext context) {
    // You can fetch the progress value dynamically, here it's set to 0.2 (20%)
    // double progressValue = 0.4;
    double progressValue = 0.0;

    final currentEpisode = history?['lastEpisode'] ?? 0;
    final totalEpisodes = history?['totalEpisodes'] ?? 0;

    if (totalEpisodes > 0) {
      progressValue = currentEpisode / totalEpisodes;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(
            AppRoutes.episodeWiseReels,
            arguments: {
              "movieSeriesId": video.movieSeries?.sId ?? '',
              "totalVideos": totalEpisodes,
              "playIndex": currentEpisode,
            },
          );
        },
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
                      imageUrl: video.movieSeries?.thumbnail ?? '',
                      placeholder: (context, url) => Image.asset(
                        AppAsset.placeHolderImage,
                        fit: BoxFit.cover,
                        height: 80,
                        color: AppColor.colorIconGrey,
                      ),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    if (history != null)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: Colors.white.withValues(alpha: 0.2), // Optional background color
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColor.colorButtonPink), // Progress color
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Expanded(
              child: Text(
                '${video.movieSeries?.name}',
                style: AppFontStyle.styleW800(AppColor.colorWhite, 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (history != null)
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'EP.$currentEpisode ', style: AppFontStyle.styleW600(AppColor.colorButtonPink, 11)),
                    TextSpan(
                      text: '/EP.$totalEpisodes',
                      style: AppFontStyle.styleW600(AppColor.colorWhite, 11),
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

class HistoryBuilder extends StatefulWidget {
  const HistoryBuilder({super.key});

  @override
  State<HistoryBuilder> createState() => _HistoryBuilderState();
}

class _HistoryBuilderState extends State<HistoryBuilder> {
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    homeController.getHistory();
    // Preference.clearWatchedVideos();
    return GetBuilder<HomeController>(
      id: 'onGetHistory',
      builder: (logic) {
        return logic.watchedVideos.isEmpty
            ? NoDataWidget(text: EnumLocal.nohistoryYet.name.tr)
            : RefreshIndicator(
                onRefresh: () {
                  return homeController.getHistory();
                },
                child: ListView.builder(
                  itemCount: logic.watchedVideos.length,
                  itemBuilder: (context, index) {
                    final data = logic.watchedVideos[index];
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: data['thumbnail'],
                                placeholder: (context, url) => Image.asset(
                                  AppAsset.placeHolderImage,
                                  fit: BoxFit.cover,
                                  height: 40,
                                  color: AppColor.colorIconGrey,
                                ),
                                fit: BoxFit.cover,
                                height: 110,
                                width: 80,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data['title'],
                                    style: AppFontStyle.styleW800(AppColor.colorWhite, 17),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: 'EP.${data['lastEpisode']} ', style: AppFontStyle.styleW600(AppColor.colorButtonPink, 15)),
                                        TextSpan(
                                          text: '/EP.${data['totalEpisodes']}',
                                          style: AppFontStyle.styleW600(AppColor.colorWhite, 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 10),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await CreateFavoriteVideoApi.callApi(
                                  loginUserId: Preference.userId,
                                  movieSeriesId: data['id'] ?? "",
                                );
                                logic.likeUnlikeEpisode(index);
                                Vibration.vibrate(duration: 50, amplitude: 128);
                              },
                              child: Image.asset(
                                data['isLike'] == true ? AppAsset.icFavoriteSelected : AppAsset.icFavorite,
                                width: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).paddingOnly(top: 10),
              );
      },
    );
  }
}
