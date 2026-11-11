import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/session_token.dart';

class DeleteUserApi {
  static Future<bool> callApi({required String userId}) async {
    log("Delete User Api Calling... ");

    final uri = Uri.parse(
      "${ApiConstant.getBaseURL() + ApiConstant.deleteUserAccount}userId=$userId",
    );

    log("Delete User Api Calling...$uri ");

    try {
      // Proof that this account is the caller's own.
      final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json', ...await SessionToken.headers()};
      final firebaseToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (firebaseToken != null) headers['Authorization'] = 'Bearer $firebaseToken';

      var response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        log("Delete User Api Response => ${response.body}");

        return jsonResponse["status"];
      } else {
        log("Delete User Api StateCode Error ");
      }
    } catch (error) {
      log("Delete User Api Error => $error");
    }
    return false;
  }
}
