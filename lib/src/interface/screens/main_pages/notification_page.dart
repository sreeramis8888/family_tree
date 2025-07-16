<<<<<<< HEAD
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/data/api_routes/notification_api/notification_api.dart';
=======
import 'dart:developer';

import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:familytree/src/data/api_routes/notification_api/notification_api.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9

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
<<<<<<< HEAD
              title: const Text(
=======
              title: Text(
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
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
<<<<<<< HEAD
                      // ✅ Filter to only show approved notifications
                      final approvedNotifications = notifications
                          .where((notif) => notif.status == 'approved')
                          .toList();

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
                      child: Text('Error loading notifications'),
                    ),
=======
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          bool userExists =
                              notifications[index].users?.any((user) {
                                    return user.userId == id;
                                  }) ??
                                  false;
                          log(userExists.toString());
                          return _buildNotificationCard(
                            readed: userExists,
                            subject: notifications[index].subject ?? '',
                            content: notifications[index].content ?? '',
                            dateTime: notifications[index].updatedAt!,
                          );
                        },
                        padding: EdgeInsets.all(0.0),
                      );
                    },
                    loading: () => Center(child: LoadingAnimation()),
                    error: (error, stackTrace) {
                      return Center(
                        child: Text(''),
                      );
                    },
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
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
<<<<<<< HEAD
    required VoidCallback onTap,
=======
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
  }) {
    String time = timeAgo(dateTime);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
<<<<<<< HEAD
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
=======
      child: Card(
        elevation: 1,
        color: readed ? Color(0xFFF2F2F2) : kWhite,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!readed)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Icon(Icons.circle, color: Colors.blue, size: 12),
                    ),
                  SizedBox(width: 8),
                  Expanded(
                    // Allows subject text to take full space
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
              SizedBox(height: 8),
              Text(
                content,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                softWrap: true, // Allows text to wrap
              ),
              SizedBox(height: 8),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
          ),
        ),
      ),
    );
  }
}

String timeAgo(DateTime pastDate) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(pastDate);

<<<<<<< HEAD
  if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
=======
  // Get the number of days, hours, and minutes
  int days = difference.inDays;
  int hours = difference.inHours % 24;
  int minutes = difference.inMinutes % 60;

  // Generate a human-readable string based on the largest unit
  if (days > 0) {
    return '$days day${days > 1 ? 's' : ''} ago';
  } else if (hours > 0) {
    return '$hours hour${hours > 1 ? 's' : ''} ago';
  } else if (minutes > 0) {
    return '$minutes minute${minutes > 1 ? 's' : ''} ago';
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
  } else {
    return 'Just now';
  }
}
<<<<<<< HEAD

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
=======
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
