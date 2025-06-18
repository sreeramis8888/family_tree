import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:familytree/src/data/constants/color_constants.dart';

class ApprovalWaitingPage extends StatelessWidget {
  const ApprovalWaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/images/approval_waiting.svg', height: 120),
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
