import 'dart:convert';
import 'dart:developer';
import 'package:familytree/src/data/globals.dart';
import 'package:http/http.dart' as http;


class ReportApiService {
  static final _baseUrl = Uri.parse('$baseUrl/reports');

  static Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        'accept': '*/*',
      };

  

  /// Post Report
  Future<String?> postReport({required Map<String, dynamic> data}) async {
    try {
      final response = await http.post(_baseUrl,
          headers: _headers(), body: jsonEncode(data));
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Report submitted: ${response.body}');
        return 'success';
      } else {
        return decoded['message'];
      }
    } catch (e) {
      log('Exception in posting report: $e');
      return e.toString();
    }
  }

 

 
}

