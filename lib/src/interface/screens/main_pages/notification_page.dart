import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/data/api_routes/notification_api/notification_api.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncNotification = ref.watch(fetchNotificationsProvider);

        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              ref.invalidate(fetchNotificationsProvider);
            }
          },
          child: Scaffold(
            backgroundColor: kWhite,
            appBar: AppBar(
              title: const Text(
                "Notifications",
                style: TextStyle(fontSize: 17),
              ),
              backgroundColor: kWhite,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  asyncNotification.when(
                    data: (notifications) {
                      final approvedNotifications = notifications
                          .where((notif) => notif.status == 'approved')
                          .toList();
                      if (approvedNotifications.isEmpty) {
                        return Center(child: Text('No Notifications'));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: approvedNotifications.length,
                        itemBuilder: (context, index) {
                          final notif = approvedNotifications[index];
                          final userExists = notif.users?.any(
                                (user) => user.userId == id,
                              ) ??
                              false;
                          final notifId = notif.id ?? '';

                          return _buildNotificationCard(
                            readed: userExists,
                            subject: notif.subject ?? '',
                            content: notif.content ?? '',
                            dateTime: notif.updatedAt!,
                            onTap: () async {
                              if (!userExists &&
                                  notifId.isNotEmpty &&
                                  notif.status == 'approved') {
                                await markNotificationAsRead(notifId);
                                ref.invalidate(fetchNotificationsProvider);
                              }
                            },
                          );
                        },
                        padding: EdgeInsets.zero,
                      );
                    },
                    loading: () => const Center(child: LoadingAnimation()),
                    error: (error, stackTrace) => const Center(
                      child: Text('No notifications'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard({
    required bool readed,
    required String subject,
    required String content,
    required DateTime dateTime,
    required VoidCallback onTap,
  }) {
    String time = timeAgo(dateTime);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 1,
          color: readed ? const Color(0xFFF2F2F2) : kWhite,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!readed)
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Icon(Icons.circle, color: Colors.blue, size: 12),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        subject,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  softWrap: true,
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String timeAgo(DateTime pastDate) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(pastDate);

  if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}

Future<void> markNotificationAsRead(String notificationId) async {
  try {
    final url = Uri.parse('$baseUrl/notifications/$notificationId/read');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      log('Notification $notificationId marked as read');
    } else {
      log('Failed to mark notification as read: ${response.body}');
    }
  } catch (e) {
    log('Exception marking notification as read: $e');
  }
}
