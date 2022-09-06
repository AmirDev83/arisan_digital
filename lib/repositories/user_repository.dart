import 'dart:convert';

import 'package:arisan_digital/models/user_model.dart';
import 'package:arisan_digital/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final _baseURL = dotenv.env['BASE_URL'].toString();
  final AuthRepository _authRepo = AuthRepository();
  String? _token;

  Future getToken() async {
    _token = await _authRepo.getToken();
  }

  Future<UserModel?> user() async {
    try {
      await getToken();
      if (kDebugMode) {
        print('Token : $_token');
      }
      var response = await http.get(Uri.parse('$_baseURL/user'), headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json'
      });

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return UserModel.fromJson(jsonResponse['data']);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }
}
