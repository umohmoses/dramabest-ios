import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/shimmer/most_trending_shimmer.dart';
import 'package:story_box/shimmer/new_release_shimmer.dart';
import 'package:story_box/ui/episode_wise_reels_page/widget/episode_wise_reels_widget.dart';
import 'package:story_box/ui/home_page/explore/explore_api.dart';
import 'package:story_box/ui/home_page/explore/explore_category_page.dart';
import 'package:story_box/ui/home_page/explore/explore_controller.dart';
import 'package:story_box/ui/home_page/model/trending_movie_series_model.dart';
import 'package:story_box/ui/home_page/widget/home_widget.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

void openTitle(ExploreTitle t) => Get.toNamed(AppRoutes.episodeWiseReels, arguments: {"movieSeriesId": t.id, "totalVideos": 0});

void openCategory(String id, String name) => Get.to(() => ExploreCategoryPage(categoryId: id, categoryName: name));

/// Loads the next page when the user drags close to the end of a vertical list.
bool loadNearEnd(ScrollNotification n, VoidCallback load) {
  if (n.metrics.axis == Axis.vertical && n.metrics.extentAfter < 900) load();
  return false; // let the home page keep reacting (app bar opacity)
}

const _tagColors = [Color(0xFF3B2A50), Color(0xFF1E3B3A), Color(0xFF4A2F2A), Color(0xFF26324F), Color(0xFF4A2442), Color(0xFF2F3A24)];
Color tagColor(String name) => _tagColors[name.codeUnits.fold<int>(0, (a, c) => a + c) % _tagColors.length];

Widget _poster(String url, {double? height, double? width}) => CachedNetworkImage(
      memCacheWidth: 540,
      imageUrl: url,
      placeholder: (context, _) => Center(child: Image.asset(AppAsset.placeHolderImage, color: AppColor.colorIconGrey).paddingAll(14)),
      errorWidget: (context, _, __) => Container(color: AppColor.colorLightBlack),
      fit: BoxFit.cover,
      height: height ?? double.infinity,
      width: width ?? double.infinity,
    );

/// "Hot" (red) or "New" (pink) corner label.
class ExploreBadge extends StatelessWidget {
  final String? badge;
  const ExploreBadge(this.badge, {super.key});

  @override
  Widget build(BuildContext context) {
    if (badge == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: badge == "Hot" ? const Color(0xFFE5243B) : AppColor.colorButtonPink,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
      ),
      child: Text(badge == "Hot" ? "Hot" : EnumLocal.newText.name.tr, style: AppFontStyle.styleW700(AppColor.colorWhite, 10)),
    );
  }
}

class _Views extends StatelessWidget {
  final int views;
  const _Views(this.views);

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.play_arrow_rounded, color: AppColor.colorWhite, size: 15),
        Text(CustomFormatNumber.convert(views), style: AppFontStyle.styleW700(AppColor.colorWhite, 11)),
      ]);
}

///   ------------>>>>>> Trending (9 titles: today / this week / this month) <<<<<<<<<<-------------
class ExploreTrendingSection extends StatelessWidget {
  const ExploreTrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = ExploreController.to;
    return GetBuilder<ExploreController>(
      id: ExploreController.idTrending,
      builder: (_) {
        if (!c.trendingLoading && c.trending.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Trending 🚀", style: AppFontStyle.styleW800(AppColor.colorWhite, 24)),
            8.height,
            SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                children: ExploreController.periods.entries.map((e) {
                  final on = e.key == c.period;
                  return GestureDetector(
                    onTap: () => c.setPeriod(e.key),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: on ? AppColor.primaryGradient : null,
                        color: on ? null : AppColor.colorWhite.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(e.value, style: AppFontStyle.styleW600(AppColor.colorWhite.withValues(alpha: on ? 1 : 0.7), 13)),
                    ),
                  );
                }).toList(),
              ),
            ),
            10.height,
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [AppColor.colorButtonPink.withValues(alpha: 0.2), AppColor.colorBlack.withValues(alpha: 0.1), AppColor.colorBlack.withValues(alpha: 0.2), AppColor.colorBlack.withValues(alpha: 0.0)],
                ),
              ),
              height: Get.height * 0.4,
              child: c.trendingLoading && c.trending.isEmpty
                  ? const MostTrendingShimmer()
                  : GridView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: c.trending.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0, mainAxisExtent: 200),
                      itemBuilder: (context, index) {
                        final data = TrendingMoviesSeriesData.fromJson(c.trending[index].raw);
                        return MostTrendingItemView(language: data.language?.name ?? "", view: data.viewsLabel, index: index + 1, trendingMoviesSeriesData: data);
                      },
                    ),
            ),
          ],
        ).paddingOnly(left: 12, bottom: 18);
      },
    );
  }
}

///   ------------>>>>>> You Might Like: tag cards (4 mini rows) + posters, 7 trending titles per category <<<<<<<<<<-------------
class YouMightLikeSection extends StatelessWidget {
  const YouMightLikeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = ExploreController.to;
    return GetBuilder<ExploreController>(
      id: ExploreController.idYouMightLike,
      builder: (_) {
        final list = c.youMightLike;
        if (list.items.isEmpty) {
          if (list.failed || !list.hasMore) return const SizedBox.shrink();
          return const NewReleaseShimmer();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("You Might Like", style: AppFontStyle.styleW800(AppColor.colorWhite, 24)).paddingSymmetric(horizontal: 12),
            8.height,
            for (final g in list.items) TagBlock(group: g).paddingOnly(left: 12, right: 12, bottom: 14),
            ListFooter(loading: list.loading, hasMore: list.hasMore, failed: list.failed, onRetry: c.loadMoreYouMightLike),
          ],
        );
      },
    );
  }
}

/// One tag's block: the tag card (titles 1-4) opens it, and the next 7 titles of the same tag
/// fill the two columns around it, so the block closes level before the next tag starts.
class TagBlock extends StatelessWidget {
  final ExploreGroup group;
  const TagBlock({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final posters = group.movies.skip(4).toList();
    if (posters.isEmpty) return TagCard(group: group);
    // The card is about one poster tall: each poster goes to the column with fewer items (left on a
    // tie), so poster 1 sits beside the card, poster 2 under it, and both columns end level.
    final left = <Widget>[TagCard(group: group)];
    final right = <Widget>[];
    for (final m in posters) {
      (right.length < left.length ? right : left).add(PosterTile(title: m));
    }
    Widget column(List<Widget> items) => Expanded(
          child: Column(children: [
            for (var i = 0; i < items.length; i++) ...[if (i > 0) 10.height, items[i]],
          ]),
        );
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [column(left), 8.width, column(right)]);
  }
}

/// Bold category name with an arrow (opens the category's Trending / Latest page) and 4 mini rows.
class TagCard extends StatelessWidget {
  final ExploreGroup group;
  const TagCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: tagColor(group.categoryName), borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => openCategory(group.categoryId, group.categoryName),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              child: Row(children: [
                Expanded(
                  child: Text(group.categoryName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFontStyle.styleW800(AppColor.colorWhite, 17)),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColor.colorWhite, size: 24),
              ]),
            ),
          ),
          for (final m in group.movies.take(4))
            GestureDetector(
              onTap: () => openTitle(m),
              child: Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: AppColor.colorWhite.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(6)),
                child: Row(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(4), child: _poster(m.thumbnail, height: 44, width: 34)),
                  8.width,
                  Expanded(
                    child: Text(m.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFontStyle.styleW500(AppColor.colorWhite, 12.5).copyWith(height: 1.2)),
                  ),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}

/// Poster with views and Hot/New label, title, and the category chip (opens the category page).
class PosterTile extends StatelessWidget {
  final ExploreTitle title;
  const PosterTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openTitle(title),
      child: Container(
        decoration: BoxDecoration(color: AppColor.colorLightBlack, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: AspectRatio(
                aspectRatio: 0.72,
                child: Stack(children: [
                  _poster(title.thumbnail),
                  Align(alignment: Alignment.topRight, child: ExploreBadge(title.badge)),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(6, 14, 8, 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColor.colorBlack.withValues(alpha: 0.65), AppColor.colorBlack.withValues(alpha: 0)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                      ),
                      child: Align(alignment: Alignment.centerRight, child: _Views(title.views)),
                    ),
                  ),
                ]),
              ),
            ),
            6.height,
            Text(title.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFontStyle.styleW700(AppColor.colorWhite, 13.5).copyWith(height: 1.2)).paddingSymmetric(horizontal: 6),
            if (title.categoryName.isNotEmpty)
              GestureDetector(
                onTap: () => openCategory(title.categoryId, title.categoryName),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColor.colorWhite.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text("${title.categoryName} ›", style: AppFontStyle.styleW500(AppColor.colorWhite.withValues(alpha: 0.6), 11)),
                ),
              ),
            8.height,
          ],
        ),
      ),
    );
  }
}

/// Spinner while the next page loads, "retry" when it failed, a quiet end marker when everything is shown.
class ListFooter extends StatelessWidget {
  final bool loading;
  final bool hasMore;
  final bool failed;
  final VoidCallback onRetry;
  const ListFooter({super.key, required this.loading, required this.hasMore, required this.failed, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (loading) {
      child = const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.colorButtonPink));
    } else if (failed) {
      child = TextButton(onPressed: onRetry, child: Text("Tap to try again", style: AppFontStyle.styleW600(AppColor.colorButtonPink, 13)));
    } else if (!hasMore) {
      child = Text("You've seen everything for now", style: AppFontStyle.styleW500(AppColor.colorWhite.withValues(alpha: 0.4), 12));
    } else {
      child = const SizedBox(height: 22);
    }
    return Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Center(child: child));
  }
}

///   ------------>>>>>> New tab: every new title, newest first; this month, then earlier weeks and months <<<<<<<<<<-------------
class ExploreNewTab extends StatelessWidget {
  const ExploreNewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = ExploreController.to;
    return GetBuilder<ExploreController>(
      id: ExploreController.idNew,
      builder: (_) {
        final list = c.newest;
        if (list.items.isEmpty && !list.failed && list.hasMore) return const SingleChildScrollView(child: NewReleaseShimmer());
        final sections = <MapEntry<String, List<ExploreTitle>>>[];
        for (final t in list.items) {
          if (sections.isEmpty || sections.last.key != t.section) sections.add(MapEntry(t.section, []));
          sections.last.value.add(t);
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (n) => loadNearEnd(n, c.loadMoreNew),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverToBoxAdapter(
                child: Text(EnumLocal.newRelease.name.tr, style: AppFontStyle.styleW800(AppColor.colorWhite, 26)).paddingSymmetric(horizontal: 12),
              ),
              for (final s in sections) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 2),
                    child: Row(children: [
                      Container(width: 4, height: 18, decoration: BoxDecoration(gradient: AppColor.primaryGradient, borderRadius: BorderRadius.circular(2))),
                      8.width,
                      Text(s.key, style: AppFontStyle.styleW700(AppColor.colorWhite, 18)),
                      8.width,
                      Text("${s.value.length}", style: AppFontStyle.styleW500(AppColor.colorWhite.withValues(alpha: 0.45), 13)),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 8,
                    childCount: s.value.length,
                    itemBuilder: (context, i) => PosterTile(title: s.value[i]),
                  ),
                ),
              ],
              SliverToBoxAdapter(
                child: list.items.isEmpty && !list.loading && !list.failed
                    ? Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Center(child: Text(EnumLocal.nothingHereYetTxt.name.tr, style: AppFontStyle.styleW600(AppColor.colorWhite.withValues(alpha: 0.6), 15))),
                      )
                    : ListFooter(loading: list.loading, hasMore: list.hasMore, failed: list.failed, onRetry: c.loadMoreNew),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 160)),
            ],
          ),
        );
      },
    );
  }
}
