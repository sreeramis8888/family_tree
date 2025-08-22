import 'dart:convert';
import 'dart:developer';
import 'package:familytree/src/data/models/feeds_model.dart';
import 'package:familytree/src/interface/screens/approvals/post_view.dart'
    hide FeedWithPerson;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:http/http.dart' as http;
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/business_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'requirements_api.g.dart';

Future<FeedWithPerson> fetchFeedWithPerson(String feedId) async {
  final feedResponse = await http.get(
    Uri.parse('$baseUrl/feeds/$feedId'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (feedResponse.statusCode != 200) {
    throw Exception('Failed to load feed');
  }

  final decoded = jsonDecode(feedResponse.body);
  final data = decoded['data'];

  final feed = (data is List)
      ? Feed.fromJson(data[0]) // handles if `data` is a List
      : Feed.fromJson(data);

  final personResponse = await http.get(
    Uri.parse('$baseUrl/people/${feed.authorId}'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (personResponse.statusCode != 200) {
    throw Exception('Failed to load person details');
  }

  final personJson = jsonDecode(personResponse.body)['data'];

  return FeedWithPerson(
    feed: feed,
    fullName: personJson['fullName'] ?? 'N/A',
    phone: personJson['phone'] ?? 'N/A',
  );
}

Future<void> updateFeedStatus({
  required String feedId,
  required String action,
  String? reason,
}) async {
  final url = Uri.parse('$baseUrl/feeds/$feedId/$action');

  try {
    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: action == 'reject'
          ? jsonEncode({'reason': reason ?? 'No reason provided'})
          : null,
    );

    final contentType = response.headers['content-type'];
    if (contentType == null || !contentType.contains('application/json')) {
      log("⚠️ Expected JSON, got: $contentType");
      throw Exception('Expected JSON response, got HTML or other format');
    }

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      log('✅ ${data['message']}');
    } else {
      log('❌ ${data['message']} failed to update post status');
    }
  } catch (e) {
    throw Exception('❌ Error updating feed: $e');
  }
}

@riverpod
Future<List<Map<String, dynamic>>> filteredFeeds(
    FilteredFeedsRef ref, List<String> memberIds) async {
  try {
    final url = Uri.parse('$baseUrl/feeds/family/all');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch feeds: ${response.body}');
    }

    final data = jsonDecode(response.body)['data'] as List;
    final filtered = data
        .where((feed) =>
            feed['authorModel'] == 'Person' &&
            memberIds.contains(feed['author']['_id']))
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return filtered;
  } catch (e) {
    throw Exception('Error fetching filtered feeds: $e');
  }
}

Future<void> createFeed({
  required String type, // Required: post, event, news, etc.
  String? media, // Optional: image/video URL
  String? link, // Optional: any external link
  String? content, // Optional: text content
}) async {
  final url = Uri.parse('$baseUrl/feeds');

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'type': type,
    if (media != null && media.isNotEmpty) 'media': media,
    if (link != null && link.isNotEmpty) 'link': link,
    if (content != null && content.isNotEmpty) 'content': content,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      log(' Feed created successfully');
    } else {
      log(' Failed to create feed: ${response.statusCode}');
      log('Response body: ${response.body}');
    }
  } catch (e) {
    log(' Error creating feed: $e');
  }
}

@riverpod
Future<List<Business>> fetchBusiness(FetchBusinessRef ref,
    {int pageNo = 1, int limit = 10}) async {
  final response = await http.get(
    Uri.parse('$baseUrl/feeds?pageNo=$pageNo&limit=$limit'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    log(response.body);
    final feedsJson = data['data'] as List<dynamic>? ?? [];
    log(data['message']);
    return feedsJson.map((user) => Business.fromJson(user)).toList();
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    throw Exception('Failed to load Business');
  }
}

@riverpod
Future<List<Business>> fetchMyBusinesses(Ref ref) async {
  final url = Uri.parse('$baseUrl/feeds/my/feed');
  log('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    log(response.body, name: 'MY BUSINESS API');
    List<Business> posts = [];

    for (var item in data) {
      posts.add(Business.fromJson(item));
    }
    log(posts.toString());
    return posts;
  } else {
    log(json.decode(response.body)['message']);
    throw Exception(json.decode(response.body)['message']);
  }
}

Future<void> uploadBusiness(
    {required String? media, required String content}) async {
  final url = Uri.parse('$baseUrl/feeds');

  final headers = {
    'accept': '*/*',
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    if (media != null && media != '') 'media': media,
    'content': content,
  });

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      log('Feed created successfully');
    } else {
      log('Failed to create business: ${response.statusCode}');
      log('Response body: ${response.body}');
    }
  } catch (e) {
    log('Error: $e');
  }
}

Future<void> deletePost(String postId, context) async {
  SnackbarService snackbarService = SnackbarService();
  final url = Uri.parse('$baseUrl/feeds/$postId');
  log('requesting url:$url');
  final response = await http.delete(
    url,
    headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    snackbarService.showSnackBar('Post Deleted Successfully');
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text('Post Deleted Successfully')));
  } else {
    final jsonResponse = json.decode(response.body);
    snackbarService.showSnackBar(jsonResponse['message']);
    log(jsonResponse['message']);
    log('Failed to delete image: ${response.statusCode}');
  }
}
