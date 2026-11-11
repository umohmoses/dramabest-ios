import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/earn_reward_page/model/get_ad_reward_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class GetAdRewardApi {
  static Future<GetAdRewardModel?> callApi({required String userId}) async {
    Utils.showLog("Get Ad Reward Api Calling...");

    final uri = Uri.parse("${ApiConstant.getBaseURL()}${ApiConstant.adRewardCoin}userId=$userId");

    Utils.showLog("Get Ad Reward Api Url => $uri");

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Get Ad Reward Api Response => ${response.body}");

        return GetAdRewardModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Get Ad Reward Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Get Ad Reward Api Error => $error");
    }
    return null;
  }
}
