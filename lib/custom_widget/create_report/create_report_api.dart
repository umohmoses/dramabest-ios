import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class CreateReportApi {
  static Future<bool?> callApi({
    required String loginUserId,
    required String reportReason,
    required String eventId,
  }) async {
    Utils.showLog("Create Report Api Calling...");

    final queryParameters = "?userId=$loginUserId&type=video&reportReason=$reportReason&videoId=$eventId"; // Video Report.

    final uri = Uri.parse(ApiConstant.createReport + queryParameters);

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog("Create Report Api Response => ${response.body}");

        final jsonResponse = jsonDecode(response.body);

        return jsonResponse["status"];
      } else {
        Utils.showLog("Create Report Api StateCode Error");
      }
    } catch (error) {
      Utils.showLog("Create Report Api Error => $error");
    }
    return null;
  }
}
