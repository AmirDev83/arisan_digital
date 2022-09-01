import 'dart:convert';

import 'package:arisan_digital/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final _baseURL = dotenv.env['BASE_URL'].toString();

  Future login({String? email, String? name, int? googleId}) async {
    try {
      final response = await http.post(Uri.parse('$_baseURL/auth/login'),
          body: {
            'email': email,
            'name': name,
            'google_id': googleId,
            'device_name': 'mobile'
          });

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Koneksi dengan server bermasalah');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return e.toString();
    }
  }

  Future user(String token) async {
    try {
      var response = await http.get(Uri.parse('$_baseURL/auth/user'), headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      });

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return UserModel.fromJson(jsonResponse['data']);
        }
      } else {
        throw Exception('Koneksi dengan server bermasalah.');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future logout(String token) async {
    try {
      var response = await http.post(Uri.parse('$_baseURL/logout'), headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      });

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Koneksi dengan server bermasalah');
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
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
