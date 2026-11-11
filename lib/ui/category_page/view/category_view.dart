import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/shimmer/category_wise_movie_shimmer_ui.dart';
import 'package:story_box/ui/category_page/controller/category_controller.dart';
import 'package:story_box/ui/category_page/widget/category_widget.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

///   ------------>>>>>> New Release View <<<<<<<<<<-------------

class CategoryBuilderView extends GetView<CategoryWiseController> {
  const CategoryBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      appBar: AppBar(
        leading: GestureDetector(
          child: Container(
            height: 50,
            width: 50,
            color: Colors.transparent,
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ).paddingOnly(left: 16),
          ),
          onTap: () => Get.back(),
        ),
        backgroundColor: AppColor.colorBlack,
        title: Text(
          controller.categoryName,
          style: AppFontStyle.styleW600(AppColor.colorWhite, 22),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<CategoryWiseController>(
        id: Constant.onGetCategory,
        builder: (controller) {
          return SizedBox(
            height: Get.height,
            width: Get.width,
            child: controller.isLoading
                ? const CategoryWiseGridShimmer()
                : Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          controller: controller.scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 230,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: controller.videos.length + (controller.hasMoreData ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Show loading indicator at the end
                            if (index == controller.videos.length) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.colorButtonPink,
                                ),
                              );
                            }

                            final video = controller.videos[index];
                            return CategoryItemView(categoryWiseVideo: video);
                          },
                        ),
                      ),

                      // Optional: separate pagination loader
                      GetBuilder<CategoryWiseController>(
                        id: "pagination",
                        builder: (ctrl) => ctrl.isPaginationLoading && !ctrl.hasMoreData
                            ? Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(EnumLocal.txtNoMoreVideos.name.tr),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
