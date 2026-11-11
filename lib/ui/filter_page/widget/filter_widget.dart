import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/filter_page/model/filter_model.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

import '../../episode_wise_reels_page/widget/episode_wise_reels_widget.dart';

///   ------------>>>>>> New Release Item View <<<<<<<<<<-------------

class FilterItemView extends StatelessWidget {
  final FilterData filterData;

  const FilterItemView({super.key, required this.filterData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.episodeWiseReels,
          arguments: {
            "movieSeriesId": filterData.id ?? "",
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
                height: 130,
                width: 200,
                child: Stack(
                  children: [
                    // Image
                    CachedNetworkImage(
                      imageUrl: filterData.thumbnail ?? "",
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
                              Text(CustomFormatNumber.convert(
                                  // filterData.totalViews?.toInt() ??
                                  0), style: AppFontStyle.styleW800(AppColor.colorWhite, 13)),
                              5.width
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
                filterData.name ?? "",
                style: TextStyle(height: 1.1, color: AppColor.colorWhite, fontSize: 13, fontFamily: Constant.appFontFamily, fontWeight: FontWeight.w800),
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
                    height: 14,
                    width: 14,
                  ),
                  5.width,
                  Text(
                    filterData.languageName ?? "",
                    style: AppFontStyle.styleW600(AppColor.colorWhite.withValues(alpha: 0.7), 10),
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
