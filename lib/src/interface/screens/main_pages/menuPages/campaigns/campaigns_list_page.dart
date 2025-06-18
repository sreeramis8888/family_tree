import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:familytree/src/interface/components/Cards/campaign_card.dart';
import 'package:familytree/src/data/models/activity_model.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/campaigns/transactions_list_page.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_choicechip.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/campaigns/campaign_detail_page.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/campaigns/campaign_create_page.dart';

import '../../../../../data/constants/style_constants.dart';

class CampaignsMainScreen extends StatefulWidget {
  const CampaignsMainScreen({Key? key}) : super(key: key);

  @override
  State<CampaignsMainScreen> createState() => _CampaignsMainScreenState();
}

class _CampaignsMainScreenState extends State<CampaignsMainScreen>
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

  // Mock data for demonstration
  final List<ActivityModel> allCampaigns = [
    ActivityModel(
      title: 'Back to School Drive',
      description:
          'Help provide school supplies and educational resources to underprivileged children for the new academic year.',
      amount: 2500,
      date: '2023-01-02',
      type: 'csr',
    ),
    ActivityModel(
      title: 'Medical Aid Fund',
      description: 'Support medical expenses for families in need.',
      amount: 1200,
      date: '2023-02-15',
      type: 'zakath',
    ),
    ActivityModel(
      title: 'Tree Plantation Drive',
      description: 'Join us in planting trees to make our city greener.',
      amount: 3200,
      date: '2023-03-10',
      type: 'csr',
    ),
    ActivityModel(
      title: 'Clean Water Project',
      description: 'Provide clean drinking water to rural communities.',
      amount: 4100,
      date: '2023-04-05',
      type: 'csr',
    ),
  ];

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

  List<ActivityModel> _getCampaignsForTab(int index) {
    if (index == 1) {
      return allCampaigns.where((c) => c.type == 'csr').toList();
    } else if (index == 2) {
      return allCampaigns.where((c) => c.type == 'zakath').toList();
    }
    return allCampaigns;
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
              Expanded(
                child: TabBarView(
                  controller: _subTabController,
                  children: List.generate(_campaignSubTabs.length, (tabIndex) {
                    final campaigns = _getCampaignsForTab(tabIndex);
                    if (campaigns.isEmpty) {
                      return const Center(child: Text('No campaigns yet'));
                    }
                    return ListView.builder(
                      itemCount: campaigns.length,
                      itemBuilder: (context, index) {
                        final campaign = campaigns[index];
                        final isMyCampaign = false;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CampaignCard(
                            campaign: campaign,
                            tag: campaign.type ?? '',
                            leftButtonLabel: isMyCampaign ? '' : 'Learn More',
                            rightButtonLabel:
                                isMyCampaign ? 'View Details' : 'Donate Now',
                            leftButtonAction: isMyCampaign
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CampaignDetailPage(campaign: campaign),
                                      ),
                                    );
                                  },
                            rightButtonAction: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CampaignDetailPage(campaign: campaign),
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
          ),
          // Transactions Tab Content (Placeholder)
          const TransactionsListPage(),
          // My Campaigns Tab Content
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
              Expanded(
                child: TabBarView(
                  controller: _subTabController,
                  children: List.generate(_campaignSubTabs.length, (tabIndex) {
                    // For 'My Campaigns' tab, we are just displaying all campaigns for now
                    // TODO: Replace with actual filtering for user's own campaigns
                    final campaigns = _getCampaignsForTab(tabIndex);
                    if (campaigns.isEmpty) {
                      return const Center(child: Text('No campaigns yet'));
                    }
                    return ListView.builder(
                      itemCount: campaigns.length,
                      itemBuilder: (context, index) {
                        final campaign = campaigns[index];
                        final isMyCampaign =
                            true; // Hardcoded true for 'My Campaigns' tab for demonstration
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CampaignCard(
                            campaign: campaign,
                            tag: campaign.type ?? '',
                            leftButtonLabel: isMyCampaign ? '' : 'Learn More',
                            rightButtonLabel:
                                isMyCampaign ? 'View Details' : 'Donate Now',
                            leftButtonAction: isMyCampaign
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CampaignDetailPage(campaign: campaign),
                                      ),
                                    );
                                  },
                            rightButtonAction: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CampaignDetailPage(campaign: campaign),
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
}
