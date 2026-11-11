import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/episode_wise_reels_page/model/fetch_episode_wise_reels_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class FetchEpisodeWiseReelsApi {
  static int startPagination = 0;
  static int limitPagination = 20;

  static Future<FetchEpisodeWiseReelsModel?> callApi({required String loginUserId, required String videoId, required String movieSeriesId}) async {
    Utils.showLog(
      "Fetch Episode Wise Reels Api Calling... ",
    );

    startPagination += 1;

    Utils.showLog("Get Reels Pagination Page => $startPagination");

    final queryParameters = {
      Params.userId: loginUserId,
      Params.start: startPagination.toString(),
      Params.limit: limitPagination.toString(),
      Params.movieSeriesId: movieSeriesId,
    };

    Utils.showLog("Fetch Episode Wise Reels Api queryParameters => $queryParameters");

    String queryString = Uri(queryParameters: queryParameters).query;

    final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.fetchEpisodeWiseVideo + queryString);
    final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};

    Utils.showLog("Fetch Episode Wise Reels Api Url => $url");

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        log("Fetch Episode Wise Reels Api Response => ${response.body}");

        return FetchEpisodeWiseReelsModel.fromJson(jsonResponse);
      } else {
        log("Fetch Episode Wise Reels Api StateCode Error => ", error: "StateCode Error => ${response.statusCode} body => ${response.body}");
      }
    } catch (error) {
      log("Fetch Episode Wise Reels Api Error => ", error: "Error => $error");
    }
    return null;
  }
}
