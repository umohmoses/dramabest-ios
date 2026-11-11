import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/language_page/model/fetch_language_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class FetchLanguageApi {
  static Future<FetchLanguageModel?> callApi({required int start, required int limit}) async {
    Utils.showLog("Get Language Api Calling... ");

    Utils.showLog("Get Language Pagination Page => $start");

    final uri = Uri.parse("${(ApiConstant.getBaseURL() + ApiConstant.fetchLanguages)}?start=$start&limit=$limit");

    Utils.showLog("Get Language Api Url => $uri");

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Get Language Api Response => ${response.body}");

        return FetchLanguageModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Get Language Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Get Language Api Error => $error");
    }
    return null;
  }
}
