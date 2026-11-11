import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class CreateLikeDislikeOfVideoApi {
  static Future<void> callApi({required String loginUserId, required String videoId}) async {
    Utils.showLog(
      "Create Like Dislike Of Video Api Calling... $videoId",
    );

    final uri = Uri.parse("${ApiConstant.getBaseURL() + ApiConstant.createLikeDislikeOfVideo}userId=$loginUserId&videoId=$videoId");

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog(
          "Create Like Dislike Of Video Api Response => ${response.body}",
        );
      } else {
        Utils.showLog(
          "Create Like Dislike Of Video Api StateCode Error => ",
        );
      }
    } catch (error) {
      Utils.showLog(
        "Create Like Dislike Of Video Api Error => $error",
      );
    }
  }
}
