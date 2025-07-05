import 'dart:convert';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/services/api_service.dart';
part 'news_api.g.dart';

@riverpod
Future<List<News>> fetchNews(FetchNewsRef ref) async {
  final url = Uri.parse('$baseUrl/news/user');
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
    List<News> news = [];

    for (var item in data) {
      news.add(News.fromJson(item));
    }
    print(news);
    return news;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

// final fetchNewsProvider = FutureProvider<List<News>>((ref) async {
//   final response = await ApiService.get('/news');
//   if (response.statusCode == 200) {
//     final List<dynamic> data = json.decode(response.body);
//     return data.map((json) => News.fromJson(json)).toList();
//   }
//   throw Exception('Failed to load news');
// });

// final fetchBookmarkedNewsProvider = FutureProvider<List<News>>((ref) async {
//   final response = await ApiService.get('/news/bookmarked');
//   if (response.statusCode == 200) {
//     final List<dynamic> data = json.decode(response.body);
//     return data.map((json) => News.fromJson(json)).toList();
//   }
//   throw Exception('Failed to load bookmarked news');
// });

// final checkBookmarkProvider = FutureProvider.family<bool, String>((ref, newsId) async {
//   final response = await ApiService.get('/news/$newsId/bookmark/status');
//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     return data['isBookmarked'] ?? false;
//   }
//   throw Exception('Failed to check bookmark status');
// });

// final addBookmarkProvider = FutureProvider.family<void, String>((ref, newsId) async {
//   final response = await ApiService.post('/news/$newsId/bookmark', {});
//   if (response.statusCode != 200 && response.statusCode != 201) {
//     throw Exception('Failed to add bookmark');
//   }
// });

// final removeBookmarkProvider = FutureProvider.family<void, String>((ref, newsId) async {
//   final response = await ApiService.delete('/news/$newsId/bookmark');
//   if (response.statusCode != 200 && response.statusCode != 204) {
//     throw Exception('Failed to remove bookmark');
//   }
// });
