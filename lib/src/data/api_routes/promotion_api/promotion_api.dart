<<<<<<< HEAD
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/promotion_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'promotion_api.g.dart';

@riverpod
Future<List<Promotion>> fetchPromotions(Ref ref) async {
  final url = Uri.parse('$baseUrl/promotions/user');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    print(response.body);
    List<Promotion> promotions = [];

    for (var item in data) {
      promotions.add(Promotion.fromJson(item));
    }
    print(promotions);
    return promotions;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
=======
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/promotion_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'promotion_api.g.dart';

@riverpod
Future<List<Promotion>> fetchPromotions(Ref ref) async {
  final url = Uri.parse('$baseUrl/promotions/user');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    print(response.body);
    List<Promotion> promotions = [];

    for (var item in data) {
      promotions.add(Promotion.fromJson(item));
    }
    print(promotions);
    return promotions;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
