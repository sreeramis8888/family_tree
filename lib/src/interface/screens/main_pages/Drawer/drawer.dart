import 'dart:developer';

import 'package:familytree/src/data/api_routes/finance_api/finance_api.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/financial_program/program_join_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/edit_user.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/models/user_model.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/data/utils/secure_storage.dart';
import 'package:familytree/src/interface/components/Dialogs/premium_dialog.dart';
import 'package:familytree/src/interface/screens/web_view_screen.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/financial_program/financial_program_page.dart';
import 'package:familytree/src/data/notifiers/user_notifier.dart';

Widget customDrawer(
    {required UserModel user,
    required BuildContext context,
    required WidgetRef ref}) {
  NavigationService navigationService = NavigationService();
  return Drawer(
    child: Column(
      children: [
        // Red Header
        Container(
          color: kWhite,
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(40))),
            padding:
                const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/pngs/familytree_logo.png',
                      scale: 40,
                      color: Colors.white,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(user.image ?? ''),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'View profile',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (user.status != 'trial') {
                          navigationService.pushNamed('EditUser');
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => const PremiumDialog(),
                          );
                        }
                      },
                      icon: SvgPicture.asset('assets/svg/icons/edit_icon.svg',
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Menu Items
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),

                _buildDrawerItem(
                  icon: 'assets/svg/icons/financial_logo.svg',
                  label: 'Financial Program',
                  onTap: () async {
                    try {
                      final membershipDetails = await ref
                          .read(getProgramMemberByIdProvider(id).future);

                      if (membershipDetails != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FinancialProgramPage(),
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
                          builder: (context) => const FinancialAssistancePage(),
                        ),
                      );
                    }
                  },
                ),
                if (user.isFamilyAdmin == true)
                  _buildDrawerItem(
                    icon: 'assets/svg/icons/approvals.svg',
                    label: 'Approvals',
                    onTap: () {
                      navigationService.pushNamed('Approvals');
                    },
                  ),

                // _buildDrawerItem(
                //   icon: 'assets/svg/icons/my_products.svg',
                //   label: 'My Posts',
                //   onTap: () {
                //     navigationService.pushNamed('MyRequirements');
                //   },
                // ),
                // _buildDrawerItem(
                //   icon: 'assets/svg/icons/my_reviews.svg',
                //   label: 'My Reviews',
                //   onTap: () {
                //     navigationService.pushNamed('MyReviews');
                //   },
                // ),
                _buildDrawerItem(
                  icon: 'assets/svg/icons/my_events.svg',
                  label: 'My Events',
                  onTap: () {
                    navigationService.pushNamed('MyEvents');
                  },
                ),
                // _buildDrawerItem(
                //   icon: 'assets/svg/icons/my_transactions.svg',
                //   label: 'My Transactions',
                //   onTap: () {},
                // ),
                // _buildDrawerItem(
                //   icon: 'assets/svg/icons/my_post.svg',
                //   label: 'My Post',
                //   onTap: () {},
                // ),
                const Divider(),
                _buildDrawerItem(
                  icon: 'assets/svg/icons/about_us.svg',
                  label: 'About Us',
                  onTap: () {
                    navigationService.pushNamed('AboutPage');
                  },
                ),
                _buildDrawerItem(
                  icon: 'assets/svg/icons/terms.svg',
                  label: 'Terms & Conditions',
                  onTap: () {
                    navigationService.pushNamed('Terms');
                  },
                ),
                _buildDrawerItem(
                  icon: 'assets/svg/icons/privacy_policy.svg',
                  label: 'Privacy Policy',
                  onTap: () {
                    navigationService.pushNamed('PrivacyPolicy');
                  },
                ),
                _buildDrawerItem(
                  icon: 'assets/svg/icons/logout.svg',
                  label: 'Logout',
                  onTap: () async {
                    await SecureStorage.deleteAll();
                    // Clear in-memory globals
                    token = '';
                    id = '';
                    fcmToken = '';
                    LoggedIn = false;
                    subscriptionType = 'free';
                    // Reset userProvider state
                    ref.invalidate(userProvider);
                    navigationService.pushNamedAndRemoveUntil('PhoneNumber');
                    // await editUser({
                    //   "fcm": "",
                    // }, id);
                    final tokenVal = await SecureStorage.read('token');
                    final userId = await SecureStorage.read('id');
                    final phone = await SecureStorage.read('phone');
                    log('authToken: [31m$tokenVal [0m userId: [31m$userId [0m phone: [31m$phone [0m');
                  },
                ),
                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildDrawerItem(
                    icon: 'assets/svg/icons/delete_account.svg',
                    label: 'Delete Account',
                    textColor: kRedDark,
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 8),
                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WebViewScreen(
                                  color: Colors.blue,
                                  url: 'https://www.skybertech.com/',
                                  title: 'Skybertech',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kGrey),
                              color: const Color.fromARGB(255, 246, 246, 246),
                            ),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 22, right: 22),
                                  child: Text(
                                    'Powered by',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                                Image.asset(
                                  scale: 15,
                                  'assets/pngs/skybertechlogo.png',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WebViewScreen(
                                  color: Colors.deepPurpleAccent,
                                  url: 'https://www.acutendeavors.com/',
                                  title: 'ACUTE ENDEAVORS',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kGrey),
                              color: const Color.fromARGB(255, 246, 246, 246),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2, bottom: 3),
                                    child: Text(
                                      'Developed by',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Image.asset(
                                    scale: 1.6,
                                    fit: BoxFit.contain,
                                    'assets/pngs/xyvin.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        // Delete Account at the bottom
      ],
    ),
  );
}

Widget _buildDrawerItem({
  required String icon,
  required String label,
  VoidCallback? onTap,
  Color textColor = Colors.black,
}) {
  return ListTile(
    leading: SvgPicture.asset(icon, height: 21, color: kBlack),
    title: Text(
      label,
      style: TextStyle(fontSize: 14, color: textColor),
    ),
    onTap: onTap,
  );
}
