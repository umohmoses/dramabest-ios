import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/reels_page/model/fetch_movie_series_trailer_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class FetchMovieSeriesTrailerApi {
  static int startPagination = 0;
  static int limitPagination = 20;

  static Future<FetchMovieSeriesTrailerModel?> callApi({required String userId}) async {
    Utils.showLog(
      "Fetch Movie Series Trailer Api Calling... ",
    );

    startPagination += 1;

    Utils.showLog("Get Reels Pagination Page => $startPagination");

    final queryParameters = {
      Params.userId: userId,
      Params.start: startPagination.toString(),
      Params.limit: limitPagination.toString(),
    };

    String queryString = Uri(queryParameters: queryParameters).query;

    final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.fetchMovieSeriesTrailer + queryString);
    final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};

    Utils.showLog("Fetch Movie Series Trailer Api Url => $url");

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Fetch Movie Series Trailer Api Response => ${response.body}");

        return FetchMovieSeriesTrailerModel.fromJson(jsonResponse);
      } else {
        log("Fetch Movie Series Trailer Api StateCode Error => ", error: "StateCode Error => ${response.statusCode} body => ${response.body}");
      }
    } catch (error) {
      log("Fetch Movie Series Trailer Api Error => ", error: "Error => $error");
    }
    return null;
  }
}
