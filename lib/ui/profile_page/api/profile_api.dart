import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/login_page/model/login_user_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/app_exception.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class ProfileApi {
  // static User? user;

  // static Future<User?> callApi() async {
  //   final userId = Preference.userId;
  //   try {
  //     final url = Uri.parse(
  //       "${ApiConstant.getBaseURL() + ApiConstant.fetchProfile}userId=$userId",
  //     );
  //     log("Get fetch user Url :: $url");
  //
  //     final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
  //     log("Get fetch user Headers :: $headers");
  //
  //     final response = await http.get(url, headers: headers);
  //
  //     log("Get fetch user Status Code :: ${response.statusCode}");
  //     log("Get fetch user Response :: ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['status'] == true && jsonResponse['user'] != null) {
  //         final userJson = jsonResponse['user'];
  //         // await Preference.onSetUserID(userJson?.user?.id ?? "");
  //         return User.fromJson(userJson);
  //       }
  //     }
  //     log("Get fetch user Api Called Successfully");
  //   } on AppException catch (exception) {
  //     Utils.showToast(Get.context!, exception.message);
  //   } catch (e) {
  //     log("Error call Get fetch user Api :: $e");
  //   } finally {}
  //   return null;
  // }

  static Future<LoginUserModel?> callApi() async {
    final userId = Preference.userId;
    try {
      final url = Uri.parse(
        "${ApiConstant.getBaseURL() + ApiConstant.fetchProfile}userId=$userId",
      );
      Utils.showLog("Get fetch user Url :: $url");
      Utils.showLog("callllllllllllllllllllllllllllllllllllll");

      final headers = {
        "key": ApiConstant.SECRET_KEY,
        'Content-Type': 'application/json',
      };
      Utils.showLog("Get fetch user Headers :: $headers");

      final response = await http.get(url, headers: headers);

      log("Get fetch user Status Code :: ${response.statusCode}");
      Utils.showLog("Get fetch user Response :: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        final loginUserModel = LoginUserModel.fromJson(jsonResponse);

        log("Parsed loginUserModel status: ${loginUserModel.status}");
        log("Parsed user name: ${loginUserModel.user?.name}");

        await Preference.shared.setString(Preference.name, loginUserModel.user?.name ?? "");
        await Preference.shared.setString(Preference.uniqueId, loginUserModel.user?.uniqueId ?? "");
        await Preference.shared.setInt(Preference.loginType, loginUserModel.user?.loginType ?? 0);
        await Preference.shared.setString(Preference.email, loginUserModel.user?.email ?? "abc@gmail.com");
        await Preference.onSetUserCoin(loginUserModel.user?.coin ?? 0);

        await Preference.shared.setString(Preference.profilePic, loginUserModel.user?.profilePic ?? "");

        return loginUserModel;
      }

      log("Get fetch user Api Called Successfully");
    } on AppException catch (exception) {
      Utils.showToast(Get.context!, exception.message);
    } catch (e) {
      log("Error call Get fetch user Api :: $e");
    }

    return null;
  }
}
