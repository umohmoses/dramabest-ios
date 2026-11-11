import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:story_box/custom_widget/create_report/fetch_report_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class FetchReportApi {
  static Future<FetchReportModel?> callApi() async {
    Utils.showLog("Get Report Api Calling...");

    final uri = Uri.parse(ApiConstant.fetchReport);

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      Utils.showLog("message>>>>>>>>>> $uri");
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Utils.showLog("Get Report Api Response => ${response.body}");

        return FetchReportModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Get Report Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Get Report Api Error => $error");
    }
    return null;
  }
}
