import 'dart:convert';
import 'dart:developer';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/models/finance_model.dart';
import 'package:familytree/src/data/models/transaction_model.dart';
part 'finance_api.g.dart';

class FinanceApiService {
  static final _baseUrl = '$baseUrl/finance';

  static Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      };

  static Future<MinimumBalance?> getMinimumBalance() async {
    final url = Uri.parse('$_baseUrl/settings/minimum-balance');
    final response = await http.get(url, headers: _headers());
    log(response.body.toString());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MinimumBalance.fromJson(data['data']);
    } else {
      final data = json.decode(response.body);
      log(data['message']);
      return null;
    }
  }

  static Future<FinancialAssistance?> getProgramMemberById(String id) async {
    final url = Uri.parse('$_baseUrl/$id');
    log('GET request to: $url');

    try {
      final response = await http.get(url, headers: _headers());

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final memberJson = data['data']?['member'];

        if (memberJson == null) {
          log('❗ "member" key is missing or null in response');
          return null;
        }

        try {
          final member = FinancialAssistance.fromJson(memberJson);
          log('✅ Successfully parsed FinancialAssistance');
          return member;
        } catch (e, stackTrace) {
          log('❌ Error parsing FinancialAssistance.fromJson: $e');
          log('Stack trace:\n$stackTrace');
          log('Raw member JSON: $memberJson');
          return null;
        }
      } else {
        final errorData = json.decode(response.body);
        log('❌ Error response [${response.statusCode}]: $errorData');
        return null;
      }
    } catch (e, stackTrace) {
      log('❌ Exception during HTTP call: $e');
      log('Stack trace:\n$stackTrace');
      return null;
    }
  }

  static Future<List<FinancialAssistance>> getAllProgramMembers({
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    final uri = Uri.parse('$_baseUrl').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _headers());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List members = data['data'] as List;
      return members.map((e) => FinancialAssistance.fromJson(e)).toList();
    } else {
      final data = json.decode(response.body);
      log(data);
      return [];
    }
  }

  static Future<bool> joinProgram({
    required String memberId,
    String? membershipStatus,
    int? amount,
  }) async {
    final url = Uri.parse('$_baseUrl/join');
    final body = json.encode({
      'memberId': memberId,
      if (membershipStatus != null) 'membershipStatus': membershipStatus,
      if (amount != null) 'amount': amount,
    });
    final response = await http.post(url, headers: _headers(), body: body);
    log(response.body.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      SnackbarService().showSnackBar('Failed to join program');
      return false;
    }
  }

  static Future<List<ProgramMember>> getAllFlatProgramMembers({
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    final uri = Uri.parse('$_baseUrl').replace(queryParameters: queryParams);
    log('Requesting Url: $uri');
    final response = await http.get(uri, headers: _headers());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List members = data['data'] as List;
      return members.map((e) => ProgramMember.fromJson(e)).toList();
    } else {
      final data = json.decode(response.body);
      log(data);
      return [];
    }
  }

  static Future<List<TransactionModel>> getAllTransactions({
    int page = 1,
    int limit = 20,
    String? search,
    String? method,
    String? type,
    String? personId,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    String sortBy = 'date',
    String sortOrder = 'desc',
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (search != null) 'search': search,
      if (method != null) 'method': method,
      if (type != null) 'type': type,
      'personId': id,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (minAmount != null) 'minAmount': minAmount.toString(),
      if (maxAmount != null) 'maxAmount': maxAmount.toString(),
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };
    final uri = Uri.parse('$baseUrl/transactions')
        .replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _headers());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List txs = data['data']['transactions'] as List;
      return txs.map((e) => TransactionModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}

@riverpod
Future<MinimumBalance?> getMinimumBalance(Ref ref) {
  return FinanceApiService.getMinimumBalance();
}

@riverpod
Future<FinancialAssistance?> getProgramMemberById(Ref ref, String id) {
  return FinanceApiService.getProgramMemberById(id);
}

@riverpod
Future<List<ProgramMember>> getAllFlatProgramMembers(
  Ref ref, {
  int page = 1,
  int limit = 20,
}) {
  return FinanceApiService.getAllFlatProgramMembers(
    page: page,
    limit: limit,
  );
}

@riverpod
Future<bool> joinProgram(
  Ref ref, {
  required String memberId,
  String? membershipStatus,
  int? amount,
}) {
  return FinanceApiService.joinProgram(
    memberId: memberId,
    membershipStatus: membershipStatus,
    amount: amount,
  );
}

@riverpod
Future<List<TransactionModel>> getAllTransactions(
  Ref ref, {
  int page = 1,
  int limit = 20,
  String? search,
  String? method,
  String? type,
  String? personId,
  String? startDate,
  String? endDate,
  double? minAmount,
  double? maxAmount,
  String sortBy = 'date',
  String sortOrder = 'desc',
}) {
  return FinanceApiService.getAllTransactions(
    page: page,
    limit: limit,
    search: search,
    method: method,
    type: type,
    personId: personId,
    startDate: startDate,
    endDate: endDate,
    minAmount: minAmount,
    maxAmount: maxAmount,
    sortBy: sortBy,
    sortOrder: sortOrder,
  );
}
