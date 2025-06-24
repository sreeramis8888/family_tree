import 'package:familytree/src/data/constants/color_constants.dart';
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
                                                        campaign: campaign),
                                              ),
                                            );
                                          },
                                    rightButtonAction: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CampaignDetailPage(
                                              campaign: campaign),
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
                                                        campaign: campaign),
                                              ),
                                            );
                                          },
                                    rightButtonAction: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CampaignDetailPage(
                                              campaign: campaign),
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
}
