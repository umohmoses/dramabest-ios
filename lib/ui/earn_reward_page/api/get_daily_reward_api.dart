import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/earn_reward_page/model/get_daily_reward_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class GetDailyRewardApi {
  static Future<GetDailyRewardModel?> callApi({required String loginUserId}) async {
    Utils.showLog("Get Daily Reward Api Calling...");

    final uri = Uri.parse("${ApiConstant.getBaseURL()}${ApiConstant.dailyRewardCoin}userId=$loginUserId");

    Utils.showLog("Get Daily Reward Api Uri => $uri");

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Get Daily Reward Api Response => ${response.body}");

        return GetDailyRewardModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Get Daily Reward Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Get Daily Reward Api Error => $error");
    }
    return null;
  }
}
