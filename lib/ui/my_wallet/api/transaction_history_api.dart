import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/my_wallet/model/transaction_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class TransactionHistoryApi {
  static Future<List<CoinPlanHistory>> callApi({
    required String userId,
    required int start,
    required String limit,
  }) async {
    Utils.showLog(
      "Fetch Coin History API Calling...",
    );
    final queryParameters = {
      Params.userId: userId,
      Params.start: start.toString(),
      Params.limit: limit,
    };

    String queryString = Uri(queryParameters: queryParameters).query;
    final url = Uri.parse(
      ApiConstant.getBaseURL() + ApiConstant.fetchCoinPlanHistory + queryString,
    );

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.get(url, headers: headers);
      Utils.showLog(
        "Fetch Coin History API Calling... $url",
      );
      if (response.statusCode == 200) {
        Utils.showLog(
          "Fetch Coin History API Response => ${response.body}",
        );

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] is List) {
          List<CoinPlanHistory> coinHistoryList = (jsonData['data'] as List).map((coinData) => CoinPlanHistory.fromJson(coinData)).toList();

          return coinHistoryList;
        } else {
          Utils.showLog(
            "Unexpected JSON structure or empty data list",
          );
        }
      } else {
        Utils.showLog(
          "Fetch Coin History API Status Code Error => ${response.statusCode}",
        );
      }
    } catch (error) {
      Utils.showLog(
        "Fetch Coin History API Error => $error",
      );
    }

    return [];
  }
}
