import 'package:story_box/utils/session_token.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/earn_reward_page/model/earn_coin_from_watch_ad_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class EarnCoinFromWatchAdApi {
  static Future<EarnCoinFromWatchAdModel?> callApi({required String loginUserId, required int coinEarnedFromAd}) async {
    Utils.showLog("Earn Coin From Watch Ad Api Calling...");

    try {
      final headers = {"key": ApiConstant.SECRET_KEY, "Content-Type": 'application/json', ...await SessionToken.headers()};

      final uri = Uri.parse(
          '${ApiConstant.getBaseURL() + ApiConstant.createAdWatchRewardHistory}userId=$loginUserId&coinEarnedFromAd=$coinEarnedFromAd');

      Utils.showLog("Earn Coin From Watch Ad Api Uri => $uri");

      final response = await http.patch(uri, headers: headers);

      final jsonResponse = jsonDecode(response.body);

      Utils.showLog("Earn Coin From Watch Ad Api Response => $jsonResponse");

      return EarnCoinFromWatchAdModel.fromJson(jsonResponse);
    } catch (e) {
      Utils.showLog("Earn Coin From Watch Ad Api Error => $e");

      return null;
    }
  }
}
