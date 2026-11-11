import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/custom_widget/custom_blur_widget.dart';
import 'package:story_box/custom_widget/no_data_widget.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/home_page/widget/categories_widget.dart';
import 'package:story_box/ui/home_page/widget/explore_widget.dart';
import 'package:story_box/ui/home_page/widget/home_widget.dart';
import 'package:story_box/ui/home_page/explore/explore_widgets.dart';
import 'package:story_box/ui/home_page/widget/ranking_widget.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/utils.dart';

class HomeViewPage extends GetView<HomeController> {
  const HomeViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.selectedTabIndex = 0;
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            // Update opacity based on scroll position
            if (scrollNotification.metrics.axis == Axis.vertical) {
              controller.updateAppBarOpacity(scrollNotification.metrics.pixels);
              Utils.showLog("Vertical Scroll position: ${scrollNotification.metrics.pixels}");
            }
          }
          return true;
        },
        child: RefreshIndicator(
          color: AppColor.colorBlack,
          onRefresh: () async {
            await 400.milliseconds.delay();
            await controller.onRefresh();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    GetBuilder<HomeController>(
                      id: Constant.idHomeBlurCarousel,
                      builder: (logic) {
                        return logic.selectedTabIndex != 0
                            ? Container()
                            : BlurWidget(
                                height: Get.height * 0.55,
                                blurAmount: 50.0,
                                child: SizedBox(
                                  height: Get.height * 0.55,
                                  width: Get.width,
                                  child: CachedNetworkImage(
                                    imageUrl: logic.getMoviesSeriesModel?.data?[logic.initialPage].thumbnail ?? "",
                                    placeholder: (context, url) => Image.asset(
                                      AppAsset.placeHolderImage,
                                      fit: BoxFit.cover,
                                      height: 40,
                                      color: AppColor.colorIconGrey,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                      },
                    ),
                    GetBuilder<HomeController>(
                      id: Constant.idHomeBlurCarousel,
                      builder: (logic) {
                        return logic.selectedTabIndex != 0
                            ? Container()
                            : BlurWidget(
                                height: Get.height * 2,
                                blurAmount: 50.0,
                                child: Container(
                                  height: Get.height * 2,
                                  width: Get.width,
                                  color: AppColor.colorBlack,
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
              CustomScrollView(
                physics: const BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
                slivers: [
                  const HomeAppBar(),
                  SliverToBoxAdapter(
                    child: TopTabBar(),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: GetBuilder<HomeController>(
                      id: Constant.idMostTrending,
                      builder: (controller) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height, // Adjust this value based on your TopTabBar + AppBar height
                          child: PageView(
                            controller: controller.pageController, // Add this in your HomeController
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: controller.onPageChangedTab,
                            children: [
                              // Page 1 - Your current full home feed
                              const ExploreWidget(), // We'll define this below

                              // Page 2 - New: every new title, this month first, then earlier weeks and months
                              const ExploreNewTab(),
                              // Page 3
                              // const Center(child: Text("Shorts", style: TextStyle(color: Colors.white, fontSize: 24))),
                              controller.allCategoryModel?.data != null && controller.allCategoryModel!.data!.isNotEmpty
                                  ? const CategoryBuilderView()
                                  : Padding(
                                      padding: const EdgeInsets.only(bottom: 200.0),
                                      child: NoDataWidget(text: EnumLocal.nothingHereYetTxt.name.tr),
                                    ),
                              // Page 4
                              controller.trendingMovieSeriesModel != null && controller.trendingMovieSeriesModel?.data != null && (controller.trendingMovieSeriesModel?.data?.isNotEmpty ?? false)
                                  ? const AllRankingBuilderView()
                                  : Padding(
                                      padding: const EdgeInsets.only(bottom: 200.0),
                                      child: NoDataWidget(text: EnumLocal.nothingHereYetTxt.name.tr),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GetBuilder<HomeController>(
        id: Constant.onChangeTab,
        builder: (controller) {
          // show FAB only on tab 2 AND when list is scrolled down a bit
          final show = controller.selectedTabIndex == 2 && (controller.categoryScrollController.hasClients && controller.categoryScrollController.offset > 150);
          return show
              ? FloatingActionButton(
                  mini: true,
                  backgroundColor: AppColor.primaryColor,
                  onPressed: () => controller.categoryScrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  ),
                  child: Icon(
                    Icons.arrow_upward,
                    size: 20,
                    color: AppColor.colorWhite.withAlpha(150),
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
