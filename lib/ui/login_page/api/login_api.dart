import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/growth/welcome_bonus.dart';
import 'package:story_box/ui/login_page/model/login_user_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/app_exception.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class LoginApi {
  LoginUserModel? loginUserModel;

  static Future<LoginUserModel?> callApi({
    required int loginType,
    required String fcmToken,
    required String email,
    required String identity,
    required String name,
    String? profilePic,
  }) async {
    try {
      final body = json.encode({
        Params.loginType: loginType,
        Params.fcmToken: fcmToken,
        Params.email: email,
        Params.identity: identity,
        Params.name: name,
        Params.profilePic: profilePic,
      });

      final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.login);

      final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
      // Proof of the account for Google, Apple and email sign-in. Guests have none and don't need it.
      final firebaseToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (firebaseToken != null) headers['Authorization'] = 'Bearer $firebaseToken';

      final response = await http.post(url, headers: headers, body: body);

      Utils.showLog("Login Quick Status Code :: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final model = LoginUserModel.fromJson(jsonResponse);
        if (model.status == true) await Preference.shared.setInt(Preference.loginType, loginType); // GuestGate reads this
        if (model.status == true && model.signUp == true) WelcomeBonus.signedUp((model.user?.coin ?? 0).toInt()); // welcome message on home
        return model;
      }
      Utils.showLog("Login Quick Api Called Successfully");
    } on AppException catch (exception) {
      Utils.showToast(Get.context!, exception.message);
    } catch (e) {
      Utils.showLog("Error call Login Quick Api :: $e");
    } finally {}
    return null;
  }
}
