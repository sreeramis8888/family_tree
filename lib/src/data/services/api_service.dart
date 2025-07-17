// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:familytree/src/data/utils/secure_storage.dart';

// class ApiService {
//   static const String baseUrl = 'YOUR_API_BASE_URL'; // Replace with your actual API base URL

//   static Future<Map<String, dynamic>> _getHeaders() async {
//     final token = await SecureStorage.read('token');
//     return {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//   }

//   static Future<http.Response> get(String endpoint) async {
//     final headers = await _getHeaders();
//     final response = await http.get(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: headers,
//     );
//     return response;
//   }

//   static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
//     final headers = await _getHeaders();
//     final response = await http.post(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: headers,
//       body: jsonEncode(body),
//     );
//     return response;
//   }

//   static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
//     final headers = await _getHeaders();
//     final response = await http.put(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: headers,
//       body: jsonEncode(body),
//     );
//     return response;
//   }

//   static Future<http.Response> delete(String endpoint) async {
//     final headers = await _getHeaders();
//     final response = await http.delete(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: headers,
//     );
//     return response;
//   }
// } 