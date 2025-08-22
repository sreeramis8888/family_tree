import 'dart:convert';
import 'package:familytree/src/data/api_routes/notification_api/notification_api.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/screens/approvals/approvals_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/notification_model.dart';

class NotificationDetailsSheet extends ConsumerWidget {
  final String status;
  final String notificationid;

  const NotificationDetailsSheet({
    super.key,
    required this.status,
    required this.notificationid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifFuture =
        ref.watch(getSingleNotificationByIdProvider(notificationid));

    return notifFuture.when(
      loading: () => const Center(child: LoadingAnimation()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (notifData) {
        final notification = notifData.notification;
        final fullName = notifData.fullName;
        final phone = notifData.phone;
        final mediaUrl = notification.media ?? '';

        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text(
                      'Details',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 18),
                    if (status != 'Unpublished')
                      _buildDetailRow(
                        'Notification Status',
                        status,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: status == 'Approved'
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),
                    _buildDetailRow('Member Name', fullName),
                    const SizedBox(height: 18),
                    _buildDetailRow('Mobile Number', phone),
                    const SizedBox(height: 18),
                    _buildDetailRow(
                        'Notification Title', notification.subject ?? 'N/A',
                        isLarge: true),
                    const SizedBox(height: 18),
                    _buildDetailRow('Content', notification.content ?? '',
                        isLarge: true),
                    const SizedBox(height: 18),
                    _buildDetailRow(
                      'Media',
                      mediaUrl,
                      child: mediaUrl.isEmpty
                          ? const Icon(Icons.image_not_supported)
                          : GestureDetector(
                              onTap: () {},
                              child: Image.network(
                                mediaUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.image_not_supported),
                              ),
                            ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Target Audience',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: notification.targetFamily.map((target) {
                          return Chip(
                            label: Text(
                              target.familyName ?? 'Family',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            backgroundColor: const Color(0xFFF0F0F0),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (status == 'unpublished')
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 237, 235, 235),
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: () async {
                                await updateNotificationStatus(
                                  notificationId: notificationid,
                                  status: "rejected",
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ApprovalsPage(
                                      initialChipIndex: 2,
                                      initialTabIndex: 0,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Reject',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF228B22),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: () async {
                                await updateNotificationStatus(
                                  notificationId: notificationid,
                                  status: "approved",
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ApprovalsPage(
                                      initialChipIndex: 2,
                                      initialTabIndex: 0,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Approve',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value,
      {Widget? child, bool isLarge = false}) {
    return Container(
      width: double.infinity,
      height: isLarge ? 134 : 60,
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.topRight,
              child: child ??
                  Text(
                    value,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: isLarge ? 5 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
