import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/shimmer/reels_shimmer_ui.dart';
import 'package:story_box/ui/episode_wise_reels_page/controller/episode_wise_reels_controller.dart';
import 'package:story_box/ui/episode_wise_reels_page/widget/episode_wise_reels_widget.dart';
import 'package:story_box/utils/color.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EpisodeWiseReelsView — clean rewrite
// ─────────────────────────────────────────────────────────────────────────────
class EpisodeWiseReelsView extends GetView<EpisodeWiseReelsController> {
  const EpisodeWiseReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    // ONE-TIME setup — runs only on first build
    final int playIndex = Get.arguments['playIndex'] as int? ?? 0;

    // Only re-create the controller if route is fresh
    if (Get.currentRoute == AppRoutes.episodeWiseReels) {
      controller.preloadPageController = PreloadPageController(initialPage: playIndex);
      controller.init(); // async — triggers shimmer → content swap via update()
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColor.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      body: GetBuilder<EpisodeWiseReelsController>(
        id: 'reels',
        builder: (ctrl) => ctrl.isLoadingReels
            ? const ReelsShimmerUi(isShowEpisode: true)
            : RefreshIndicator(
                color: AppColor.colorBlack,
                onRefresh: () async {
                  await 400.milliseconds.delay();
                  await ctrl.init();
                },
                child: PreloadPageView.builder(
                  controller: ctrl.preloadPageController,
                  itemCount: ctrl.mainReels.length,
                  preloadPagesCount: 1,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index) {
                    // Only place onChangePage is called — never in build()
                    ctrl.onChangePage(index);
                  },
                  itemBuilder: (context, index) {
                    if (index >= ctrl.mainReels.length) return const SizedBox.shrink();
                    return GetBuilder<EpisodeWiseReelsController>(
                      id: 'pageIndex',
                      builder: (ctrl) => EpisodeWisePreviewReelsView(
                        index: index,
                        currentPageIndex: ctrl.currentPageIndex,
                      ),
                    );
                  },
                ),
              ),
      ),
      bottomNavigationBar: GetBuilder<EpisodeWiseReelsController>(
        id: 'pagination',
        builder: (ctrl) => Visibility(
          visible: ctrl.isPaginationLoading,
          child: const LinearProgressIndicator(color: AppColor.colorPrimary),
        ),
      ),
    );
  }
}
