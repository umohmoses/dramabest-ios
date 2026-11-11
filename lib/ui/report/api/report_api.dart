import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/report/model/report_reason.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class ReportApi {
  static Future<List<ReportReason>> callApi() async {
    Utils.showLog(
      "Fetch Report Reason API Calling...",
    );

    final url = Uri.parse(
      ApiConstant.getBaseURL() + ApiConstant.getReportReason,
    );

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog(
          "Fetch Report Reason API Response => ${response.body}",
        );

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] is List) {
          List<ReportReason> reason = (jsonData['data'] as List).map((data) => ReportReason.fromJson(data)).toList();

          return reason;
        } else {
          Utils.showLog(
            "Unexpected JSON structure or empty data list",
          );
        }
      } else {
        Utils.showLog(
          "Fetch Report Reason API Status Code Error => ${response.statusCode}",
        );
      }
    } catch (error) {
      Utils.showLog(
        "Fetch Report Reason API Error => $error",
      );
    }

    return [];
  }
}
