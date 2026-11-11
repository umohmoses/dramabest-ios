import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class SearchMovieSeriesApi {
  static Future<void> callApi({required String loginUserId, required String query, required String movieSeriesId}) async {
    final uri = Uri.parse("${ApiConstant.getBaseURL() + ApiConstant.searchMovieSeries}query=$query&userId=$loginUserId&movieSeriesId=$movieSeriesId");

    Utils.showLog("Search Movie Series Api uri => $uri");

    final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};

    try {
      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog(
          "Search Movie Series Api Response => ${response.body}",
        );
      } else {
        log("Search Movie Series Api StateCode Error", error: "Search Movie Series Api StateCode Error => ${response.statusCode} body => ${response.body}", stackTrace: StackTrace.current);
      }
    } catch (error) {
      log("Search Movie Series Api Error ", error: error, stackTrace: StackTrace.current);
    }
  }
}
