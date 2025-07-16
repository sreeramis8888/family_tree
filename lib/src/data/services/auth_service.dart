import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:familytree/src/data/utils/secure_storage.dart';
import 'package:familytree/src/data/globals.dart';

class AuthService {
  static Future<bool> refreshAccessToken() async {
    final refreshToken = await SecureStorage.read('refreshToken');

    debugPrint("📥 Calling /refresh-token with saved refresh token: $refreshToken");

    if (refreshToken == null || refreshToken.isEmpty) {
      debugPrint("❌ No refresh token found");
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh-token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        debugPrint("✅ Refresh token API success");
        debugPrint("🆕 New Access Token: $newAccessToken");
        debugPrint("🆕 New Refresh Token: $newRefreshToken");

        if (newAccessToken != null && newRefreshToken != null) {
          await SecureStorage.write('token', newAccessToken);
          await SecureStorage.write('refreshToken', newRefreshToken);
          token = newAccessToken;
          return true;
        }
      } else {
        debugPrint("❌ Refresh token API failed: ${response.statusCode}");
        debugPrint("🔴 Response body: ${response.body}");
      }
    } catch (e) {
      debugPrint('⚠️ Refresh token error: $e');
    }

    return false;
  }
}
