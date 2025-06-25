import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:flutter/material.dart';

class ProgramJoinOnboardingPage extends StatelessWidget {
  const ProgramJoinOnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavigationService navigationService = NavigationService();
    return Scaffold(
      body: Stack(
        children: [
          // Background image with fade effect
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pngs/financial_hand.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.6, 1.0],
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.85),
                    Colors.black.withOpacity(.95),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    child: Column(
                      children: [
                        Image.asset(
                          scale: 8,
                          'assets/pngs/familytree_logo.png',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Title
                  const Text(
                    'Financial Assistance Program',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Subtitle
                  const Text(
                    'Join the Financial Assistance Program?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Buttons
                  Column(
                    children: [
                      // Read More Button
                      SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: customButton(
                            label: 'Read More',
                            onPressed: () {
                              navigationService
                                  .pushNamed('FinancialAssistancePage');
                            },
                          )),

                      const SizedBox(height: 16),

                      // Skip Now Button
                      SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: customButton(
                              label: 'Skip Now',
                              onPressed: () {
                                navigationService.pushNamed('MainPage');
                              },
                              buttonColor: Colors.transparent,
                              sideColor: kWhite)),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
