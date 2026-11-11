import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/ui/episode_wise_reels_page/widget/episode_wise_reels_widget.dart';
import 'package:story_box/ui/home_page/explore/explore_api.dart';
import 'package:story_box/ui/home_page/explore/explore_controller.dart';
import 'package:story_box/ui/home_page/explore/explore_widgets.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/font_style.dart';

const _red = Color(0xFFFF3B4E);

/// One category: "Trending" (most watched this week) and "Latest" (newest first) tabs; each list grows as you drag down.
class ExploreCategoryPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const ExploreCategoryPage({super.key, required this.categoryId, required this.categoryName});

  @override
  State<ExploreCategoryPage> createState() => _ExploreCategoryPageState();
}

class _ExploreCategoryPageState extends State<ExploreCategoryPage> with SingleTickerProviderStateMixin {
  late final TabController tabs = TabController(length: 2, vsync: this);
  late final Map<String, PagedList<ExploreTitle>> lists = {
    for (final sort in ["trending", "latest"]) sort: PagedList<ExploreTitle>((start) => ExploreApi.category(categoryId: widget.categoryId, sort: sort, start: start)),
  };

  @override
  void initState() {
    super.initState();
    tabs.addListener(() => setState(() {}));
    _load("trending");
    _load("latest");
  }

  @override
  void dispose() {
    tabs.dispose();
    super.dispose();
  }

  Future<void> _load(String sort) async {
    final l = lists[sort]!;
    if (l.loading || !l.hasMore) return;
    setState(() {});
    if (await l.loadMore() && mounted) setState(() {});
  }

  Future<void> _refresh(String sort) async {
    lists[sort]!.reset();
    await _load(sort);
  }

  Widget _tab(String label, int i) {
    final on = tabs.index == i;
    return GestureDetector(
      onTap: () => tabs.animateTo(i),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(color: on ? _red.withValues(alpha: 0.16) : Colors.transparent, borderRadius: BorderRadius.circular(16)),
        child: Text(label, style: AppFontStyle.styleW600(on ? _red : AppColor.colorWhite.withValues(alpha: 0.85), 15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      appBar: AppBar(
        backgroundColor: AppColor.colorBlack,
        surfaceTintColor: AppColor.colorBlack,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColor.colorWhite, size: 20), onPressed: Get.back),
        title: Text(widget.categoryName, style: AppFontStyle.styleW600(AppColor.colorWhite, 18)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: Row(children: [_tab("Trending", 0), _tab("Latest", 1)]),
          ),
          Expanded(
            child: TabBarView(
              controller: tabs,
              children: ["trending", "latest"].map((sort) {
                final l = lists[sort]!;
                if (l.items.isEmpty && l.isFirstLoad) {
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: _red));
                }
                return RefreshIndicator(
                  color: _red,
                  onRefresh: () => _refresh(sort),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (n) => loadNearEnd(n, () => _load(sort)),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                      itemCount: l.items.length + 1,
                      itemBuilder: (context, i) => i == l.items.length
                          ? ListFooter(loading: l.loading, hasMore: l.hasMore, failed: l.failed, onRetry: () => _load(sort))
                          : CategoryRow(title: l.items[i]),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Poster (Hot/New label, views) + title, description, rank label, category and episode count.
class CategoryRow extends StatelessWidget {
  final ExploreTitle title;
  const CategoryRow({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => openTitle(title),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 100,
                height: 136,
                child: Stack(children: [
                  CachedNetworkImage(
                    memCacheWidth: 300,
                    imageUrl: title.thumbnail,
                    placeholder: (context, _) => Image.asset(AppAsset.placeHolderImage, color: AppColor.colorIconGrey).paddingAll(14),
                    errorWidget: (context, _, __) => Container(color: AppColor.colorLightBlack),
                    fit: BoxFit.cover,
                    width: 100,
                    height: 136,
                  ),
                  Align(alignment: Alignment.topRight, child: ExploreBadge(title.badge)),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColor.colorBlack.withValues(alpha: 0.7), AppColor.colorBlack.withValues(alpha: 0)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                      ),
                      child: Row(children: [
                        const Icon(Icons.play_arrow_rounded, color: AppColor.colorWhite, size: 14),
                        Text(CustomFormatNumber.convert(title.views), style: AppFontStyle.styleW700(AppColor.colorWhite, 11)),
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
            12.width,
            Expanded(
              child: SizedBox(
                height: 136,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFontStyle.styleW700(AppColor.colorWhite, 16).copyWith(height: 1.2)),
                    6.height,
                    Expanded(
                      child: Text(title.description, maxLines: 3, overflow: TextOverflow.ellipsis, style: AppFontStyle.styleW400(AppColor.colorWhite.withValues(alpha: 0.5), 12.5).copyWith(height: 1.3)),
                    ),
                    if (title.rankLabel != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: _red.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                        child: Text("${title.rankLabel} ›", style: AppFontStyle.styleW500(_red, 11)),
                      ),
                    Row(children: [
                      Expanded(
                        child: Text(title.categoryName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFontStyle.styleW500(AppColor.colorWhite.withValues(alpha: 0.6), 12)),
                      ),
                      if (title.totalEpisodes > 0) Text("${title.totalEpisodes} Episodes", style: AppFontStyle.styleW500(AppColor.colorWhite.withValues(alpha: 0.6), 12)),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
