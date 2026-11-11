import 'package:story_box/utils/session_token.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

// class VideoViewApi {
//   static Future<bool?> callApi({required String loginUserId, required String shortVideoId}) async {
//     final uri = Uri.parse("${ApiConstant.getBaseURL() + ApiConstant.deductCoinForVideoView}userId=$loginUserId&shortVideoId=$shortVideoId");
//
//     log("Deduct watch short video uri => $uri");
//
//     final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
//
//     try {
//       final response = await http.patch(uri, headers: headers);
//
//       log("video view response  =======>>>>>${response.body}");
//       if (response.statusCode == 200) {
//         final responseBody = jsonDecode(response.body);
//         if (responseBody['status'] == true) {
//           final updatedCoin = responseBody['userCoin'];
//
//           await Preference.onSetUserCoin(updatedCoin ?? 1000);
//         } else {
//           return false;
//         }
//         log(
//           "Deduct watch Video Api Response => ${response.body}",
//         );
//         return false;
//       } else {
//         log("Deduct watch Video Api StateCode Error", error: "Deduct watch Video Api StateCode Error => ${response.statusCode} body => ${response.body}", stackTrace: StackTrace.current);
//         return false;
//       }
//     } catch (error) {
//       log("Deduct   watch Video Api Error ", error: error, stackTrace: StackTrace.current);
//       return false;
//     }
//   }
// }
class VideoViewApi {
  static Future<bool?> callApi({required String loginUserId, required String shortVideoId}) async {
    final uri = Uri.parse("${ApiConstant.getBaseURL() + ApiConstant.deductCoinForVideoView}userId=$loginUserId&shortVideoId=$shortVideoId");

    Utils.showLog("Deduct watch short video uri => $uri");

    final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json', ...await SessionToken.headers()};

    try {
      final response = await http.patch(uri, headers: headers);

      Utils.showLog("video view response  =======>>>>>${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody['status'] == true) {
          final updatedCoin = responseBody['userCoin'];
          await Preference.onSetUserCoin(updatedCoin ?? 1000);
          Utils.showLog("Make Sure ==> Coin Update $updatedCoin");

          Utils.showLog("Deduct watch Video Api Response => ${response.body}");
          return true; // ✅ Success - video unlocked
        } else {
          Utils.showLog("API returned status false: ${responseBody['message'] ?? 'Insufficient coins'}");
          return false; // ❌ Failed - not enough coins
        }
      } else {
        log("Deduct watch Video Api StateCode Error",
            error: "StateCode => ${response.statusCode} body => ${response.body}", stackTrace: StackTrace.current);
        return false;
      }
    } catch (error) {
      log("Deduct watch Video Api Error", error: error, stackTrace: StackTrace.current);
      return false;
    }
  }
}
