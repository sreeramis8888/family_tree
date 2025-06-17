import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/api_routes/analytics_api/analytics_api.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/models/analytics_model.dart';
import 'package:familytree/src/data/notifiers/user_notifier.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/interface/components/Dialogs/premium_dialog.dart';
import 'package:familytree/src/interface/components/ModalSheets/analytics.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  final String? initialTab;
  final String? requestType;
  final String? startDate;
  final String? endDate;

  const AnalyticsPage({
    super.key,
    this.initialTab,
    this.requestType,
    this.startDate,
    this.endDate,
  });

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Add filter state variables
  DateTime? startDate;
  DateTime? endDate;
  String? selectedRequestType;
  final List<String> requestTypes = [
    'Business',
    'One v One Meeting',
    'Referral'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Set initial tab if provided
    if (widget.initialTab != null) {
      _tabController.animateTo(widget.initialTab == 'sent'
          ? 1
          : widget.initialTab == 'received'
              ? 0
              : 2);
    }

    // Set initial filters if provided
    if (widget.requestType != null) {
      selectedRequestType = widget.requestType;
    }
    if (widget.startDate != null) {
      startDate = DateTime.parse(widget.startDate!);
    }
    if (widget.endDate != null) {
      endDate = DateTime.parse(widget.endDate!);
    }
  }

  // Add filter modal sheet
  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag indicator
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Date Range Section
                  Text('Date Range', style: kBodyTitleB),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: startDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => startDate = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: kGrey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              startDate != null
                                  ? DateFormat('MMM d, yyyy').format(startDate!)
                                  : 'Start Date',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: endDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => endDate = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: kGrey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              endDate != null
                                  ? DateFormat('MMM d, yyyy').format(endDate!)
                                  : 'End Date',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Request Type Section
                  Text('Request Type', style: kBodyTitleB),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: kGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedRequestType,
                      isExpanded: true,
                      hint: const Text('Select Request Type'),
                      underline: Container(),
                      items: requestTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() => selectedRequestType = value);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              startDate = null;
                              endDate = null;
                              selectedRequestType = null;
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: kWhite,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            // Invalidate the provider to refresh with new filters
                            ref.invalidate(fetchAnalyticsProvider);
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showReusableModalSheet(
      AnalyticsModel analytic, String tabBarType, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return AnalyticsModalSheet(
          analytic: analytic,
          tabBarType: tabBarType,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncSentAnalytics = ref.watch(fetchAnalyticsProvider(
      type: 'sent',
      startDate: startDate != null
          ? DateFormat('yyyy-MM-dd').format(startDate!)
          : null,
      endDate:
          endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null,
      requestType: selectedRequestType,
    ));

    final asyncReceivedAnalytics = ref.watch(fetchAnalyticsProvider(
      type: 'received',
      startDate: startDate != null
          ? DateFormat('yyyy-MM-dd').format(startDate!)
          : null,
      endDate:
          endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null,
      requestType: selectedRequestType,
    ));

    final asyncHistoryAnalytics = ref.watch(fetchAnalyticsProvider(
      type: null,
      startDate: startDate != null
          ? DateFormat('yyyy-MM-dd').format(startDate!)
          : null,
      endDate:
          endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null,
      requestType: selectedRequestType,
    ));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          decoration: BoxDecoration(
            color: kWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 1,
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: kWhite,
            centerTitle: true,
            title: const Text(
              "Analytics",
              style: kSmallTitleM,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterModal,
              ),
            ],
            elevation: 0,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Material(
            color: kWhite,
            elevation: 0.0,
            child: TabBar(
              controller: _tabController,
              indicatorWeight: 3,
              dividerColor: kWhite,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: kPrimaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: kPrimaryColor,
              tabs: const [
                Tab(text: "Received"),
                Tab(text: "Sent"),
                Tab(text: "History"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRefreshableAnalyticsTab(
                    asyncReceivedAnalytics, 'received'),
                _buildRefreshableAnalyticsTab(asyncSentAnalytics, 'sent'),
                _buildRefreshableAnalyticsTab(asyncHistoryAnalytics, 'history'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // final userAsync = ref.watch(userProvider);
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   userAsync.whenOrNull(data: (user) {
          //     if (user.status == 'trial') {
          //       showDialog(
          //         context: context,
          //         builder: (_) => const PremiumDialog(),
          //       );
          //     }
          //     else {
                NavigationService navigationService = NavigationService();
                navigationService.pushNamed('SendAnalyticRequest');
              // }
          //   });
          // });
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.add,
          color: kWhite,
        ),
      ),
    );
  }

  Widget _buildRefreshableAnalyticsTab(
      AsyncValue<List<AnalyticsModel>> asyncAnalytics, String tabBarType) {
    return RefreshIndicator(
      backgroundColor: kWhite,
      color: kPrimaryColor,
      onRefresh: () async {
        ref.invalidate(fetchAnalyticsProvider);
      },
      child: asyncAnalytics.when(
          data: (analytics) => analytics.isEmpty
              ? const Center(child: Text("No data available"))
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  itemCount: analytics.length,
                  itemBuilder: (context, index) {
                    return _buildCard(analytics[index], tabBarType);
                  },
                ),
          loading: () => const Center(child: LoadingAnimation()),
          error: (error, stackTrace) {
            log(error.toString());
            return Center(child: Text("Error loading data"));
          }),
    );
  }

  Widget _buildCard(AnalyticsModel analytic, String tabBarType) {
    log(analytic.userImage ?? '', name: 'User image of analytic');
    return InkWell(
      onTap: () => _showReusableModalSheet(analytic, tabBarType, context),
      child: Container(
        decoration: BoxDecoration(
            color: kWhite,
            border: Border.all(
              color: kGrey,
            ),
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24.0,
                          backgroundImage: NetworkImage(
                            analytic.userImage ?? '',
                          ),
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        Expanded(
                          child: Text(
                            maxLines: 2,
                            analytic.username ?? '',
                            style: const TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        if (analytic.date != null)
                          Row(
                            children: [
                              Text(
                                maxLines: 2,
                                '${DateFormat("MMM d yyyy ").format(analytic.date!.toLocal())}',
                                style: const TextStyle(
                                    fontSize: 10.0, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (analytic.time != null)
                                Text(
                                  '${analytic.time}',
                                  style: const TextStyle(
                                      fontSize: 10.0, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                )
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            maxLines: 4,
                            analytic.title ?? '',
                            style: kBodyTitleB,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              analytic.status ?? '',
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              analytic.status ?? '',
                              style: const TextStyle(
                                color: kWhite,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "accepted":
        return kGreen;
      case "completed":
        return kGreen;
      case "rejected":
        return kRed;
      case "meeting_scheduled":
        return Color(0xFF2B74E1);
      default:
        return Colors.grey;
    }
  }
}
