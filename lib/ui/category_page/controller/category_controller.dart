import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:story_box/ui/category_page/api/category_wase_api.dart';
import 'package:story_box/ui/category_page/model/category_wase_model.dart';
import 'package:story_box/utils/constant.dart';

class CategoryWiseController extends GetxController {
  CategoryWiseModel? categoryWiseModel;
  final RxList<Video> videos = <Video>[].obs; // Use RxList or normal List + update()
  bool isLoading = false;
  bool isPaginationLoading = false;
  String categoryID = "";
  String categoryName = "";
  ScrollController scrollController = ScrollController();

  int startCategoryCount = 0;
  int limitCategoryCount = 20;
  bool hasMoreData = true;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      categoryID = Get.arguments["categoryId"] ?? "";
      categoryName = Get.arguments["categoryName"] ?? "";
    }
    scrollController.addListener(_onScroll);
    _fetchInitialVideos();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (!isPaginationLoading && hasMoreData) {
        _loadMoreVideos();
      }
    }
  }

  Future<void> _fetchInitialVideos() async {
    isLoading = true;
    update([Constant.onGetCategory]);

    startCategoryCount = 1; // Usually APIs start from 0 or 1

    categoryWiseModel = await CategoryWiseApi.callApi(
      categoryId: categoryID,
      start: startCategoryCount.toString(),
      limit: limitCategoryCount.toString(),
    );

    if (categoryWiseModel?.videos != null && categoryWiseModel!.videos!.isNotEmpty) {
      videos.clear();
      videos.addAll(categoryWiseModel!.videos!);
      hasMoreData = categoryWiseModel!.videos!.length == limitCategoryCount;
    } else {
      hasMoreData = false;
    }

    isLoading = false;
    update([Constant.onGetCategory]);
  }

  Future<void> _loadMoreVideos() async {
    if (isPaginationLoading || !hasMoreData) return;

    isPaginationLoading = true;
    update(["pagination"]);

    startCategoryCount += limitCategoryCount; // Go to next page

    CategoryWiseModel? newData = await CategoryWiseApi.callApi(
      categoryId: categoryID,
      start: startCategoryCount.toString(),
      limit: limitCategoryCount.toString(),
    );

    if (newData?.videos != null && newData!.videos!.isNotEmpty) {
      videos.addAll(newData.videos!);
      hasMoreData = newData.videos!.length == limitCategoryCount;
    } else {
      hasMoreData = false;
    }

    isPaginationLoading = false;
    update(["pagination", Constant.onGetCategory]); // Update both
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
