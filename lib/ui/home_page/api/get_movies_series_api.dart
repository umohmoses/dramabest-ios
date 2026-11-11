import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/home_page/model/get_movies_series_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/app_exception.dart';
import 'package:story_box/utils/utils.dart';

class GetMoviesSeriesApi {
  GetMoviesSeriesModel? getMoviesSeriesModel;

  static Future<GetMoviesSeriesModel?> callApi() async {
    try {
      final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.getMoviesSeries);
      Utils.showLog("Get Movies Series Url :: $url");

      final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
      Utils.showLog("Get Movies Series Headers :: $headers");

      final response = await http.get(url, headers: headers);

      Utils.showLog("Get Movies Series Status Code :: ${response.statusCode}");
      Utils.showLog("Get Movies Series Response :: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return GetMoviesSeriesModel.fromJson(jsonResponse);
      }
      Utils.showLog("Get Movies Series Api Called Successfully");
    } on AppException catch (exception) {
      Utils.showToast(Get.context!, exception.message);
    } catch (e) {
      Utils.showLog("Error call Get Movies Series Api :: $e");
    } finally {}
    return null;
  }
}
