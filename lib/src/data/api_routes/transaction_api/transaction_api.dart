import 'dart:convert';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class TransactionApiService {
  /// Fetch all transactions with optional filters
  static Future<List<TransactionModel>> getTransactions({
    String? type,
    String? method,
    String? userId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final Map<String, String> queryParams = {};

      if (type != null) queryParams['type'] = type;
      if (method != null) queryParams['method'] = method;
      if (userId != null) queryParams['userId'] = userId;
      if (fromDate != null) queryParams['from'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['to'] = toDate.toIso8601String();

      final uri = Uri.parse('$baseUrl/transactions')
          .replace(queryParameters: queryParams);

      debugPrint('🔍 [GET] $uri');

      final response = await http.get(uri);

      debugPrint('📦 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body['data'] is List) {
          return (body['data'] as List)
              .map((item) => TransactionModel.fromJson(item))
              .toList();
        } else {
          throw Exception('❌ Invalid response format: expected list, got ${body['data'].runtimeType}');
        }
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Unknown error';
        throw Exception('❌ Failed to load transactions: ${response.statusCode}, $errorMsg');
      }
    } catch (e, stack) {
      debugPrint('🔥 Exception: $e');
      
      throw Exception('Transaction fetch error: $e');
    }
  }
}
