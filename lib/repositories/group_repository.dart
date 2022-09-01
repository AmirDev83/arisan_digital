import 'dart:convert';

import 'package:arisan_digital/models/group_model.dart';
import 'package:arisan_digital/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GroupRepository {
  final _baseURL = "";
  String? _token;

  GroupRepository() {
    // Run shared preferences to get token

    _token = "your token";
  }

  Future<List<GroupModel>?> getGroups(UserModel user) async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/groups/${user.id}'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json'
          });

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
        List<GroupModel> listGroups =
            iterable.map((e) => GroupModel.fromJson(e)).toList();
        return listGroups;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }
}
