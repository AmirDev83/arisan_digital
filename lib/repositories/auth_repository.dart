import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class AuthRepository {
  final _baseURL = dotenv.env['BASE_URL'].toString();
  String? _token;

  Future<String?> login({String? email, String? name, String? googleId}) async {
    try {
      final response = await http.post(Uri.parse('$_baseURL/login'), body: {
        'email': email,
        'name': name,
        'google_id': googleId,
        'device_name': 'mobile'
      });

      // Error handling
      if (response.statusCode == 200) {
        var token = json.decode(response.body)['data']['token'];
        if (token != null) {
          setToken(token);
        }
        return token;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  Future logout() async {
    try {
      await getToken();
      var response = await http.post(Uri.parse('$_baseURL/logout'), headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json'
      });

      // Error handling
      if (response.statusCode == 200) {
        await _googleSignIn.signOut();
        await removeToken();
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    return _token;
  }

  Future setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  Future removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }
}
