import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/utils.dart';

class ViewAllPage extends StatelessWidget {
  const ViewAllPage({
    super.key,
    required this.videos,
    required this.title,
    this.isNewRelease = false,
  });

  final List<Map<String, dynamic>> videos;
  final String title;
  final bool isNewRelease;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.colorPrimary.withValues(alpha: 0.15),
                      AppColor.colorPrimary.withValues(alpha: 0.1),
                      AppColor.colorBlack.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8, top: 34),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: AppFontStyle.styleW500(AppColor.colorWhite, 20),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
          GetBuilder<HomeController>(
            builder: (controller) {
              return Expanded(
                child: Column(
                  children: [
                    videos.isNotEmpty
                        ? Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: videos.length,
                              controller: controller.scrollController1,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.59,
                              ),
                              itemBuilder: (context, index) {
                                final data = videos[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoutes.episodeWiseReels,
                                      arguments: {
                                        "movieSeriesId": data['_id'] ?? "",
                                        "totalVideos": 0,
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
                                                    imageUrl: data['thumbnail'] ?? "",
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
                                                  if (isNewRelease)
                                                    Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Align(
                                                        alignment: Alignment.topRight,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(4),
                                                            color: AppColor.colorButtonPink,
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                                                            child: Text(
                                                              "New",
                                                              style: AppFontStyle.styleW800(AppColor.colorWhite, 10),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
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
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.play_arrow_rounded, color: AppColor.colorWhite, size: 22),
                                                          Text(
                                                            CustomFormatNumber.convert(data['views'] ?? 0),
                                                            style: AppFontStyle.styleW800(AppColor.colorWhite, 11),
                                                          ),
                                                        ],
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
                                          Flexible(
                                            child: Text(
                                              data['name'] ?? "Unnamed Video",
                                              style: AppFontStyle.styleW800(AppColor.colorWhite, 13),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              EnumLocal.noVideosAvailable.name.tr,
                              style: AppFontStyle.styleW400(AppColor.colorWhite, 16),
                            ),
                          ),
                    controller.isLoadingMostTrending1 == true
                        ? const CircularProgressIndicator(
                            color: AppColor.primaryColor,
                          ).paddingOnly(bottom: 7)
                        : const SizedBox(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
