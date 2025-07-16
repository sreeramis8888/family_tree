import 'package:familytree/src/data/api_routes/events_api/events_api.dart';
import 'package:familytree/src/data/api_routes/notification_api/notification_api.dart';
import 'package:familytree/src/data/api_routes/request_api/request_api.dart';
import 'package:familytree/src/data/api_routes/requirements_api/requirements_api.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/screens/approvals/Event_view.dart';
import 'package:familytree/src/interface/screens/approvals/Notification_view.dart';
import 'package:familytree/src/interface/screens/approvals/approvals_page.dart';
import 'package:familytree/src/interface/screens/approvals/member_view.dart';
import 'package:familytree/src/interface/screens/approvals/pending_tab.dart';
import 'package:familytree/src/interface/screens/approvals/post_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ApprovalSearchPage extends StatefulWidget {
  final Map<String, List<Map<String, String>>> pending;
  final Map<String, List<Map<String, String>>> approved;
  final Map<String, List<Map<String, String>>> rejected;

  const ApprovalSearchPage({
    super.key,
    required this.pending,
    required this.approved,
    required this.rejected,
  });

  @override
  State<ApprovalSearchPage> createState() => _ApprovalSearchPageState();
}

class _ApprovalSearchPageState extends State<ApprovalSearchPage> {
  TextEditingController searchController = TextEditingController();
  String query = '';
  List<Map<String, String>> allItems = [];
bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    mergeAllApprovals();
      _isLoading = false;
  }

  void mergeAllApprovals() {
    void merge(String status, Map<String, List<Map<String, String>>> map) {
      map.forEach((category, items) {
        for (final item in items) {
          allItems.add({
            ...item,
            'category': category,
            'Status': status,
          });
        }
      });
    }

    merge('Pending', widget.pending);
    merge('Approved', widget.approved);
    merge('Rejected', widget.rejected);
  }

  String? profileImagePath;

  void showDetailsBottomSheet(
      BuildContext context, String view, String status, String id,String familyname) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        switch (view) {
          case 'Member':
            return DetailsSheet(status: status, requestId: id, familyName: familyname,);
          case 'Event':
            return EventDetailsSheet(status: status, eventId: id,);
          case 'Post':
            return PostDetailsSheet(status: status, postId: id);
          case 'Notification':
            return NotificationDetailsSheet(status: status, notificationid: id,);
          default:
            return const Center(child: Text('Unknown View'));
        }
      },
    );
  }
  
  Future<void> _handleStatusUpdate(BuildContext context, String status,
      String view, String id, ) async {
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

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$view $status successfully'),
        backgroundColor: Colors.green,
      ));

      // Extract the view label from title like "Notification – Subject"
      final viewKey = view.split(' – ').first;
      final chipIndex = chipIndexFromView[viewKey] ?? 0;

      // Navigate to updated approvals page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ApprovalsPage(
            initialChipIndex: chipIndex,
            initialTabIndex: 2, // Stay on pending tab
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
    final filtered = allItems.where((item) {
      final title = item['title']?.toLowerCase() ?? '';
      final subtitle = item['subtitle']?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase()) ||
          subtitle.contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: LoadingAnimation())
          :  Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/icons/search.svg',
                    width: 17,
                    height: 17,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        height: 1.0,
                        letterSpacing: -0.17,
                        color: const Color(0xff979797),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search Approvals',
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() => query = val);
                      },
                    ),
                  ),
                  if (query.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        searchController.clear();
                        setState(() => query = '');
                      },
                      child: const Icon(Icons.close, color: Colors.black),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (filtered.isEmpty)
              const Text("No results found.")
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final id = item['_id'] ?? '';
                    final rawTitle = item['title'] ?? '';
                    final subtitle = item['subtitle'] ?? '';
                    final category = item['category'] ?? '';
                    final status = item['Status'] ?? '';
                    final isMember = category == 'Member';
                    final cleanTitle = rawTitle.contains('–')
                        ? rawTitle.split('–').last.trim()
                        : rawTitle;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isMember)
                               const CircleAvatar(
                                        radius: 20,
                                        backgroundImage: AssetImage(
                                            'assets/image/approval-profile.jpg'),
                                      ),
                              if (isMember) const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cleanTitle,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: const Color(0xff272727),
                                        height: 1.31,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                            isMember ? item['family']! : subtitle,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => showDetailsBottomSheet(
                                      context,
                                      item['view']!,
                                      status,
                                      id,item['family']!
                                    ),
                                  ),
                                  if (status != 'Pending')
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(status),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        status,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                        
                          if (status == 'Pending')
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                border: isMember
                                    ? const Border(
                                        top: BorderSide(
                                          color: Color.fromARGB(
                                              185, 158, 158, 158),
                                          width: 1,
                                        ),
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFF3F0F0),
                                        foregroundColor: Colors.black,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () =>
                                                _handleStatusUpdate(
                                              context,
                                      
                                              "rejected",
                                                      item['view']!,
                                              id,
                                            ),
                                      child: Text(
                                        'Reject',
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          height: 16 / 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF228B22),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                       onPressed: () =>
                                                _handleStatusUpdate(
                                              context,
                                             
                                              "approved",
                                               item['view']!,
                                              id
                                            ),
                                      child: Text(
                                        'Approve',
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          height: 16 / 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
