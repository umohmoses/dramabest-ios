import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/home_page/model/get_all_category_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/app_exception.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class GetAllCategoryApi {
  AllCategoryModel? allCategoryModel;

  HomeController homeController = Get.find<HomeController>();

  Future<AllCategoryModel?> callApi({
    required String start,
    required String limit,
  }) async {
    try {
      homeController.startAllCategoryCount++;

      final queryParameters = {
        Params.start: start,
        Params.limit: limit,
      };

      String queryString = Uri(queryParameters: queryParameters).query;

      Utils.showLog("All Category Params :: $queryString");

      final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.listCategory + queryString);
      Utils.showLog("All Category Url :: $url");

      final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
      Utils.showLog("All Category Headers :: $headers");

      final response = await http.get(url, headers: headers);

      Utils.showLog("All Category Status Code :: ${response.statusCode}");
      Utils.showLog("All Category Response :: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return AllCategoryModel.fromJson(jsonResponse);
      }
      Utils.showLog("All Category Api Called Successfully");
    } on AppException catch (exception) {
      Utils.showToast(Get.context!, exception.message);
    } catch (e) {
      Utils.showLog("Error call All Category Api :: $e");
    } finally {}
    return null;
  }
}
