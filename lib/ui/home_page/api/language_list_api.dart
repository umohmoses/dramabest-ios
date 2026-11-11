import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/home_page/model/language_list_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/app_exception.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class GetAllLanguagesApi {
  LanguageListModel? languageListModel;

  HomeController homeController = Get.find<HomeController>();

  Future<LanguageListModel?> callApi({
    required String start,
    required String limit,
  }) async {
    try {
      homeController.startAllLanguagesCount++;

      final queryParameters = {
        Params.start: start,
        Params.limit: limit,
      };

      String queryString = Uri(queryParameters: queryParameters).query;

      Utils.showLog("All Languages Params :: $queryString");

      final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.getLanguageList + queryString);
      Utils.showLog("All Languages Url :: $url");

      final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
      Utils.showLog("All Languages Headers :: $headers");

      final response = await http.get(url, headers: headers);

      Utils.showLog("All Languages Status Code :: ${response.statusCode}");
      Utils.showLog("All Languages Response :: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return LanguageListModel.fromJson(jsonResponse);
      }
      Utils.showLog("All Languages Api Called Successfully");
    } on AppException catch (exception) {
      Utils.showToast(Get.context!, exception.message);
    } catch (e) {
      Utils.showLog("Error call All Languages Api :: $e");
    } finally {}
    return null;
  }
}
