import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/financial_program/program_join_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/edit_user.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/models/user_model.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/data/utils/secure_storage.dart';
import 'package:familytree/src/interface/components/Dialogs/premium_dialog.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/levels/chapters.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/levels/district.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/levels/level_members.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/levels/zones.dart';
import 'package:familytree/src/interface/screens/web_view_screen.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/financial_program/financial_program_page.dart';

Widget customDrawer({required UserModel user, required BuildContext context}) {
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
                  onTap: () {
                    if (user.isFinanceProgramMember != null) {
                      if (user.isFinanceProgramMember ?? true) {
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
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FinancialAssistancePage(),
                        ),
                      );
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: 'assets/svg/icons/my_products.svg',
                  label: 'My Products',
                  onTap: () {
                    navigationService.pushNamed('MyProducts');
                  },
                ),
                _buildDrawerItem(
                  icon: 'assets/svg/icons/my_reviews.svg',
                  label: 'My Reviews',
                  onTap: () {
                    navigationService.pushNamed('MyReviews');
                  },
                ),
                _buildDrawerItem(
                  icon: 'assets/svg/icons/my_events.svg',
                  label: 'My Events',
                  onTap: () {
                    navigationService.pushNamed('MyEvents');
                  },
                ),
                _buildDrawerItem(
                  icon: 'assets/svg/icons/my_transactions.svg',
                  label: 'My Transactions',
                  onTap: () {},
                ),
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
                    await SecureStorage.delete('token');
                    await SecureStorage.delete('id');
                    navigationService.pushNamedAndRemoveUntil('PhoneNumber');
                    await editUser({
                      "fcm": "",
                    }, id);
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
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    child: Image.asset(
                                      scale: 25,
                                      'assets/pngs/acutelogo.png',
                                    ),
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
