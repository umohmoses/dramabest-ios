import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/earn_reward_page/model/earn_coin_from_check_in_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class EarnCoinFromCheckInApi {
  static Future<EarnCoinFromCheckInModel?> callApi({required String loginUserId, required int dailyRewardCoin}) async {
    Utils.showLog("Earn Coin From Check In Api Calling...");

    try {
      final headers = {"key": ApiConstant.SECRET_KEY, "Content-Type": 'application/json'};

      final uri = Uri.parse(
          '${ApiConstant.getBaseURL() + ApiConstant.createDailyCheckInRewardHistory}userId=$loginUserId&dailyRewardCoin=$dailyRewardCoin');

      Utils.showLog("Earn Coin From Check In Api Uri => $uri");

      final response = await http.patch(uri, headers: headers);

      final jsonResponse = jsonDecode(response.body);

      Utils.showLog("Earn Coin From Check In Api Response => $jsonResponse");

      return EarnCoinFromCheckInModel.fromJson(jsonResponse);
    } catch (e) {
      Utils.showLog("Earn Coin From Check In Api Error => $e");

      return null;
    }
  }
}
