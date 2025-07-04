import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:flutter/material.dart';

import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ApprovalWaitingPage extends StatelessWidget {
  const ApprovalWaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: kWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: InkWell(
          onTap: () {
            NavigationService navigationService = NavigationService();
            navigationService.pushNamedReplacement('PhoneNumber');
          },
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.logout,
                color: kPrimaryColor,
              ),
              Text(
                'Logout',
                style: kSmallTitleB.copyWith(
                  color: kPrimaryColor,
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: kWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.fourRotatingDots(
                color: kPrimaryColor, size: 130),
            const SizedBox(height: 32),
            const Text(
              'Your request to join has been sent',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Access to the app will be made available to you soon! Thank you for your patience.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
