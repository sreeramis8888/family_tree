import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:familytree/src/data/api_routes/events_api/events_api.dart'
    as events_api;
import 'package:familytree/src/data/api_routes/notification_api/notification_api.dart'
    as notification_api;
import 'package:familytree/src/data/api_routes/request_api/request_api.dart'
    as request_api;
import 'package:familytree/src/data/api_routes/request_api/request_api.dart';
import 'package:familytree/src/data/api_routes/requirements_api/requirements_api.dart'
    as requirements_api;
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/feeds_model.dart';
import 'package:familytree/src/data/models/request_model.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/screens/approvals/ApprovalSearchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'approved_tab.dart';
import 'pending_tab.dart';
import 'rejected_tab.dart';

class ApprovalsPage extends ConsumerStatefulWidget {
  final int initialChipIndex;
  final int initialTabIndex;

  const ApprovalsPage({
    super.key,
    this.initialChipIndex = 0, // default to "Member Approvals"
    this.initialTabIndex = 0, // default to "Pending" tab
  });

  @override
  ConsumerState<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends ConsumerState<ApprovalsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedChipIndex = 0; // Now will be overridden in initState
  List<String> membername = [];
  List<String> memberIds = [];
  List<Feed> filteredFeeds = [];

  final List<String> chipLabels = [
    'Member Approvals',
    'Event Approvals',
    'Notification Approvals',
    'Post Approvals',
  ];

  final Map<String, List<Map<String, String>>> pendingApprovalsMap = {
    'Member': [],
    'Event': [],
    'Notification': [],
    'Post': [],
  };

  final Map<String, List<Map<String, String>>> approvedApprovalsMap = {
    'Member': [],
    'Event': [],
    'Notification': [],
    'Post': [],
  };

  final Map<String, List<Map<String, String>>> rejectedApprovalsMap = {
    'Member': [],
    'Event': [],
    'Notification': [],
    'Post': [],
  };

  List<Map<String, String>> filteredPending = [];
  List<Map<String, String>> filteredApproved = [];
  List<Map<String, String>> filteredRejected = [];

  late String FamilyId;

  bool isChipLoading = false;

  bool _isLoading = true;

  late String familyname;

  @override
  void initState() {
    super.initState();
    selectedChipIndex = widget.initialChipIndex;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _filterAllTabs();
    fetchFamilyAndMemberIds();
  }

  Future<void> fetchFamilyAndMemberIds() async {
    try {
      final personUrl = Uri.parse('$baseUrl/people/$id');
      final personRes = await http.get(
        personUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (personRes.statusCode != 200) return;

      final personData = jsonDecode(personRes.body)['data'];
      final assignedFamilyIds = List<String>.from(
        personData['familyAdminDetails']['assignedFamilies'] ?? [],
      );

      List<String> allMemberIds = [];
      List<String> allMembername = [];

      for (String familyId in assignedFamilyIds) {
        FamilyId = familyId;
        final familyUrl = Uri.parse('$baseUrl/families/$familyId');
        final familyRes = await http.get(
          familyUrl,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (familyRes.statusCode == 200) {
          final familyData = jsonDecode(familyRes.body)['data'];
          final familyName = familyData['name'];
          familyname = familyName;
          final members = familyData['members'] as List<dynamic>;
          allMemberIds.addAll(members.map((m) => m['_id'].toString()));
          allMembername.addAll(members.map((m) => m['fullName'].toString()));
        }
      }

      setState(() {
        memberIds = allMemberIds;
        membername = allMembername;
      });

      final feeds = await ref
          .read(requirements_api.filteredFeedsProvider(memberIds).future);
      final events =
          await ref.read(events_api.filteredEventsProvider(membername).future);
      final Notification = await ref.read(
          notification_api.filteredNotificationsProvider(memberIds).future);
      final List<RequestModel> request =
          await ref.read(fetchAllMembershipRequestsProvider.future);

      debugPrint(events.toString());
      setState(() {
        filteredFeeds = feeds.map((f) => Feed.fromJson(f)).toList();
        approvedApprovalsMap['Member'] = request
            .where((r) => r.status == 'approved')
            .map<Map<String, String>>((r) => {
                  'view': 'Member',
                  'title': '${r.fullName}',
                  'subtitle': r.email ?? '',
                  'status': r.status.capitalize(),
                  '_id': r.id ?? '',
                  'family': familyname ?? ''
                })
            .toList();
        pendingApprovalsMap['Member'] = request
            .where((r) => r.status == 'pending')
            .map<Map<String, String>>((r) => {
                  'view': 'Member',
                  'title': '${r.fullName}',
                  'subtitle': r.email ?? '',
                  'status': r.status.capitalize(),
                  '_id': r.id ?? '',
                  'family': familyname ?? ''
                })
            .toList();

// MEMBER – Rejected
        rejectedApprovalsMap['Member'] = request
            .where((r) => r.status == 'rejected')
            .map<Map<String, String>>((r) => {
                  'view': 'Member',
                  'title': '${r.fullName}',
                  'subtitle': r.email ?? '',
                  'status': r.status.capitalize(),
                  '_id': r.id ?? '',
                  'family': familyname ?? ''
                })
            .toList();

        // Post – Pending
        pendingApprovalsMap['Post'] = filteredFeeds
            .where((feed) => feed.status == 'unpublished')
            .map<Map<String, String>>((feed) => {
                  'view': 'Post',
                  'title': '${feed.type}',
                  'subtitle': feed.content ?? '',
                  'status': feed.status.capitalize(),
                  '_id': feed.id,
                  'family': familyname ?? ''
                })
            .toList();

        // Post – Approved
        approvedApprovalsMap['Post'] = filteredFeeds
            .where((feed) => feed.status == 'published')
            .map<Map<String, String>>((feed) => {
                  'view': 'Post',
                  'title': '${feed.type}',
                  'subtitle': feed.content ?? '',
                  'status': feed.status.capitalize(),
                  '_id': feed.id,
                  'family': familyname ?? ''
                })
            .toList();

        // Post – Rejected
        rejectedApprovalsMap['Post'] = filteredFeeds
            .where((feed) => feed.status == 'rejected')
            .map<Map<String, String>>((feed) => {
                  'view': 'Post',
                  'title': '${feed.type}',
                  'subtitle': feed.content ?? '',
                  'status': feed.status.capitalize(),
                  '_id': feed.id,
                  'family': familyname ?? ''
                })
            .toList();

        // Event – Pending
        pendingApprovalsMap['Event'] = events
            .where((event) => event['isApproved'] == 'pending')
            .map<Map<String, String>>((event) => {
                  'view': 'Event',
                  'title': '${event['event_name'] ?? 'Untitled'}',
                  'subtitle': event['description'] ?? '',
                  'status': event['isApproved'].toString().capitalize(),
                  '_id': event['_id'],
                  'family': familyname ?? ''
                })
            .toList();

        // Event – Approved
        approvedApprovalsMap['Event'] = events
            .where((event) => event['isApproved'] == 'true')
            .map<Map<String, String>>((event) => {
                  'view': 'Event',
                  'title': '${event['event_name'] ?? 'Untitled'}',
                  'subtitle': event['description'] ?? '',
                  'status': event['isApproved'].toString().capitalize(),
                  '_id': event['_id'],
                  'family': familyname ?? ''
                })
            .toList();

        // Event – Rejected
        rejectedApprovalsMap['Event'] = events
            .where((event) => event['isApproved'] == 'rejected')
            .map<Map<String, String>>((event) => {
                  'view': 'Event',
                  'title': '${event['event_name'] ?? 'Untitled'}',
                  'subtitle': event['description'] ?? '',
                  'status': event['isApproved'].toString().capitalize(),
                  '_id': event['_id'],
                  'family': familyname ?? ''
                })
            .toList();

        // Notification – Pending
        pendingApprovalsMap['Notification'] =
            Notification.where((notif) => notif['status'] == 'unpublished')
                .map<Map<String, String>>((notif) => {
                      'view': 'Notification',
                      'title': '${notif['subject'] ?? 'No Subject'}',
                      'subtitle': notif['content'] ?? '',
                      'status': notif['status'].toString().capitalize(),
                      '_id': notif['_id'],
                      'family': familyname ?? ''
                    })
                .toList();

// Notification – Approved
        approvedApprovalsMap['Notification'] =
            Notification.where((notif) => notif['status'] == 'approved')
                .map<Map<String, String>>((notif) => {
                      'view': 'Notification',
                      'title': '${notif['title'] ?? 'No Subject'}',
                      'subtitle': notif['content'] ?? '',
                      'status': notif['status'].toString().capitalize(),
                      '_id': notif['_id'],
                      'family': familyname ?? ''
                    })
                .toList();

// Notification – Rejected
        rejectedApprovalsMap['Notification'] =
            Notification.where((notif) => notif['status'] == 'rejected')
                .map<Map<String, String>>((notif) => {
                      'view': 'Notification',
                      'title': '${notif['subject'] ?? 'No Subject'}',
                      'subtitle': notif['content'] ?? '',
                      'status': notif['status'].toString().capitalize(),
                      '_id': notif['_id'],
                      'family': familyname ?? ''
                    })
                .toList();
        _isLoading = false;
        _filterAllTabs();
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _filterAllTabs() {
    filteredPending = getFilteredData(pendingApprovalsMap);
    filteredApproved = getFilteredData(approvedApprovalsMap);
    filteredRejected = getFilteredData(rejectedApprovalsMap);
  }

  List<Map<String, String>> getFilteredData(
      Map<String, List<Map<String, String>>> dataMap) {
    final label = chipLabels[selectedChipIndex].split(' ').first;
    return dataMap[label] ?? [];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 48),
        child: Material(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  size: 12, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Approvals',
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.black),
            ),
            centerTitle: true,
            actions: _isLoading
                ? []
                : [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/svg/icons/search.svg',
                        width: 16,
                        height: 16,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ApprovalSearchPage(
                              pending: pendingApprovalsMap,
                              approved: approvedApprovalsMap,
                              rejected: rejectedApprovalsMap,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'Approved'),
                Tab(text: 'Rejected')
              ],
              enableFeedback: true,
              isScrollable: false,
              indicatorColor: kPrimaryColor,
              indicatorWeight: 3.0,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: kPrimaryColor,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: LoadingAnimation())
          : Column(
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: chipLabels.length,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {
                      final label = chipLabels[index];
                      return CategoryChip(
                        label: label,
                        selected: index == selectedChipIndex,
                        onTap: () async {
                          setState(() {
                            isChipLoading = true;
                            selectedChipIndex = index;
                          });

                          // Optional delay to show the spinner (if _filterAllTabs is synchronous)
                          await Future.delayed(
                              const Duration(milliseconds: 300));

                          setState(() {
                            _filterAllTabs();
                            isChipLoading = false;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: isChipLoading
                      ? const Center(child: LoadingAnimation())
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            PendingTab(data: filteredPending),
                            ApprovedTab(data: filteredApproved),
                            RejectedTab(data: filteredRejected),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 107),
        height: 36,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(200),
          border: Border.all(
            color: selected ? Colors.red : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
