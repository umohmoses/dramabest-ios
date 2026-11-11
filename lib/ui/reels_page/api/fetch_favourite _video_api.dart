import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../../../utils/preference.dart';
import '../../../utils/utils.dart';
import '../model/video.dart';

class GetFavoriteVideoApi {
  static Future<List<Video>> callApi() async {
    final userId = Preference.userId;
    final url = Uri.parse(
      "${ApiConstant.getBaseURL() + ApiConstant.getFavoriteVideo}userId=$userId",
    );
    Utils.showLog(
      "Get Favorite Video Api Calling...$url",
    );

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog(
          "Get Favorite Video Api Response => ${response.body}",
        );

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] is List) {
          List<Video> videoList = (jsonData['data'] as List).map((video) => Video.fromJson(video)).toList();

          return videoList;
        } else {
          Utils.showLog(
            "Unexpected JSON structure or empty videos list",
          );
        }
      } else {
        Utils.showLog(
          "Get Favorite Video Api Status Code Error => ${response.statusCode}",
        );
      }
    } catch (error) {
      Utils.showLog(
        "Get Favorite Video Api Error => $error",
      );
    }
    return [];
  }
}
