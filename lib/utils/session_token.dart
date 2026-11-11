import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/preference.dart';

/// Per-user proof for coin and unlock requests (`x-user-session`).
/// A failed lookup never blocks the request: the server decides what to accept.
class SessionToken {
  static String? _token;
  static String? _userId;
  static DateTime? _expires;

  static Future<Map<String, String>> headers() async {
    final token = await _get();
    return token == null ? const {} : {'x-user-session': token};
  }

  static Future<String?> _get() async {
    final userId = Preference.userId;
    if (userId.isEmpty) return null;
    final expires = _expires;
    if (_token != null && _userId == userId && expires != null && expires.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      return _token;
    }
    try {
      final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
      final firebaseToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (firebaseToken != null) headers['Authorization'] = 'Bearer $firebaseToken';
      final response = await http
          .post(
            Uri.parse('${ApiConstant.getBaseURL()}api/client/user/sessionToken'),
            headers: headers,
            body: jsonEncode({'userId': userId, 'identity': Preference.identity}),
          )
          .timeout(const Duration(seconds: 8));
      final body = jsonDecode(response.body);
      if (body is Map && body['status'] == true && body['token'] is String) {
        _token = body['token'] as String;
        _userId = userId;
        _expires = DateTime.tryParse('${body['expiresAt']}');
        return _token;
      }
    } catch (_) {
      // try again on the next request
    }
    return null;
  }
}
