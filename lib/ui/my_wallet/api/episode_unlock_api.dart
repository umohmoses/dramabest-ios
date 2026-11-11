import 'package:story_box/utils/session_token.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/my_wallet/model/episode_unlock_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class EpisodeUnlockApi {
  Future<List<EpisodeUnlockModel>> callApi({
    required String userId,
    required int start,
    required String limit,
  }) async {
    try {
      final queryParameters = {
        Params.userId: userId,
        Params.start: start.toString(),
        Params.limit: limit,
      };

      String queryString = Uri(queryParameters: queryParameters).query;

      final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.getEpisodeUnlockHistory + queryString);

      Utils.showLog("Fetch episode unlock API Calling...$url");

      final headers = {"key": ApiConstant.SECRET_KEY, ...await SessionToken.headers()};
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog(
          "Fetch episode unlock API Response => ${response.body}",
        );

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] is List) {
          List<EpisodeUnlockModel> episodeUnlockList = (jsonData['data'] as List).map((coinData) => EpisodeUnlockModel.fromJson(coinData)).toList();

          return episodeUnlockList;
        } else {
          Utils.showLog(
            "Unexpected JSON structure or empty data list",
          );
        }
      } else {
        Utils.showLog(
          "Fetch episode unlock API Status Code Error => ${response.statusCode}",
        );
      }
    } catch (error) {
      Utils.showLog(
        "Fetch episode unlock API Error => $error",
      );
    }
    return [];
  }
}
