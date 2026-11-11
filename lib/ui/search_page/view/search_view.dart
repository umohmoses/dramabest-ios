// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:story_box/ui/search_page/widget/search_widget.dart';
import 'package:story_box/utils/color.dart';

class SearchViewPage extends StatelessWidget {
  SearchViewPage({super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColor.colorBlack,
        automaticallyImplyLeading: false,
        title: SearchTextField(
          // searchController: searchController,
          onSearch: () {},
        ),
      ),
      body: const Column(
        children: [Expanded(child: SearchBuilder())],
      ),
    );
  }
}
