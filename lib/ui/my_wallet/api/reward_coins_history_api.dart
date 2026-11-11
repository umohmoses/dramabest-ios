// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:http/http.dart' as http;
// import 'package:story_box/ui/my_wallet/model/reward_coins_history_model.dart';
// import 'package:story_box/utils/params.dart';
//
// import '../../../utils/api.dart';
//
// class RewardCoinsHistoryApi {
//   int startCount = 1;
//   int limitCount = 20;
//
//   Future<List<RewardCoinsHistoryModel>> callApi({
//     required String userId,
//     required String start,
//     required String limit,
//   }) async {
//     try {
//       startCount++;
//       final queryParameters = {
//         Params.userId: userId,
//         Params.start: start,
//         Params.limit: limit,
//       };
//       log("Fetch Coin History API Calling...");
//       final url = Uri.parse("${ApiConstant.getBaseURL() + ApiConstant.fetchRewardCoinHistoryByUser + queryParameters}");
//       log("Get Movies Grouped By Category Url :: $url");
//
//       final headers = {"key": ApiConstant.SECRET_KEY};
//       final response = await http.get(url, headers: headers);
//
//       if (response.statusCode == 200) {
//         log("Fetch Coin History API Response => ${response.body}");
//
//         final Map<String, dynamic> jsonData = jsonDecode(response.body);
//
//         if (jsonData['status'] == true && jsonData['data'] is List) {
//           List<RewardCoinsHistoryModel> coinHistoryList =
//               (jsonData['data'] as List).map((coinData) => RewardCoinsHistoryModel.fromJson(coinData)).toList();
//
//           return coinHistoryList;
//         } else {
//           log(
//             "Unexpected JSON structure or empty data list",
//           );
//         }
//       } else {
//         log("Fetch Coin History API Status Code Error => ${response.statusCode}");
//       }
//     } catch (error) {
//       log("Fetch Coin History API Error => $error");
//     }
//     return [];
//   }
// }
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/my_wallet/model/reward_coins_history_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class RewardCoinsHistoryApi {
  static Future<List<Data>> callApi({
    required String userId,
    required int start,
    required String limit,
  }) async {
    Utils.showLog("Fetch Coin History API Calling...");

    final queryParameters = {
      Params.userId: userId,
      Params.start: start.toString(),
      Params.limit: limit,
      Params.startDate: "All",
      Params.endDate: "All",
    };

    String queryString = Uri(queryParameters: queryParameters).query;

    final url = Uri.parse(
      ApiConstant.getBaseURL() + ApiConstant.fetchRewardCoinHistoryByUser + queryString,
    );

    Utils.showLog("Fetch Reward Coin History API $url");

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog("Response => ${response.body}");

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // ✅ Parse full model
        final model = RewardCoinsHistoryModel.fromJson(jsonData);
        Utils.showLog("MOEL Response => ${model.status} ==${model.data} == ${response.body}");
        if (model.status == true && model.data != null) {
          return model.data!;
        } else {
          Utils.showLog("Empty or invalid data");
        }
      } else {
        Utils.showLog("Status Code Error => ${response.statusCode}");
      }
    } catch (error) {
      Utils.showLog("API Error => $error");
    }

    return [];
  }
}
