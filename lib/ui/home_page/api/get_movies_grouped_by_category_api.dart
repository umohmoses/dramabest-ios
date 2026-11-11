import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/home_page/model/get_movies_grouped_by_category_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/app_exception.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class GetMoviesGroupedByCategoryApi {
  GetMoviesGroupedByCategoryModel? getMoviesGroupedByCategoryModel;

  static Future<GetMoviesGroupedByCategoryModel?> callApi({
    required String userId,
    required String start,
    required String limit,
    required String moviesStart,
    required String moviesLimit,
  }) async {
    try {
      final queryParameters = {
        Params.userId: userId,
        Params.start: start,
        Params.limit: limit,
        Params.moviesStart: moviesStart,
        Params.moviesLimit: moviesLimit,
      };

      String queryString = Uri(queryParameters: queryParameters).query;

      Utils.showLog("Get Movies Grouped By Category Params :: $queryString");

      final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.getMoviesGroupedByCategory + queryString);
      Utils.showLog("Get Movies Grouped By Category Url :: $url");

      final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
      Utils.showLog("Get Movies Grouped By Category Headers :: $headers");

      final response = await http.get(url, headers: headers);

      Utils.showLog("Get Movies Grouped By Category Status Code :: ${response.statusCode}");
      Utils.showLog("Get Movies Grouped By Category Response :: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return GetMoviesGroupedByCategoryModel.fromJson(jsonResponse);
      }
      Utils.showLog("Get Movies Grouped By Category Api Called Successfully");
    } on AppException catch (exception) {
      Utils.showToast(Get.context!, exception.message);
    } catch (e) {
      Utils.showLog("Error call Get Movies Grouped By Category Api :: $e");
    } finally {}
    return null;
  }
}
