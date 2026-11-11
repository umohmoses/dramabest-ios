import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/ui/my_list/widget/my_list_widget.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

class MyListViewPage extends StatelessWidget {
  final bool isShowArrow;

  const MyListViewPage({super.key, required this.isShowArrow});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: AppColor.colorBlack,
        appBar: AppBar(
          // centerTitle: true,
          backgroundColor: AppColor.colorBlack,
          // automaticallyImplyLeading: false,
          // elevation: 0,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: isShowArrow ? Colors.white : Colors.transparent,
            ),
            onTap: () => Get.back(),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: Get.width * 0.5,
                  child: TabBar(
                    unselectedLabelStyle: AppFontStyle.styleW600(AppColor.colorIconGrey, 18),
                    dividerColor: AppColor.transparent,
                    labelStyle: AppFontStyle.styleW600(AppColor.colorWhite, 18),
                    labelColor: AppColor.colorWhite,
                    unselectedLabelColor: AppColor.colorIconGrey,
                    indicatorColor: AppColor.colorWhite,
                    tabs: [
                      Tab(text: EnumLocal.myList.name.tr),
                      Tab(text: EnumLocal.history.name.tr),
                    ],
                  ),
                ),
              ),
              50.width,
            ],
          ),
        ),
        body: TabBarView(
          children: [MyListBuilderView(), const HistoryBuilder()],
        ),
      ),
    );
  }
}
