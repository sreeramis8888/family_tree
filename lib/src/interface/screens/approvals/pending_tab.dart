import 'package:familytree/src/data/api_routes/events_api/events_api.dart';
import 'package:familytree/src/data/api_routes/notification_api/notification_api.dart';
import 'package:familytree/src/data/api_routes/request_api/request_api.dart';
import 'package:familytree/src/interface/screens/approvals/Event_view.dart';
import 'package:familytree/src/interface/screens/approvals/Notification_view.dart';
import 'package:familytree/src/interface/screens/approvals/member_view.dart';
import 'package:familytree/src/interface/screens/approvals/post_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:familytree/src/data/api_routes/requirements_api/requirements_api.dart';
import 'package:familytree/src/interface/screens/approvals/approvals_page.dart';

const Map<String, int> chipIndexFromView = {
  'Member': 0,
  'Event': 1,
  'Notification': 2,
  'Post': 3,
};

class PendingTab extends StatelessWidget {
  final List<Map<String, String>> data;

  const PendingTab({super.key, required this.data});

  void showDetailsBottomSheet(
      BuildContext context, String view, String status, Id  ,String familyName) {
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
              requestId: Id, familyName: familyName,
            );
          case 'Event':
            return EventDetailsSheet(
              status: status,
              eventId: Id,
            );

          case 'Post':
            return PostDetailsSheet(status: status, postId: Id);
          case 'Notification':
            return NotificationDetailsSheet(status: status, notificationid: Id);
          default:
            return const Center(child: Text('Unknown View'));
        }
      },
    );
  }

  Future<void> _handleStatusUpdate(BuildContext context, String status,
      String view, String id, String title) async {
    try {
      switch (view) {
        case 'Member':
          await updateRequestStatus(requestId: id, status: status);
          break;
        case 'Event':
          await updateEventStatus(eventId: id, status: status);
          break;
        case 'Post':
          await updateFeedStatus(feedId: id, action: status);
          break;
        case 'Notification':
          await updateNotificationStatus(
            notificationId: id,
            status: status,
          );
          break;
        default:
          throw Exception("Unknown view type: $view");
      }

    
      final viewKey = view.split(' – ').first;
      final chipIndex = chipIndexFromView[viewKey] ?? 0;

      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ApprovalsPage(
            initialChipIndex: chipIndex,
            initialTabIndex: 0, // Stay on pending tab
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating $view status: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No pending data found.'));
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final approval = data[index];
        final status = approval['status'] ?? 'Unknown';
       
        return PendingCard(
          title: approval['title']!,
          subtitle: approval['subtitle']!,
          postId: approval['_id']!,
          onView: () => showDetailsBottomSheet(
              context, approval['view']!, status, approval['_id']!,approval['family']!),
          update: (String statusUpdate) => _handleStatusUpdate(
            context,
            statusUpdate,
            approval['view']!,
            approval['_id']!,
            approval['title']!,
          ), view:   approval['view']!, familyName: approval['family']!,
          
        );
      },
    );
  }
}

class PendingCard extends StatelessWidget {
  final String view;
  final String familyName;
  final String title;
  final String subtitle;
  final VoidCallback onView;
  final String postId;
  final Function(String status) update;

  const PendingCard({
    super.key,
    required this.familyName,
    required this.view,
    required this.title,
    required this.subtitle,
    required this.onView,
    required this.postId,
    required this.update,
  });

  bool get isMember => view.toLowerCase().contains('member');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: isMember
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: const Border(
                            bottom:
                                BorderSide(color: Color(0xFFE0E0E0), width: 1),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                  'assets/image/approval-profile.jpg'),
                            ),
                            const SizedBox(width: 12),
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
                                    familyName,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: const Color(0xff979797),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_red_eye_rounded,
                                  color: Colors.grey),
                              onPressed: onView,
                            ),
                          ],
                        ),
                      )
                    : Row(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    height: 1.31,
                                    color: const Color(0xff272727),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subtitle,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    height: 1.31,
                                    color: const Color(0xff979797),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye_rounded,
                                color: Colors.grey),
                            onPressed: onView,
                          ),
                        ],
                      ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => update("rejected"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 229, 227, 227),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 16 / 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => update("approved"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF228B22),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 16 / 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
