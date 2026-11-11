class EpisodeWiseReelsLikeDislikeApi {
  // static Future<void> callApi({required String loginUserId, required String videoId}) async {
  //   Utils.showLog("Reels Like-Dislike Api Calling...", );
  //
  //   final uri = Uri.parse("${Api.reelsLikeDislike}?userId=$loginUserId&videoId=$videoId");
  //
  //   final headers = {"key": Api.secretKey};
  //
  //   try {
  //     final response = await http.post(uri, headers: headers);
  //
  //     if (response.statusCode == 200) {
  //       Utils.showLog("Reels Like-Dislike Api Response => ${response.body}", );
  //     } else {
  //       Utils.showLog("Reels Like-Dislike Api StateCode Error",
  //           ,
  //           error: "Reels Like-Dislike Api StateCode Error => ${response.statusCode} body => ${response.body}",
  //           stackTrace: StackTrace.current);
  //     }
  //   } catch (error) {
  //     Utils.showLog("Reels Like-Dislike Api Error ",
  //         , error: error, stackTrace: StackTrace.current);
  //   }
  // }
}
