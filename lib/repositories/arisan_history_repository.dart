import 'dart:convert';

import 'package:arisan_digital/models/arisan_history_model.dart';
import 'package:arisan_digital/models/response_model.dart';
import 'package:arisan_digital/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ArisanHistoryRepository {
  final _baseURL = dotenv.env['BASE_URL'].toString();
  final AuthRepository _authRepo = AuthRepository();
  String? _token;

  ArisanHistoryRepository() {
    getToken();
  }

  Future getToken() async {
    _token = await _authRepo.getToken();
  }

  Future<ResponseModel?> createArisanHistory(
      ArisanHistoryModel arisanHistory) async {
    try {
      final response =
          await http.post(Uri.parse('$_baseURL/arisan-history/store'),
              headers: {
                'Authorization': 'Bearer $_token',
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
              body: json.encode({
                'member_id': arisanHistory.winner!.id,
                'group_id': arisanHistory.winner!.group!.id,
                'date': arisanHistory.date,
                'notes': arisanHistory.notes
              }));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return ResponseModel.fromJson(jsonResponse);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  Future<List<ArisanHistoryModel>?> getArisanHistory(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseURL/arisan-histories/$id'), headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json'
      });

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<ArisanHistoryModel> listArisanHistories =
            iterable.map((e) => ArisanHistoryModel.fromJson(e)).toList();
        return listArisanHistories;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  Future<ArisanHistoryModel?> showArisanHistory(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/arisan-history/$id'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json'
          });

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return ArisanHistoryModel.fromJson(data);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  Future<ResponseModel?> deleteArisanHistory(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$_baseURL/arisan-history/delete/$id'), headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json'
      });

      // Error handling
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return ResponseModel.fromJson(jsonResponse);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }
}
