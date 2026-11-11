import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

/// One title as returned by the Explore endpoints (same shape in every list).
class ExploreTitle {
  final String id;
  final String name;
  final String thumbnail;
  final String description;
  final String categoryId;
  final String categoryName;
  final int views;
  final int totalEpisodes;
  final String? badge; // "Hot" | "New"
  final String? rankLabel; // "8th in Most Popular"
  final String section; // New tab only: "This month" / "Week of 6 Oct" / "September 2026"
  final Map<String, dynamic> raw;

  ExploreTitle({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.views,
    required this.totalEpisodes,
    required this.badge,
    required this.rankLabel,
    required this.section,
    required this.raw,
  });

  factory ExploreTitle.fromJson(Map<String, dynamic> j) {
    final cat = j["category"] is Map ? j["category"] as Map : const {};
    return ExploreTitle(
      id: "${j["_id"] ?? ""}",
      name: "${j["name"] ?? ""}",
      thumbnail: "${j["thumbnail"] ?? ""}",
      description: "${j["description"] ?? ""}",
      categoryId: "${cat["_id"] ?? ""}",
      categoryName: "${cat["name"] ?? ""}",
      views: j["views"] is num ? (j["views"] as num).toInt() : 0,
      totalEpisodes: j["totalEpisodes"] is num ? (j["totalEpisodes"] as num).toInt() : 0,
      badge: j["badge"] is String ? j["badge"] : null,
      rankLabel: j["rankLabel"] is String ? j["rankLabel"] : null,
      section: "${j["section"] ?? ""}",
      raw: j,
    );
  }
}

class ExploreGroup {
  final String categoryId;
  final String categoryName;
  final List<ExploreTitle> movies;
  ExploreGroup(this.categoryId, this.categoryName, this.movies);
}

class ExplorePage<T> {
  final List<T> items;
  final bool hasMore;
  ExplorePage(this.items, this.hasMore);
}

class ExploreApi {
  static const _base = "api/client/movieSeries/";

  static Future<Map<String, dynamic>?> _get(String path, Map<String, String> query) async {
    try {
      final url = Uri.parse(ApiConstant.getBaseURL() + _base + path).replace(queryParameters: query);
      final response = await http.get(url, headers: {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) return null;
      final body = jsonDecode(response.body);
      return body is Map<String, dynamic> && body["status"] == true ? body : null;
    } catch (e) {
      Utils.showLog("Explore $path error :: $e");
      return null;
    }
  }

  static List<ExploreTitle> _titles(dynamic list) =>
      list is List ? list.whereType<Map<String, dynamic>>().map(ExploreTitle.fromJson).where((t) => t.id.isNotEmpty).toList() : <ExploreTitle>[];

  /// period: day | week | month
  static Future<List<ExploreTitle>?> trending({String period = "day", int limit = 9}) async {
    final r = await _get("exploreTrending", {"period": period, "limit": "$limit"});
    return r == null ? null : _titles(r["items"]);
  }

  static Future<ExplorePage<ExploreGroup>?> youMightLike({required int start, int limit = 4}) async {
    final r = await _get("exploreYouMightLike", {"start": "$start", "limit": "$limit"});
    if (r == null) return null;
    final groups = (r["groups"] is List ? r["groups"] as List : const [])
        .whereType<Map<String, dynamic>>()
        .map((g) => ExploreGroup("${g["categoryId"] ?? ""}", "${g["categoryName"] ?? ""}", _titles(g["movies"])))
        .where((g) => g.movies.isNotEmpty)
        .toList();
    return ExplorePage(groups, r["hasMore"] == true);
  }

  /// sort: trending | latest
  static Future<ExplorePage<ExploreTitle>?> category({required String categoryId, required String sort, required int start, int limit = 20}) async {
    final r = await _get("exploreCategory", {"categoryId": categoryId, "sort": sort, "start": "$start", "limit": "$limit"});
    return r == null ? null : ExplorePage(_titles(r["items"]), r["hasMore"] == true);
  }

  static Future<ExplorePage<ExploreTitle>?> newest({required int start, int limit = 30}) async {
    final r = await _get("exploreNew", {"start": "$start", "limit": "$limit"});
    return r == null ? null : ExplorePage(_titles(r["items"]), r["hasMore"] == true);
  }
}
