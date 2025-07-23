import 'dart:convert';
import 'dart:developer';

import 'package:familytree/src/data/globals.dart';
import 'package:http/http.dart' as http;

Future<void> likeFeed(String feedId) async {
  final url = Uri.parse('$baseUrl/feeds/$feedId/like');

  try {
    final response = await http.put(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse['message']);
    } else {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse['message']);
      print('Failed to like the feed. Status code: ${response.statusCode}');
      // Handle errors or unsuccessful response here
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

Future<void> postComment(
    {required String feedId, required String comment}) async {
  final url = Uri.parse('$baseUrl/feeds/$feedId/comment');
  log('$baseUrl/feeds/$feedId/comment');
  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'accept': '*/*',
  };

  // Define the request body
  final body = jsonEncode({
    'comment': comment,
  });

  try {
    final response = await http.put(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Comment posted successfully');
    } else {
      print('Failed to post comment: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
