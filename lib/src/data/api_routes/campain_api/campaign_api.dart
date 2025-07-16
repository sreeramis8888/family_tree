import 'dart:convert';
import 'dart:developer';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/models/campaign_model.dart';
part 'campaign_api.g.dart';

class CampaignApiService {
  static Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      };

  static Future<bool> createCampaign({
    required Map<String, dynamic> data,
    BuildContext? context,
  }) async {
    final _baseUrl = Uri.parse('$baseUrl/campaigns');
    log(name: 'HITTING API', _baseUrl.toString());
    final snackbarService = SnackbarService();
    try {
      final response = await http.post(
        _baseUrl,
        headers: _headers(),
        body: jsonEncode(data),
      );
      final decoded = json.decode(response.body);
      log(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        snackbarService.showSnackBar(
            decoded['message'] ?? 'Campaign created successfully');
        return true;
      } else {
        log(decoded['message']);
        snackbarService
            .showSnackBar(decoded['message'] ?? 'Failed to create campaign');
        return false;
      }
    } catch (e) {
      snackbarService.showSnackBar('Error: ${e.toString()}');
      return false;
    }
  }

  /// Fetch Campaigns
  static Future<List<CampaignModel>> fetchCampaigns() async {
    try {
      final _baseUrl = Uri.parse('$baseUrl/campaigns');
      log(name: 'HITTING API', _baseUrl.toString());
      final response = await http.get(_baseUrl, headers: _headers());
      final decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = decoded['data'] ?? [];
        return data.map((e) => CampaignModel.fromJson(e)).toList();
      } else {
        throw Exception(decoded['message'] ?? 'Failed to fetch campaigns');
      }
    } catch (e) {
      log(e.toString(), name: 'CAMPAIGN FETCH FAILED');
      return [];
    }
  }

  static Future<List<CampaignModel>> fetchMyCampaigns() async {
    try {
      final _baseUrl = Uri.parse('$baseUrl/campaigns/my-campaigns');
      final response = await http.get(_baseUrl, headers: _headers());
      final decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = decoded['data'] ?? [];
        return data.map((e) => CampaignModel.fromJson(e)).toList();
      } else {
        throw Exception(decoded['message'] ?? 'Failed to fetch campaigns');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}

@riverpod
Future<bool> createCampaign(
  Ref ref, {
  required Map<String, dynamic> data,
  BuildContext? context,
}) {
  return CampaignApiService.createCampaign(data: data, context: context);
}

@riverpod
Future<List<CampaignModel>> fetchCampaigns(Ref ref) {
  return CampaignApiService.fetchCampaigns();
}

@riverpod
Future<List<CampaignModel>> fetchMyCampaigns(Ref ref) {
  return CampaignApiService.fetchMyCampaigns();
}
