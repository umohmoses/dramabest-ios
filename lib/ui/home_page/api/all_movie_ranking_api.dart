import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/home_page/controller/home_controller.dart';

import 'package:story_box/ui/home_page/model/get_all_movie_ranking_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/app_exception.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class GetAllRankingApi {
  AllMovieRankingModel? allMovieRankingModel;

  HomeController homeController = Get.find<HomeController>();

  Future<AllMovieRankingModel?> callApi({
    required String start,
    required String limit,
  }) async {
    try {
      homeController.startAllRankingCount++;

      final queryParameters = {
        Params.start: start,
        Params.limit: limit,
      };

      String queryString = Uri(queryParameters: queryParameters).query;

      Utils.showLog("All Ranking Params :: $queryString");

      final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.fetchTrendingMoviesSeries + queryString);
      Utils.showLog("All Ranking Url :: $url");

      final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
      Utils.showLog("All Ranking Headers :: $headers");

      final response = await http.get(url, headers: headers);

      Utils.showLog("All Ranking Status Code :: ${response.statusCode}");
      Utils.showLog("All Ranking Response :: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return AllMovieRankingModel.fromJson(jsonResponse);
      }
      Utils.showLog("All Ranking Api Called Successfully");
    } on AppException catch (exception) {
      Utils.showToast(Get.context!, exception.message);
    } catch (e) {
      Utils.showLog("Error call All Ranking Api :: $e");
    } finally {}
    return null;
  }
}
