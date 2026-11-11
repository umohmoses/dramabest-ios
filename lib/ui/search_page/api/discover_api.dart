import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

/// A title found outside the published catalogue (search fallback). Opening it imports and publishes it.
class DiscoveredTitle {
  final String token;
  final String name;
  final String description;
  final String thumbnail;
  final int totalEpisodes;
  final String category;

  DiscoveredTitle.fromJson(Map<String, dynamic> j)
      : token = '${j['token'] ?? ''}',
        name = '${j['name'] ?? ''}',
        description = '${j['description'] ?? ''}',
        thumbnail = '${j['thumbnail'] ?? ''}',
        totalEpisodes = (j['totalEpisodes'] is num) ? (j['totalEpisodes'] as num).toInt() : 0,
        category = '${j['category'] ?? ''}';
}

class DiscoverApi {
  static const _base = "api/client/movieSeries/";

  static Future<List<DiscoveredTitle>> search(String query) async {
    try {
      final uri = Uri.parse("${ApiConstant.getBaseURL()}${_base}discoverSearch").replace(queryParameters: {"query": query});
      final res = await http.get(uri, headers: {"key": ApiConstant.SECRET_KEY}).timeout(const Duration(seconds: 20));
      if (res.statusCode != 200) return [];
      final d = jsonDecode(res.body);
      if (d is Map && d['status'] == true && d['items'] is List) {
        return (d['items'] as List).whereType<Map>().map((e) => DiscoveredTitle.fromJson(Map<String, dynamic>.from(e))).where((t) => t.token.isNotEmpty).toList();
      }
    } catch (e) {
      Utils.showLog("Discover search failed => $e");
    }
    return [];
  }

  /// Returns the movieSeriesId to open, or throws a message the viewer can read.
  static Future<String> open(String token) async {
    try {
      final res = await http
          .post(Uri.parse("${ApiConstant.getBaseURL()}${_base}discoverOpen"), headers: {"key": ApiConstant.SECRET_KEY, "Content-Type": "application/json"}, body: jsonEncode({"token": token}))
          .timeout(const Duration(seconds: 90));
      final d = jsonDecode(res.body);
      if (d is Map && d['status'] == true && '${d['movieSeriesId'] ?? ''}'.isNotEmpty) return '${d['movieSeriesId']}';
      throw (d is Map && d['message'] != null) ? '${d['message']}' : 'This title could not be opened. Try another one.';
    } on String {
      rethrow;
    } catch (e) {
      Utils.showLog("Discover open failed => $e");
      throw 'Check your connection and try again.';
    }
  }
}
