// import 'package:http/http.dart' as http;
// import 'package:story_box/utils/utils.dart';
//
// class ReelsShareApi {
//   static Future<void> callApi({required String loginUserId, required String videoId}) async {
//     Utils.showLog("Reels Share Api Calling...");
//
//     final uri = Uri.parse("${Api.videoShare}?userId=$loginUserId&videoId=$videoId");
//
//     final headers = {"key": Api.secretKey};
//
//     try {
//       final response = await http.post(uri, headers: headers);
//
//       if (response.statusCode == 200) {
//         Utils.showLog("Reels Share Api Api Response => ${response.body}");
//       } else {
//         Utils.showLog("Reels Share Api StateCode Error");
//       }
//     } catch (error) {
//       Utils.showLog("Reels Share Api Error => $error");
//     }
//   }
// }
