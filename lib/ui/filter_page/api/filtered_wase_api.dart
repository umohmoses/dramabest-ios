import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/filter_page/model/filter_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class FilterWiseDataApi {
  static Future<FilterWiseDataModel?> callApi({
    String? start,
    String? limit,
    Set<String>? selectedCategoryIDs,
    Set<String>? selectedLanguageIDs,
    String? sortBy,
  }) async {
    final headers = {"key": ApiConstant.SECRET_KEY};
    final queryParameters = {
      Params.start: start,
      Params.limit: limit,
      if (selectedCategoryIDs != null && selectedCategoryIDs.isNotEmpty) Params.categories: selectedCategoryIDs.join(','), // Set to comma-separated
      if (selectedLanguageIDs != null && selectedLanguageIDs.isNotEmpty) Params.languages: selectedLanguageIDs.join(','), // Set to comma-separated
      Params.sortBy: sortBy,
    };

    String queryString = Uri(queryParameters: queryParameters).query;
    final url = Uri.parse(
      ApiConstant.getBaseURL() + ApiConstant.getFilterContent + queryString,
    );
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog(
          "Filter Wise Api Response => ${response.body}",
        );

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['filterData'] is List) {
          return FilterWiseDataModel.fromJson(jsonData);
        } else {
          Utils.showLog(
            "Unexpected JSON structure or empty searchData list",
          );
        }
      } else {
        Utils.showLog(
          "Filter Wise Api Status Code Error => ${response.statusCode}",
        );
      }
    } catch (error) {
      Utils.showLog(
        "Filter Wise Api Error => $error",
      );
    }

    return null;
  }
}
