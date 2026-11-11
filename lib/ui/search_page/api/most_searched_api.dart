import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/search_page/model/most_searched_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class MostSearchedApi {
  static Future<List<MostSearchedList>> callApi({String? start, String? limit}) async {
    final headers = {"key": ApiConstant.SECRET_KEY};
    final queryParameters = {
      Params.start: start,
      Params.limit: limit,
    };

    String queryString = Uri(queryParameters: queryParameters).query;
    final url = Uri.parse(
      ApiConstant.getBaseURL() + ApiConstant.getMostSearched + queryString,
    );
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog(
          "Search API Response => ${response.body}",
        );

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] is List) {
          return (jsonData['data'] as List).map((data) => MostSearchedList.fromJson(data)).toList();
        } else {
          Utils.showLog(
            "Unexpected JSON structure or empty searchData list",
          );
        }
      } else {
        Utils.showLog(
          "Search API Status Code Error => ${response.statusCode}",
        );
      }
    } catch (error) {
      Utils.showLog(
        "Search API Error => $error",
      );
    }

    return [];
  }
}
