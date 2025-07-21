import 'dart:async';
import 'dart:developer';

import 'package:familytree/src/data/api_routes/finance_api/finance_api.dart';
import 'package:familytree/src/interface/screens/family_tree/family_tree.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/campaigns/campaign_detail_page.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/financial_program/financial_program_page.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/financial_program/program_join_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:familytree/src/data/api_routes/events_api/events_api.dart';
import 'package:familytree/src/data/api_routes/news_api/news_api.dart';
import 'package:familytree/src/data/api_routes/notification_api/notification_api.dart';
import 'package:familytree/src/data/api_routes/promotion_api/promotion_api.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/promotion_model.dart';
import 'package:familytree/src/data/models/user_model.dart';
import 'package:familytree/src/data/router/nav_router.dart';
import 'package:familytree/src/data/services/launch_url.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/interface/screens/main_pages/Drawer/drawer.dart';
import 'package:familytree/src/interface/components/common/custom_video.dart';
import 'package:familytree/src/interface/components/custom_widgets/blue_tick_names.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_news.dart';
import 'package:familytree/src/interface/components/custom_widgets/event_Card.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/components/shimmers/promotion_shimmers.dart';
import 'package:familytree/src/interface/screens/main_pages/news_bookmark/news_page.dart';
import 'package:familytree/src/interface/screens/main_pages/notification_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:familytree/src/interface/components/shimmers/dashboard_shimmer.dart';
import 'package:familytree/src/interface/components/ModalSheets/date_filter_sheet.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/analytics/analytics.dart';
import 'package:familytree/src/interface/screens/web_view_screen.dart';
import 'package:familytree/src/interface/components/custom_widgets/circle_icon_button.dart';
import 'package:familytree/src/interface/components/Cards/campaign_card.dart';

import 'package:familytree/src/interface/screens/main_pages/menuPages/campaigns/campaigns_list_page.dart';
import 'package:familytree/src/data/models/campaign_model.dart';
import 'package:familytree/src/data/api_routes/campain_api/campaign_api.dart';

class HomePage extends ConsumerStatefulWidget {
  final UserModel user;
  const HomePage({super.key, required this.user});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentBannerIndex = 0;
  int _currentNoticeIndex = 0;
  int _currentPosterIndex = 0;
  int _currentEventIndex = 0;
  int _currentVideoIndex = 0;

  double _calculateDynamicHeight(List<Promotion> notices) {
    double maxHeight = 0.0;

    for (var notice in notices) {
      // Estimate height based on the length of title and description
      final double titleHeight =
          _estimateTextHeight(notice.title!, 18.0); // Font size 18 for title
      final double descriptionHeight = _estimateTextHeight(
          notice.description!, 14.0); // Font size 14 for description

      final double itemHeight =
          titleHeight + descriptionHeight; // Adding padding
      if (itemHeight > maxHeight) {
        maxHeight = itemHeight + MediaQuery.sizeOf(context).width * 0.05;
      }
    }
    return maxHeight;
  }

  double _estimateTextHeight(String text, double fontSize) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final int numLines = (text.length / (screenWidth / fontSize)).ceil();
    return numLines * fontSize * 1.2 + 40;
  }

  CarouselController controller = CarouselController();
  String? startDate;
  String? endDate;

  // Add this function to show the right-side full-screen drawer
  void showRightDrawer(BuildContext context, UserModel user) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Drawer",
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: customDrawer(user: user, context: context, ref: ref),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    NavigationService navigationService = NavigationService();
    return Consumer(
      builder: (context, ref, child) {
        final asyncPromotions = ref.watch(fetchPromotionsProvider);
        final asyncEvents = ref.watch(fetchEventsProvider);
        final asyncNews = ref.watch(fetchNewsProvider);

        return RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: () async {
            ref.invalidate(fetchPromotionsProvider);
            // ref.invalidate(fetchEventsProvider);
          },
          child: Scaffold(
            backgroundColor: kWhite,
            body: asyncPromotions.when(
              data: (promotions) {
                final banners = promotions
                    .where((promo) => promo.type == 'banner')
                    .toList();
                final notices = promotions
                    .where((promo) => promo.type == 'notice')
                    .toList();
                final posters = promotions
                    .where((promo) => promo.type == 'poster')
                    .toList();
                final videos =
                    promotions.where((promo) => promo.type == 'video').toList();
                final filteredVideos = videos
                    .where((video) => video.link!.startsWith('http'))
                    .toList();

                return SafeArea(
                  child: Container(
                    decoration: const BoxDecoration(color: kWhite),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 45.0, // Match the toolbarHeight
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const WebViewScreen(
                                              color: kPrimaryColor,
                                              url:
                                                  'https://www.indotransworld.org/',
                                              title: 'familytree Connect',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                          width: 60,
                                          height: 60,
                                          'assets/pngs/familytree_logo.png'),
                                    ),
                                    const Spacer(),
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final asyncNotifications = ref
                                            .watch(fetchNotificationsProvider);

                                        return asyncNotifications.when(
                                          data: (notifications) {
                                            // 🛡️ Check if current user ID exists in any notification's user list
                                            final bool userExists =
                                                notifications.any(
                                                    (notification) =>
                                                        (notification.users ??
                                                                [])
                                                            .any((user) =>
                                                                user.userId ==
                                                                id));

                                            log("🔍 userExists: $userExists");

                                            return IconButton(
                                              icon: userExists
                                                  ? const Icon(
                                                      Icons
                                                          .notification_add_outlined,
                                                      color: kRed)
                                                  : const Icon(Icons
                                                      .notifications_none_outlined),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NotificationPage(),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          loading: () {
                                            log("⏳ Notifications are loading...");
                                            return const Center(
                                              child: Icon(
                                                  Icons.notifications_none),
                                            );
                                          },
                                          error: (error, stackTrace) {
                                            log("❌ Error loading notifications: $error");
                                            return const SizedBox();
                                          },
                                        );
                                      },
                                    ),

                                    // Menu button to open the right drawer
                                    InkWell(
                                      onTap: () =>
                                          showRightDrawer(context, widget.user),
                                      child: SizedBox(
                                        width: 60, // Match the leadingWidth
                                        child: SvgPicture.asset(
                                            'assets/svg/icons/menu_icon.svg'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 10),
                                child: Text('Welcome, ${widget.user.fullName} ',
                                    style:
                                        kLargeTitleB.copyWith(color: kBlack)),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Here\'s to growing your family story, one branch at a time.',
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // if (widget.user.freeTrialEndDate != null)
                              // Center(
                              //   child: Container(
                              //     margin: const EdgeInsets.symmetric(
                              //         vertical: 10, horizontal: 20),
                              //     decoration: BoxDecoration(
                              //       gradient: const LinearGradient(
                              //         colors: [
                              //           Color(0xFF274198),
                              //           Color(0xFF0D1532)
                              //         ],
                              //         begin: Alignment.topLeft,
                              //         end: Alignment.bottomRight,
                              //       ),
                              //       borderRadius: BorderRadius.circular(16),
                              //       boxShadow: [
                              //         BoxShadow(
                              //           color:
                              //               Colors.black.withOpacity(0.12),
                              //           blurRadius: 16,
                              //           offset: const Offset(0, 8),
                              //         ),
                              //       ],
                              //     ),
                              //     child: Stack(
                              //       children: [
                              //         Positioned(
                              //           bottom: 0,
                              //           right: 0,
                              //           child: Image.asset(
                              //             'assets/pngs/trial_round.png',
                              //             width: 150,
                              //             fit: BoxFit.cover,
                              //           ),
                              //         ),
                              //         Padding(
                              //           padding: const EdgeInsets.all(20),
                              //           child: Column(
                              //             mainAxisSize: MainAxisSize.min,
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               Row(
                              //                 children: [
                              //                   Icon(Icons.lightbulb,
                              //                       color:
                              //                           Colors.amber[400],
                              //                       size: 24),
                              //                   const SizedBox(width: 10),
                              //                   const Expanded(
                              //                     child: Text(
                              //                       'Your 30-day free trial is active!',
                              //                       style: TextStyle(
                              //                         color: kWhite,
                              //                         fontWeight:
                              //                             FontWeight.bold,
                              //                         fontSize: 16,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //               const SizedBox(height: 10),
                              //               const Text(
                              //                 'Enjoy premium features and grow your business with Dubai Connect.',
                              //                 style: TextStyle(
                              //                   color: Color(0xFFC9D2F2),
                              //                   fontSize: 13,
                              //                 ),
                              //               ),
                              //               const SizedBox(height: 8),
                              //               Text(
                              //                 '${widget.user.freeTrialEndDate?.difference(DateTime.now()).inDays.clamp(0, double.infinity).toInt()} days left — upgrade anytime!',
                              //                 style: const TextStyle(
                              //                   color: Color(0xFFB0B9D9),
                              //                   fontSize: 12,
                              //                 ),
                              //               ),
                              //               const SizedBox(height: 14),
                              //               SizedBox(
                              //                 width: 130,
                              //                 height: 36,
                              //                 child: ElevatedButton(
                              //                   style: const ButtonStyle(
                              //                     backgroundColor:
                              //                         MaterialStatePropertyAll(
                              //                             Color(
                              //                                 0xFFE7ECFF)),
                              //                     foregroundColor:
                              //                         MaterialStatePropertyAll(
                              //                             Color(
                              //                                 0xFF232C5B)),
                              //                     shape:
                              //                         MaterialStatePropertyAll(
                              //                       RoundedRectangleBorder(
                              //                         borderRadius:
                              //                             BorderRadius.all(
                              //                                 Radius
                              //                                     .circular(
                              //                                         8)),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   onPressed: () {
                              //                     navigationService
                              //                         .pushNamed(
                              //                             'MySubscription');
                              //                   },
                              //                   child: const Row(
                              //                     mainAxisAlignment:
                              //                         MainAxisAlignment
                              //                             .center,
                              //                     children: [
                              //                       Text('Subscribe',
                              //                           style: TextStyle(
                              //                               fontWeight:
                              //                                   FontWeight
                              //                                       .bold)),
                              //                       Icon(
                              //                           Icons
                              //                               .arrow_outward_outlined,
                              //                           size: 16),
                              //                     ],
                              //                   ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       left: 15, top: 10, bottom: 10),
                              //   child: Row(
                              //     children: [
                              //       const Text('DASHBOARD',
                              //           style: kSmallTitleR),
                              //       const Spacer(),
                              //       IconButton(
                              //         icon: const Icon(Icons.filter_list),
                              //         onPressed: () {
                              //           showModalBottomSheet(
                              //             context: context,
                              //             isScrollControlled: true,
                              //             backgroundColor: Colors.transparent,
                              //             builder: (context) =>
                              //                 DateFilterSheet(
                              //               onApply: (String? newStartDate,
                              //                   String? newEndDate) {
                              //                 setState(() {
                              //                   startDate = newStartDate;
                              //                   endDate = newEndDate;
                              //                 });

                              //                 ref.invalidate(
                              //                     getUserDashboardProvider);
                              //               },
                              //             ),
                              //           );
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // asyncUserDashBoardDetails.when(
                              //   data: (userDashboard) {
                              //     return Padding(
                              //       padding: const EdgeInsets.only(
                              //           left: 20, right: 20),
                              //       child: Column(
                              //         children: [
                              //           Row(
                              //             children: [
                              //               Expanded(
                              //                 child: _buildStatCard(
                              //                   'BUSINESS GIVEN',
                              //                   '${userDashboard.businessGiven}',
                              //                 ),
                              //               ),
                              //               const SizedBox(
                              //                   width:
                              //                       8), // Optional spacing between cards
                              //               Expanded(
                              //                 child: _buildStatCard(
                              //                   'BUSINESS RECEIVED',
                              //                   '${userDashboard.businessReceived}',
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           Row(
                              //             children: [
                              //               Expanded(
                              //                 child: _buildStatCard(
                              //                   'REFERRALS GIVEN',
                              //                   '${userDashboard.referralGiven}',
                              //                 ),
                              //               ),
                              //               const SizedBox(
                              //                   width:
                              //                       8), // Optional spacing between cards
                              //               Expanded(
                              //                 child: _buildStatCard(
                              //                   'REFERRALS RECEIVED',
                              //                   '${userDashboard.referralReceived}',
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           Row(
                              //             children: [
                              //               Expanded(
                              //                 child: _buildStatCard(
                              //                   'ONE V ONE MEETINGS',
                              //                   '${userDashboard.oneToOneCount}',
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ],
                              //       ),
                              //     );
                              //   },
                              //   error: (error, stackTrace) {
                              //     return const SizedBox.shrink();
                              //   },
                              //   loading: () {
                              //     return buildDashboardShimmer();
                              //   },
                              // ),

                              // Banner Carousel
                              if (banners.isNotEmpty)
                                Column(
                                  children: [
                                    CarouselSlider(
                                      items: banners.map((banner) {
                                        return _buildBanners(
                                            context: context, banner: banner);
                                      }).toList(),
                                      options: CarouselOptions(
                                        height: 185,
                                        scrollPhysics: banners.length > 1
                                            ? null
                                            : const NeverScrollableScrollPhysics(),
                                        autoPlay:
                                            banners.length > 1 ? true : false,
                                        viewportFraction: 1,
                                        autoPlayInterval:
                                            const Duration(seconds: 3),
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _currentBannerIndex = index;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 10),
                                          child: Text('Quick Actions',
                                              style: kBodyTitleB.copyWith(
                                                  color: kBlack)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleIconButton(
                                            onTap: () async {
                                              try {
                                                final membershipDetails =
                                                    await ref.read(
                                                        getProgramMemberByIdProvider(
                                                                id)
                                                            .future);

                                                if (membershipDetails != null) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const FinancialProgramPage(),
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const FinancialAssistancePage(),
                                                    ),
                                                  );
                                                }
                                              } catch (e, stackTrace) {
                                                log('❌ Error fetching membership: $e');
                                                log('Stack trace:\n$stackTrace');

                                                // Optional: Navigate to fallback or show error
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const FinancialAssistancePage(),
                                                  ),
                                                );
                                              }
                                            },
                                            text: 'Check Wallet',
                                            icon:
                                                'assets/svg/icons/wallet_icon.svg'),
                                        CircleIconButton(
                                          icon:
                                              'assets/svg/icons/tree_icon.svg',
                                          text: 'Family Tree',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FamilyTree()),
                                            );
                                          },
                                        ),
                                        CircleIconButton(
                                          icon:
                                              'assets/svg/icons/health_icon.svg',
                                          text: 'Zakath',
                                        ),
                                        CircleIconButton(
                                            text: 'CSR',
                                            icon:
                                                'assets/svg/icons/csr_icon.svg'),
                                      ],
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 16),
                              asyncEvents.when(
                                  data: (events) {
                                    return events.isNotEmpty
                                        ? Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15, top: 10),
                                                    child: Text('Events',
                                                        style: kBodyTitleB
                                                            .copyWith(
                                                                color: kBlack)),
                                                  ),
                                                ],
                                              ),
                                              CarouselSlider(
                                                items: events.map((event) {
                                                  return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.92,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        navigationService
                                                            .pushNamed(
                                                                'ViewMoreEvent',
                                                                arguments:
                                                                    event);
                                                      },
                                                      child: eventWidget(
                                                        context: context,
                                                        event: event,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                options: CarouselOptions(
                                                  enableInfiniteScroll: false,
                                                  height: 340,
                                                  scrollPhysics: events.length >
                                                          1
                                                      ? null
                                                      : const NeverScrollableScrollPhysics(),
                                                  autoPlay: events.length > 1
                                                      ? true
                                                      : false,
                                                  viewportFraction: 1,
                                                  autoPlayInterval:
                                                      const Duration(
                                                          seconds: 3),
                                                  onPageChanged:
                                                      (index, reason) {
                                                    setState(() {
                                                      _currentEventIndex =
                                                          index;
                                                    });
                                                  },
                                                ),
                                              ),
                                              // _buildDotIndicator(_currentEventIndex,
                                              //     events.length, Colors.red),
                                            ],
                                          )
                                        : const SizedBox();
                                  },
                                  loading: () =>
                                      const Center(child: LoadingAnimation()),
                                  error: (error, stackTrace) {
                                    print(error);
                                    print(stackTrace);
                                    return const SizedBox();
                                  }),
                              const SizedBox(height: 16),
                              // Notices Carousel
                              // if (notices.isNotEmpty)
                              //   Column(
                              //     children: [
                              //       CarouselSlider(
                              //         items: notices.map((notice) {
                              //           return customNotice(
                              //               context: context, notice: notice);
                              //         }).toList(),
                              //         options: CarouselOptions(
                              //           scrollPhysics: notices.length > 1
                              //               ? null
                              //               : const NeverScrollableScrollPhysics(),
                              //           autoPlay:
                              //               notices.length > 1 ? true : false,
                              //           viewportFraction: 1,
                              //           height:
                              //               _calculateDynamicHeight(notices),
                              //           autoPlayInterval:
                              //               const Duration(seconds: 3),
                              //           onPageChanged: (index, reason) {
                              //             setState(() {
                              //               _currentNoticeIndex = index;
                              //             });
                              //           },
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //       if (notices.length > 1)
                              //         _buildDotIndicator(
                              //             _currentNoticeIndex,
                              //             notices.length,
                              //             const Color.fromARGB(
                              //                 255, 39, 38, 38)),
                              //     ],
                              //   ),

                              if (posters.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: [
                                      CarouselSlider(
                                        items: posters
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          Promotion poster = entry.value;

                                          return KeyedSubtree(
                                            key: ValueKey(index),
                                            child: customPoster(
                                                context: context,
                                                poster: poster),
                                          );
                                        }).toList(),
                                        options: CarouselOptions(
                                          height: 420,
                                          scrollPhysics: posters.length > 1
                                              ? null
                                              : const NeverScrollableScrollPhysics(),
                                          autoPlay: posters.length > 1,
                                          viewportFraction: 1,
                                          autoPlayInterval:
                                              const Duration(seconds: 5),
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _currentPosterIndex = index;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                              const SizedBox(height: 16),

                              asyncNews.when(
                                data: (news) {
                                  return news.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, top: 10, right: 15),
                                              child: Row(
                                                children: [
                                                  Text('Latest News',
                                                      style:
                                                          kSubHeadingB.copyWith(
                                                              color:
                                                                  kPrimaryColor)),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: () => ref
                                                        .read(
                                                            selectedIndexProvider
                                                                .notifier)
                                                        .updateIndex(3),
                                                    child: const Text('see all',
                                                        style: kSmallTitleR),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              height: 180,
                                              child: ListView.builder(
                                                controller: ScrollController(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: news.length,
                                                itemBuilder: (context, index) {
                                                  final individualNews =
                                                      news[index];
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0),
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      child: newsCard(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  selectedIndexProvider
                                                                      .notifier)
                                                              .updateIndex(3);
                                                        },
                                                        imageUrl: individualNews
                                                                .media ??
                                                            '',
                                                        title: individualNews
                                                                .title ??
                                                            '',
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox();
                                },
                                loading: () =>
                                    const Center(child: LoadingAnimation()),
                                error: (error, stackTrace) => const SizedBox(),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              _CampaignsTabSection(),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        // if (widget.user. ?? false)
                        //   Padding(
                        //     padding: const EdgeInsets.all(16.0),
                        //     child: Align(
                        //       alignment: Alignment.bottomRight,
                        //       child: Container(
                        //         padding: const EdgeInsets.all(13),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           color: kPrimaryColor,
                        //         ),
                        //         child: InkWell(
                        //           onTap: () {
                        //             navigationService
                        //                 .pushNamed('MemberCreation');
                        //           },
                        //           child: const Icon(
                        //             Icons.person_add_alt_1_outlined,
                        //             color: kWhite,
                        //             size: 27,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                );
              },
              loading: () =>
                  Center(child: buildShimmerPromotionsColumn(context: context)),
              error: (error, stackTrace) {
                log(name: "Promotions api call ", error.toString());
                return const Center(child: Text('NO PROMOTIONS YET'));
              },
            ),
          ),
        );
      },
    );
  }

  // Widget _buildStatCard(String title, String value) {
  //   return InkWell(
  //     onTap: () {
  //       String? initialTab;
  //       String? requestType;

  //       switch (title) {
  //         case 'BUSINESS GIVEN':
  //           initialTab = 'sent';
  //           requestType = 'Business';
  //           break;
  //         case 'BUSINESS RECEIVED':
  //           initialTab = 'received';
  //           requestType = 'Business';
  //           break;
  //         case 'REFERRALS GIVEN':
  //           initialTab = 'sent';
  //           requestType = 'Referral';
  //           break;
  //         case 'REFERRALS RECEIVED':
  //           initialTab = 'received';
  //           requestType = 'Referral';
  //           break;
  //         case 'ONE V ONE MEETINGS':
  //           initialTab = 'sent'; // or 'received' based on your preference
  //           requestType = 'One v One Meeting';
  //           break;
  //       }

  //       if (initialTab != null) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => AnalyticsPage(
  //               initialTab: initialTab,
  //               requestType: requestType,
  //               startDate: startDate?.toString().split(' ')[0],
  //               endDate: endDate?.toString().split(' ')[0],
  //             ),
  //           ),
  //         );
  //       }
  //     },
  //     child: Container(
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: kWhite,
  //         borderRadius: BorderRadius.circular(8),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.2),
  //             spreadRadius: 0,
  //             blurRadius: 5,
  //             offset: const Offset(0, 1),
  //           ),
  //         ],
  //       ),
  //       margin: const EdgeInsets.symmetric(vertical: 8),
  //       padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(
  //             title,
  //             style: kSmallerTitleR.copyWith(color: kBlack54, fontSize: 11),
  //             textAlign: TextAlign.start,
  //           ),
  //           const SizedBox(height: 5),
  //           Text(
  //             value,
  //             style: kDisplayTitleB.copyWith(
  //                 color: const Color(0xFF512DB4), fontSize: 20),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Method to build a dot indicator for carousels
  Widget _buildDotIndicator(int currentIndex, int itemCount, Color color) {
    return Center(
      child: SmoothPageIndicator(
        controller: PageController(initialPage: currentIndex),
        count: itemCount,
        effect: WormEffect(
          dotHeight: 10,
          dotWidth: 10,
          activeDotColor: color,
          dotColor: Colors.grey,
        ),
      ),
    );
  }
}

Widget _buildBanners(
    {required BuildContext context, required Promotion banner}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Container(
      height: 250, // Fixed height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                banner.media ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget customPoster({
  required BuildContext context,
  required Promotion poster,
}) {
  return GestureDetector(
    onTap: () {
      if (poster.link != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(
              color: Colors.blue,
              url: poster.link ?? "",
              title: poster.title ?? '',
            ),
          ),
        );
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Apply the border radius here
        child: AspectRatio(
          aspectRatio: 19 / 20,
          child: Image.network(
            poster.media ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child; // Image loaded successfully
              }
              // While the image is loading, show shimmer effect
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget customNotice({
  required BuildContext context,
  required Promotion notice,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: 16), // Adjust spacing between posters
    child: Container(
      width: MediaQuery.of(context).size.width - 32,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        boxShadow: [
          BoxShadow(
            color: kBlack.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(
                0, 5), // Horizontal (0), Vertical (5) for bottom shadow
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: kPrimaryColor,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Notice',
                    style: kSubHeadingB.copyWith(color: kPrimaryColor),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                      width: 70, // Width of the line
                      height: 1, // Thickness of the line
                      color: kPrimaryColor // Line color
                      ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    notice.title!,
                    style: kSmallTitleB.copyWith(color: kBlack),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Container(
                      width: 70, // Width of the line
                      height: 1, // Thickness of the line
                      color: kPrimaryColor // Line color
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  notice.description?.trim() ?? '',
                  style: const TextStyle(color: kGreyDark // Set the font color
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _CampaignsTabSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CampaignsTabSection> createState() =>
      _CampaignsTabSectionState();
}

class _CampaignsTabSectionState extends ConsumerState<_CampaignsTabSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Zakath', 'CSR Campaigns'];
  final List<String> _types = ['zakath', 'csr'];
  int _currentIndex = 0;
  late PageController _pageController;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _pageController = PageController(viewportFraction: 0.92);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      // We'll scroll after data is loaded
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncCampaigns = ref.watch(fetchCampaignsProvider);
    return asyncCampaigns.when(
        data: (campaigns) {
          final zakathCampaigns = campaigns
              .where((c) => c.tagType.toLowerCase() == 'zakath')
              .toList();
          final csrCampaigns =
              campaigns.where((c) => c.tagType.toLowerCase() == 'csr').toList();
          final campaignsList =
              _currentIndex == 0 ? zakathCampaigns : csrCampaigns;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Campaigns',
                        style: kBodyTitleB.copyWith(color: kBlack)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CampaignsMainScreen(),
                          ),
                        );
                      },
                      child: const Text('View All',
                          style: TextStyle(
                              color: kRed, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TabBar(
                  labelPadding: EdgeInsets.symmetric(horizontal: 10),
                  dividerColor: kGreyLight.withOpacity(.2),
                  padding: EdgeInsets.only(left: 10),
                  indicatorWeight: 4,
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: kPrimaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: kPrimaryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  tabAlignment: TabAlignment.start,
                  tabs: _tabs.map((t) => Tab(text: t)).toList(),
                  onTap: (i) {
                    setState(() {
                      _currentIndex = i;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 390,
                child: campaignsList.isEmpty
                    ? const Center(child: Text('No campaigns yet'))
                    : PageView.builder(
                        controller: _pageController,
                        itemCount: campaignsList.length,
                        itemBuilder: (context, index) {
                          final campaign = campaignsList[index];
                          return CampaignCard(
                            campaign: campaign,
                            tag: campaign.tagType,
                            leftButtonLabel: 'Learn More',
                            rightButtonLabel: 'Donate Now',
                            leftButtonAction: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CampaignDetailPage(campaign: campaign),
                                ),
                              );
                            },
                            rightButtonAction: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CampaignDetailPage(campaign: campaign),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: LoadingAnimation()),
        error: (error, stackTrace) {
          log(error.toString());
          return SizedBox.shrink();
        });
  }
}
