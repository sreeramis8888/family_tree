import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:http/http.dart' as http;
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/notification_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_api.g.dart';

/// ✅ Get a single notification by ID (uses `.family`)
@riverpod
Future<NotificationWithPerson> getSingleNotificationById(
  GetSingleNotificationByIdRef ref,
  String notificationId,
) async {
  log('📡 [getSingleNotificationById] START for ID: $notificationId');

  final url = Uri.parse('$baseUrl/notifications/$notificationId');
  log('🌐 Requesting Notification URL: $url');

  try {
    final notifResponse = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    log('📥 Notification Response Status: ${notifResponse.statusCode}');

    if (notifResponse.statusCode != 200) {
      log('❌ Failed to fetch notification, response: ${notifResponse.body}');
      throw Exception('Failed to fetch notification');
    }

    final notifJson = jsonDecode(notifResponse.body)['data'];
    log('✅ Notification JSON parsed');

    final notification = NotificationModel.fromJson(notifJson);
    log('🧩 Notification Model created');

    final creatorId = notifJson['createdBy'] is String
        ? notifJson['createdBy']
        : notifJson['createdBy']['_id'];
    log('👤 Creator ID resolved: $creatorId');

    final personResponse = await http.get(
      Uri.parse('$baseUrl/people/$creatorId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    log('📥 Person Response Status: ${personResponse.statusCode}');

    if (personResponse.statusCode != 200) {
      throw Exception('Failed to load person details');
    }

    final personJson = jsonDecode(personResponse.body)['data'];
    log('✅ Person JSON parsed');

    return NotificationWithPerson(
      notification: notification,
      fullName: personJson['fullName'] ?? 'N/A',
      phone: personJson['phone'] ?? 'N/A',
    );
  } catch (e) {
    log('❌ Error fetching single notification: $e');
    throw Exception('Error fetching notification: $e');
  }
}

/// ✅ Filtered notifications for specific member IDs
@riverpod
Future<List<Map<String, dynamic>>> filteredNotifications(
  FilteredNotificationsRef ref,
  List<String> memberIds,
) async {
  log('📡 [filteredNotifications] START for members: $memberIds');

  try {
    final url = Uri.parse('$baseUrl/notifications/family/all');
    log('🌐 Requesting filtered notifications: $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    log('📥 Response Status: ${response.statusCode}');

    if (response.statusCode != 200) {
      log('❌ Failed response: ${response.body}');
      throw Exception('Failed to fetch notifications');
    }

    final data = jsonDecode(response.body)['data'] as List;
    log('✅ Total Notifications: ${data.length}');

    final filtered = data
        .where((notif) {
          final creator = notif['createdBy'];
          final creatorId = creator is String ? creator : creator['_id'];
          final valid = creatorId != null && memberIds.contains(creatorId);
          if (!valid) log('🚫 Skipping creatorId: $creatorId');
          return valid;
        })
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    log('✅ Filtered Notifications: ${filtered.length}');
    return filtered;
  } catch (e) {
    log('❌ Error fetching filtered notifications: $e');
    throw Exception('Error fetching filtered notifications: $e');
  }
}
@riverpod
Future<List<NotificationModel>> fetchNotifications(Ref ref) async {
  final url = Uri.parse('$baseUrl/notifications/$id');
  print('Requesting URL: $url');

  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');

  try {
    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final rawData = decoded['data'];

      // ✅ Safely default to an empty list if data is null or not a list
      if (rawData == null || rawData is! List) {
        return []; // <-- no exception, just return empty list
      }

      return rawData.map((item) => NotificationModel.fromJson(item)).toList();
    } else {
      throw Exception(decoded['message'] ?? 'Unknown error');
    }
  } catch (e, st) {
    print('❌ Exception: $e');
    print('📍 StackTrace: $st');
    throw Exception("Error fetching push notification");
  }
}


/// ✅ Create a notification
Future<void> createLevelNotification({
  required String level,
  required List<String> id,
  required String subject,
  required String content,
  String? media,
}) async {
  log('📡 [createLevelNotification] START');

  final url = Uri.parse('$baseUrl/notification/level');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  final body = jsonEncode({
    'level': level,
    'id': id,
    'subject': subject,
    'content': content,
    'type': 'in-app',
    if (media != null) 'media': media,
  });

  log('📤 Sending notification to IDs: $id');
  log('📝 Payload: $body');

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    final snackbarService = SnackbarService();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log('✅ Notification created: ${data['message']}');
      snackbarService.showSnackBar(data['message']);
    } else {
      final error = jsonDecode(response.body);
      log('❌ Notification creation failed: ${error['message']}');
      snackbarService.showSnackBar(error['message']);
    }
  } catch (e) {
    log('❌ Exception while sending notification: $e');
  }
}

/// ✅ Update notification status
Future<void> updateNotificationStatus({
  required String notificationId,
  required String status,
}) async {
  log('📡 [updateNotificationStatus] START: $notificationId → $status');

  final url = Uri.parse('$baseUrl/notifications/$notificationId');
  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
  final body = jsonEncode({'status': status});
  final snackbarService = SnackbarService();

  try {
    final response = await http.put(
      url,
      headers: headers,
      body: body,
    );

    log('📥 PUT response: ${response.statusCode}');

    if (response.statusCode == 200 &&
        response.headers['content-type']?.contains('application/json') ==
            true) {
      final message = jsonDecode(response.body)['message'];
      log('✅ Status updated successfully: $message');
      snackbarService.showSnackBar(message ?? 'Status updated');
    } else {
      try {
        final error = jsonDecode(response.body)['message'];
        log('❌ Server error: $error');
        snackbarService.showSnackBar(error ?? 'Failed to update status');
      } catch (_) {
        log('❌ Unexpected non-JSON error: ${response.body}');
        snackbarService
            .showSnackBar('Unexpected error: ${response.statusCode}');
      }
    }
  } catch (e) {
    log('❌ Exception while updating status: $e');
    snackbarService.showSnackBar('Something went wrong');
  }
}
