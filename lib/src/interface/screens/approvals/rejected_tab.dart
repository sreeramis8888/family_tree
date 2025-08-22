import 'package:familytree/src/interface/screens/approvals/Event_view.dart';
import 'package:familytree/src/interface/screens/approvals/Notification_view.dart';
import 'package:familytree/src/interface/screens/approvals/member_view.dart';
import 'package:familytree/src/interface/screens/approvals/post_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RejectedTab extends StatelessWidget {
  final List<Map<String, String>> data;

  const RejectedTab({super.key, required this.data});

  void showDetailsBottomSheet(
      BuildContext context, String view, String status, Id, String familyName, ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        switch (view) {
          case 'Member':
            // ✅ Fallback to 'Rejected' if null
            return DetailsSheet(
              status: status,
              requestId: Id, familyName: familyName,
            );
          case 'Event':
            return EventDetailsSheet(
              status: status,
              eventId: Id,
            );
          case 'Post':
            return PostDetailsSheet(
              status: status,
              postId: Id,
            );
          case 'Notification':
            return NotificationDetailsSheet(
              status: status,
              notificationid: Id,
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
      return const Center(child: Text('No rejected data found.'));
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final approval = data[index];

        // ✅ Fallbacks for missing fields
        final title = approval['title'] ?? 'No Title';
        final subtitle = approval['subtitle'] ?? 'No Subtitle';
        final view = approval['view'] ?? 'Unknown';
        final status = approval['status'] ?? 'Unknown';

        return RejectedCard(
          title: title,
          subtitle: subtitle,
          onView: () =>
              showDetailsBottomSheet(context, view, status, approval['_id']!,approval['family']!),
          view: approval['view']!, familyName: approval['family']!,
        );
      },
    );
  }
}

class RejectedCard extends StatelessWidget {
  final String title;
  final String familyName;
  final String view;
  final String subtitle;
  final VoidCallback onView;

  const RejectedCard({
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

          // Text area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 4),
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

          // Eye icon + Rejected badge aligned vertically
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
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Rejected',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      height: 16 / 14, // ≈ 1.14
                      letterSpacing: 0,
                      color: Color(0xffFFFBF3)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
