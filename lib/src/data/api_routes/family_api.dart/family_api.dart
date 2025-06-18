
import 'dart:convert';

import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/activity_model.dart';
import 'package:familytree/src/data/models/family_model.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family_api.g.dart';

class FamilyApiService {
  static final _baseUrl = Uri.parse('$baseUrl/families');

  static Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
        'accept': '*/*',
      };


  static Future<List<FamilyModel>> fetchAllFamily(
      {required String chapterId}) async {
    Uri url = Uri.parse('$_baseUrl');

    print('Requesting URL: $url');
    final response = await http.get(
      url,
      headers: _headers(),
    );

    print(json.decode(response.body)['status']);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      print(response.body);
      List<FamilyModel> promotions = [];

      for (var item in data) {
        promotions.add(FamilyModel.fromJson(item));
      }
      print(promotions);
      return promotions;
    } else {
      print(json.decode(response.body)['message']);

      throw Exception(json.decode(response.body)['message']);
    }
  }


}

@riverpod
Future<List<FamilyModel>> fetchAllFamily(Ref ref,
    {required String? chapterId}) {
  return FamilyApiService.fetchAllFamily(chapterId: chapterId ?? '');
}
