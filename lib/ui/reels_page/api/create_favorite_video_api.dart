import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class CreateFavoriteVideoApi {
  static Future<void> callApi({required String loginUserId, required String movieSeriesId}) async {
    Utils.showLog(
      "Create Favorite Video Api Calling...",
    );

    final uri = Uri.parse("${ApiConstant.getBaseURL() + ApiConstant.createFavoriteVideo}userId=$loginUserId&movieSeriesId=$movieSeriesId");

    final headers = {"key": ApiConstant.SECRET_KEY};

    Utils.showLog("url:::::::::$uri");

    try {
      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog(
          "Create Favorite Video Api Response => ${response.body}",
        );
      } else {
        Utils.showLog(
          "Create Favorite Video Api StateCode Error => ",
        );
      }
    } catch (error) {
      Utils.showLog(
        "Create Favorite Video Api Error => $error",
      );
    }
  }
}
