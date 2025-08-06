import 'package:familytree/src/data/api_routes/transaction_api/transaction_api.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/models/transaction_model.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:familytree/src/interface/components/Cards/campaign_card.dart';

import 'package:familytree/src/interface/screens/main_pages/menuPages/campaigns/transactions_list_page.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_choicechip.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/campaigns/campaign_detail_page.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/campaigns/campaign_create_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/models/campaign_model.dart';
import 'package:familytree/src/data/api_routes/campain_api/campaign_api.dart';
import 'package:familytree/src/data/notifiers/user_notifier.dart';
import 'package:intl/intl.dart';

import '../../../../../data/constants/style_constants.dart';

class CampaignsMainScreen extends ConsumerStatefulWidget {
  const CampaignsMainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CampaignsMainScreen> createState() =>
      _CampaignsMainScreenState();
}

class _CampaignsMainScreenState extends ConsumerState<CampaignsMainScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _subTabController;

  final List<String> _topLevelTabs = [
    'Campaigns',
    'Transactions',
    'My Campaigns'
  ];
  final List<String> _campaignSubTabs = [
    'All Campaigns',
    'CSR Campaigns',
    'Zakath Campaigns'
  ];
  final fetchCampaignTransactionsProvider =
      FutureProvider.family<List<TransactionModel>, String>((ref, type) async {
    return await TransactionApiService.getTransactions(type: type);
  });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _topLevelTabs.length, vsync: this);
    _subTabController =
        TabController(length: _campaignSubTabs.length, vsync: this);

    _subTabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subTabController.dispose();
    super.dispose();
  }

  List<CampaignModel> _getCampaignsForTab(
      List<CampaignModel> campaigns, int index) {
    if (index == 1) {
      return campaigns.where((c) => c.tagType.toLowerCase() == 'csr').toList();
    } else if (index == 2) {
      return campaigns
          .where((c) => c.tagType.toLowerCase() == 'zakath')
          .toList();
    }
    return campaigns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios)),
        title: const Text('Campaigns', style: kBodyTitleM),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: const BoxDecoration(
              color: kWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 4),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: TabBar(
              dividerColor: kWhite,
              indicatorColor: kPrimaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              enableFeedback: true,
              indicatorWeight: 3,
              isScrollable: false,
              labelColor: kPrimaryColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              controller: _tabController,
              tabs: _topLevelTabs.map((t) => Tab(text: t)).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Only fetch campaigns for the first tab
          Consumer(
            builder: (context, ref, _) {
              final asyncCampaigns = ref.watch(fetchCampaignsProvider);
              return asyncCampaigns.when(
                data: (campaigns) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              _campaignSubTabs.asMap().entries.map((entry) {
                            int idx = entry.key;
                            String text = entry.value;
                            return CustomChoiceChip(
                              label: text,
                              selected: _subTabController.index == idx,
                              onTap: () {
                                _subTabController.animateTo(idx);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _subTabController,
                          children: List.generate(_campaignSubTabs.length,
                              (tabIndex) {
                            final filteredCampaigns =
                                _getCampaignsForTab(campaigns, tabIndex);
                            if (filteredCampaigns.isEmpty) {
                              return const Center(
                                  child: Text('No campaigns yet'));
                            }
                            return ListView.builder(
                              itemCount: filteredCampaigns.length,
                              itemBuilder: (context, index) {
                                final campaign = filteredCampaigns[index];
                                final isMyCampaign = false;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: CampaignCard(
                                    campaign: campaign,
                                    tag: campaign.tagType,
                                    userPhone: null,
                                    leftButtonLabel:
                                        isMyCampaign ? '' : 'Learn More',
                                    rightButtonLabel: isMyCampaign
                                        ? 'View Details'
                                        : 'Donate Now',
                                    leftButtonAction: isMyCampaign
                                        ? null
                                        : () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    CampaignDetailPage(
                                                        campaign: campaign, userPhone: null),
                                              ),
                                            );
                                          },
                                    rightButtonAction: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CampaignDetailPage(
                                              campaign: campaign, userPhone: null),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: LoadingAnimation()),
                error: (error, stackTrace) =>
                    const Center(child: Text('Failed to load campaigns')),
              );
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final asyncTransactions =
                  ref.watch(fetchCampaignTransactionsProvider('Donation'));

              return asyncTransactions.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const Center(child: Text('No transactions found'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      final formattedDate = DateFormat('d MMMM y, hh:mm a')
                          .format(t.date.toLocal());
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Transaction ID: ${t.transactionId}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              _buildRow('Type', '${t.type}'),
                              _buildRow(
                                'date & time',
                                formattedDate,
                              ),
                              _buildRow('Amount paid', '₹ ${t.amount}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: LoadingAnimation()),
                error: (error, _) =>
                    const Center(child: Text('Failed to load transactions')),
              );
            },
          ),

          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _campaignSubTabs.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String text = entry.value;
                    return CustomChoiceChip(
                      label: text,
                      selected: _subTabController.index == idx,
                      onTap: () {
                        _subTabController.animateTo(idx);
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Consumer(
                builder: (context, ref, child) {
                  final asyncMyCampaigns = ref.watch(fetchMyCampaignsProvider);
                  return asyncMyCampaigns.when(
                    data: (myCampaigns) {
                      return Expanded(
                        child: TabBarView(
                          controller: _subTabController,
                          children: List.generate(_campaignSubTabs.length,
                              (tabIndex) {
                            final filteredCampaigns =
                                _getCampaignsForTab(myCampaigns, tabIndex);
                            if (filteredCampaigns.isEmpty) {
                              return const Center(
                                  child: Text('No campaigns yet'));
                            }
                            return ListView.builder(
                              itemCount: filteredCampaigns.length,
                              itemBuilder: (context, index) {
                                final campaign = filteredCampaigns[index];
                                final isMyCampaign = false;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: CampaignCard(
                                    campaign: campaign,
                                    tag: campaign.tagType,
                                    userPhone: null,
                                    leftButtonLabel:
                                        isMyCampaign ? '' : 'Learn More',
                                    rightButtonLabel: isMyCampaign
                                        ? 'View Details'
                                        : 'Donate Now',
                                    leftButtonAction: isMyCampaign
                                        ? null
                                        : () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    CampaignDetailPage(
                                                        campaign: campaign, userPhone: null),
                                              ),
                                            );
                                          },
                                    rightButtonAction: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CampaignDetailPage(
                                              campaign: campaign, userPhone: null),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      );
                    },
                    loading: () => const Center(child: LoadingAnimation()),
                    error: (error, stackTrace) =>
                        const Center(child: Text('No Campaigns')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CampaignCreatePage(),
            ),
          );
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Campaign',
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Flexible(child: Text(value, textAlign: TextAlign.right)),
          ],
        ),
      ),
    );
  }
}
