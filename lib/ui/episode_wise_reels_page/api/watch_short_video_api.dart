import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class WatchShortVideoApi {
  static Future<void> callApi({required String loginUserId, required String videoId, required int currentWatchTime}) async {
    final uri = Uri.parse(
        "${ApiConstant.getBaseURL() + ApiConstant.handleWatchHistoryCreation}userId=$loginUserId&videoId=$videoId&currentWatchTime=$currentWatchTime");

    Utils.showLog("watch short video uri => $uri");

    final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};

    try {
      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        log(
          "Watch Video Api Response => ${response.body}",
        );
      } else {
        log("Watch Video Api StateCode Error",
            error: "Watch Video Api StateCode Error => ${response.statusCode} body => ${response.body}", stackTrace: StackTrace.current);
      }
    } catch (error) {
      log("Watch Video Api Error ", error: error, stackTrace: StackTrace.current);
    }
  }
}
