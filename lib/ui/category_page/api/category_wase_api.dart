import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/category_page/model/category_wase_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class CategoryWiseApi {
  static Future<CategoryWiseModel?> callApi({String? start, String? limit, String? categoryId}) async {
    final headers = {"key": ApiConstant.SECRET_KEY};
    final queryParameters = {
      Params.categoryId: categoryId,
      Params.start: start,
      Params.limit: limit,
    };

    String queryString = Uri(queryParameters: queryParameters).query;
    final url = Uri.parse(
      ApiConstant.getBaseURL() + ApiConstant.fetchGenreBasedMediaContent + queryString,
    );
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog(
          "Category Wise Api Response => ${response.body}",
        );

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['videos'] is List) {
          return CategoryWiseModel.fromJson(jsonData);
        } else {
          Utils.showLog(
            "Unexpected JSON structure or empty searchData list",
          );
        }
      } else {
        Utils.showLog(
          "Category Wise Api Status Code Error => ${response.statusCode}",
        );
      }
    } catch (error) {
      Utils.showLog(
        "Category Wise Api Error => $error",
      );
    }

    return null;
  }
}
