import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/interface/screens/approvals/Event_view.dart';
import 'package:familytree/src/interface/screens/approvals/Notification_view.dart';
import 'package:familytree/src/interface/screens/approvals/member_view.dart';
import 'package:familytree/src/interface/screens/approvals/post_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApprovedTab extends StatelessWidget {
  final List<Map<String, String>> data;

  const ApprovedTab({super.key, required this.data});

  void showDetailsBottomSheet(
      BuildContext context, String view, String status, id,String familyName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        switch (view) {
          case 'Member':
            return DetailsSheet(
              status: status,
              requestId: id, familyName: familyName,
            );
          case 'Event':
            return EventDetailsSheet(
              status: status,
              eventId: id,
            );
          case 'Post':
            return PostDetailsSheet(
              status: status,
              postId: id,
            );
          case 'Notification':
            return NotificationDetailsSheet(
              status: status,
              notificationid: id,
            );
          default:
            return const Center(child: Text('Unknown View'));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No approved data found.'));
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final approval = data[index];
        final title = approval['title'] ?? 'No Title';
        final subtitle = approval['subtitle'] ?? 'No Subtitle';
        final view = approval['view'] ?? 'Unknown';
        final status = approval['status'] ?? 'Unknown';
        final familyName = approval['family'];

        return ApprovalCard(
            title: title,
            subtitle: subtitle,
            onView: () =>
                showDetailsBottomSheet(context, view, status, approval['_id']!,approval['family']!),
            view: approval['view']!,
            familyName: approval['family']!
,);
      },
    );
  }
}

class ApprovalCard extends StatelessWidget {
  final String familyName;
  final String title;
  final String view;
  final String subtitle;
  final VoidCallback onView;

  const ApprovalCard({
    super.key,
    required this.familyName,
    required this.view,
    required this.title,
    required this.subtitle,
    required this.onView,
  });

  bool get isMember => view.toLowerCase().contains('member');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isMember)
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/image/approval-profile.jpg'),
            ),
          if (isMember) const SizedBox(width: 12),

          // Text section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 1.31, // 131% line height
                      letterSpacing: 0, // Adjust if needed
                      color: Color(0xff272727)),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  isMember ? familyName : subtitle,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    height: 1.31, // 131% line height
                    letterSpacing: 0,
                    color: const Color(0xff979797),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Icon + Approved badge
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_red_eye_rounded,
                  color: Colors.grey,
                ),
                onPressed: onView,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Approved',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
