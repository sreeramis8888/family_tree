import 'dart:convert';
import 'dart:developer';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/models/finance_model.dart';
part 'finance_api.g.dart';

class FinanceApiService {
  static final _baseUrl = '$baseUrl/finance';

  static Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        'accept': '*/*',
        // 'Authorization': 'Bearer $token',
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
    final url = Uri.parse('$_baseUrl/finance/$id');
    final response = await http.get(url, headers: _headers());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return FinancialAssistance.fromJson(data['data']['member']);
    } else {
      final data = json.decode(response.body);
      log(data);
      return null;
    }
  }

  static Future<List<FinancialAssistance>> getAllProgramMembers({
    int page = 1,
    int limit = 20,
    String? membershipStatus,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      'sortBy': sortBy,
      'sortOrder': sortOrder,
      if (membershipStatus != null) 'membershipStatus': membershipStatus,
    };
    final uri =
        Uri.parse('$_baseUrl/finance').replace(queryParameters: queryParams);
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
    double? amount,
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
Future<List<FinancialAssistance>> getAllProgramMembers(
  Ref ref, {
  int page = 1,
  int limit = 20,
  String? membershipStatus,
  String sortBy = 'createdAt',
  String sortOrder = 'desc',
}) {
  return FinanceApiService.getAllProgramMembers(
    page: page,
    limit: limit,
    membershipStatus: membershipStatus,
    sortBy: sortBy,
    sortOrder: sortOrder,
  );
}

@riverpod
Future<bool> joinProgram(
  Ref ref, {
  required String memberId,
  String? membershipStatus,
  double? amount,
}) {
  return FinanceApiService.joinProgram(
    memberId: memberId,
    membershipStatus: membershipStatus,
    amount: amount,
  );
}
