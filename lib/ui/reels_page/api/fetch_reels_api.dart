// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
// import 'package:story_box/ui/reels_page/model/fetch_reels_model.dart';
// import 'package:story_box/utils/api.dart';
// import 'package:story_box/utils/params.dart';
// import 'package:story_box/utils/utils.dart';
//
// class FetchReelsApi {
//   static int startPagination = 0;
//   static int limitPagination = 20;
//
//   static Future<GetVideosGroupedByMovieSeriesModel?> callApi({
//     required String userId,
//   }) async {
//     Utils.showLog("Get Reels Api Calling... ", );
//
//     startPagination += 1;
//
//     Utils.showLog("Get Reels Pagination Page => $startPagination");
//     final queryParameters = {
//       Params.userId: userId,
//       Params.start: startPagination.toString(),
//       Params.limit: limitPagination.toString(),
//     };
//     String queryString = Uri(queryParameters: queryParameters).query;
//     final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.getVideosGroupedByMovieSeries + queryString);
//     // final uri = Uri.parse(
//     //     "${Api.fetchReels}?start=$startPagination&limit=$limitPagination&userId=$loginUserId&videoId=$videoId");
//     Utils.showLog("Get Reels Api Url => $url");
//
//     final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
//
//     try {
//       var response = await http.get(url, headers: headers);
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//
//         Utils.showLog("Get Reels Api Response => ${response.body}", );
//         return GetVideosGroupedByMovieSeriesModel.fromJson(jsonResponse);
//       } else {
//         Utils.showLog("Get Reels Api StateCode Error",
//             , error: "StateCode Error => ${response.statusCode} body => ${response.body}");
//       }
//     } catch (error) {
//       Utils.showLog("Get Reels Api Error", , error: "Error => $error");
//     }
//     return null;
//   }
// }
