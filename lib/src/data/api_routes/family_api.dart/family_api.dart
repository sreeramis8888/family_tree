import 'dart:convert';
import 'dart:developer';

import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/family_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family_api.g.dart';

class FamilyApiService {
  static final _baseUrl = Uri.parse('$baseUrl/families');

  static Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      };

  static Future<List<FamilyModel>> fetchAllFamily() async {
    Uri url = Uri.parse('$_baseUrl?is_all=true');

    print('Requesting URL: $url');
    final response = await http.get(
      url,
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      print(response.body);
      List<FamilyModel> families = [];

      for (var item in data) {
        families.add(FamilyModel.fromJson(item));
      }
      log(families.toString());
      return families;
    } else {
      print(json.decode(response.body)['message']);

      throw Exception(json.decode(response.body)['message']);
    }
  }

  static Future<FamilyModel> fetchSingleFamily(
      {required String familyId}) async {
    Uri url = Uri.parse('$_baseUrl/$familyId');

    print('Requesting URL: $_baseUrl/$familyId');
    final response = await http.get(
      url,
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body)['data'];
      return FamilyModel.fromJson(data);
    } else {
      print(json.decode(response.body)['message']);

      throw Exception(json.decode(response.body)['message']);
    }
  }

  static Future<FamilyModel> createFamily(String name) async {
    Uri url = Uri.parse('$_baseUrl');
    log('Creating family with name: $name');
    log('POST URL: $url');

    final response = await http.post(
      url,
      headers: _headers(),
      body: json.encode({"name": name}),
    );

    log('Response status code: ${response.statusCode}');
    log('Response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final dynamic data = json.decode(response.body)["data"];
      log('Family created successfully: $data');
      return FamilyModel.fromJson(data);
    } else {
      final errorMsg =
          json.decode(response.body)["message"] ?? "Failed to create family";
      log('Error creating family: $errorMsg');
      throw Exception(errorMsg);
    }
  }

  // Add or update family media
  static Future<FamilyModel> updateFamilyMedia({
    required String familyId,
    required List<FamilyMedia> media,
  }) async {
    Uri url = Uri.parse('$_baseUrl/$familyId');
    final response = await http.put(
      url,
      headers: _headers(),
      body: json.encode({'media': media.map((m) => m.toJson()).toList()}),
    );
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body)['data'];
      return FamilyModel.fromJson(data);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  // static Future<List<FamilyMemberBasic>> fetchFamilyMembersByPersonId(String personId) async {
  //   // Fetch person
  //   final person = await UserService.fetchUserDetails(personId);
  //   // Use only the data from the person API response
  //   final member = FamilyMemberBasic(
  //     id: person.id,
  //     fullName: person.fullName,
  //     familyName: person.familyName,
  //   );
  //   return [member];
  // }
}

@riverpod
Future<List<FamilyModel>> fetchAllFamily(
  Ref ref,
) {
  return FamilyApiService.fetchAllFamily();
}

@riverpod
Future<FamilyModel> fetchSingleFamily(Ref ref, {required String familyId}) {
  return FamilyApiService.fetchSingleFamily(familyId: familyId);
}

// @riverpod
// Future<List<FamilyMemberBasic>> fetchFamilyMembersByPersonId(Ref ref, String personId) async {
//   return FamilyApiService.fetchFamilyMembersByPersonId(personId);
// }
