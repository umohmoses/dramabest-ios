import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

/// Account emails sent by our server from the official Dramabest address.
/// Each call returns false on any failure, so the caller can use Firebase's email instead.
class AuthEmailApi {
  static Future<bool> _post(String path, Map<String, dynamic> body, {String? token}) async {
    try {
      final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
      if (token != null) headers['Authorization'] = 'Bearer $token';
      final response = await http
          .post(Uri.parse('${ApiConstant.getBaseURL()}api/client/user/$path'), headers: headers, body: jsonEncode({...body, 'source': 'app'}))
          .timeout(const Duration(seconds: 15));
      final json = jsonDecode(response.body);
      return json is Map && json['status'] == true;
    } catch (e) {
      Utils.showLog("Auth email error :: $e");
      return false;
    }
  }

  static Future<bool> sendVerification(String firebaseToken) => _post('sendVerificationEmail', {}, token: firebaseToken);

  static Future<bool> sendPasswordReset(String email) => _post('sendPasswordResetEmail', {'email': email});
}
