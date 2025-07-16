<<<<<<< HEAD
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/financial_program/financial_program_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/api_routes/finance_api/finance_api.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FinancialProgramJoinPaymentPage extends ConsumerWidget {
  const FinancialProgramJoinPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minBalanceAsync = ref.watch(getMinimumBalanceProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient shadows
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF8F3F1),
                  Color(0xFFE8D5D1),
                ],
              ),
            ),
          ),
          Positioned(
              top: 50,
              left: 0,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios))),

          // Top left gradient shadow
          Positioned(
            top: 100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD75A19).withOpacity(0.3),
                    const Color(0xFF541212).withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // Middle right gradient shadow
          Positioned(
            top: 200,
            right: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFEA651A).withOpacity(0.2),
                    const Color(0xFFEDBCB0).withOpacity(0.15),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // Bottom right gradient shadow
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF541212).withOpacity(0.2),
                    const Color(0xFFE2601A).withOpacity(0.15),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
            ),
          ),
          minBalanceAsync.when(
              data: (minBalance) {
                final amount = minBalance?.minimumAmount ?? 1000;
                // Main content
                return Column(
                  children: [
                    const SizedBox(height: 60),

                    // Heart logo
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/icons/financial_logo.svg',
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Info Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                          'A contribution is required to activate your membership. This amount will be added to your wallet and used when disbursements are made to families in need.',
                          textAlign: TextAlign.center,
                          style: kSmallerTitleR),
                    ),

                    const Spacer(),

                    // Amount section

                    Column(
                      children: [
                        Text(
                          '₹$amount',
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -2,
                          ),
                        ),
                        Text(
                            'Your participation begins once payment is completed.',
                            textAlign: TextAlign.center,
                            style: kSmallerTitleR),
                      ],
                    ),

                    const Spacer(),

                    // Proceed To Pay Button
                    Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                        child: customButton(
                          label: 'Proceed to Pay',
                          onPressed: () async {
                            final bool success =
                                await FinanceApiService.joinProgram(
                                    memberId: id,
                                    amount: minBalance?.minimumAmount ?? 0);
                            if (success) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const FinancialProgramPage(),
                                ),
                              );
                            }
                          },
                        )),
                  ],
                );
              },
              loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60.0),
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
              error: (e, st) => SizedBox.shrink()),
        ],
      ),
    );
  }
}
=======
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/financial_program/financial_program_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/api_routes/finance_api/finance_api.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FinancialProgramJoinPaymentPage extends ConsumerWidget {
  const FinancialProgramJoinPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minBalanceAsync = ref.watch(getMinimumBalanceProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient shadows
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF8F3F1),
                  Color(0xFFE8D5D1),
                ],
              ),
            ),
          ),
          Positioned(
              top: 50,
              left: 0,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios))),

          // Top left gradient shadow
          Positioned(
            top: 100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD75A19).withOpacity(0.3),
                    const Color(0xFF541212).withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // Middle right gradient shadow
          Positioned(
            top: 200,
            right: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFEA651A).withOpacity(0.2),
                    const Color(0xFFEDBCB0).withOpacity(0.15),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // Bottom right gradient shadow
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF541212).withOpacity(0.2),
                    const Color(0xFFE2601A).withOpacity(0.15),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
            ),
          ),
          minBalanceAsync.when(
              data: (minBalance) {
                final amount = minBalance?.minimumAmount ?? 1000;
                // Main content
                return Column(
                  children: [
                    const SizedBox(height: 60),

                    // Heart logo
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/icons/financial_logo.svg',
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Info Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                          'A contribution is required to activate your membership. This amount will be added to your wallet and used when disbursements are made to families in need.',
                          textAlign: TextAlign.center,
                          style: kSmallerTitleR),
                    ),

                    const Spacer(),

                    // Amount section

                    Column(
                      children: [
                        Text(
                          '₹$amount',
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -2,
                          ),
                        ),
                        Text(
                            'Your participation begins once payment is completed.',
                            textAlign: TextAlign.center,
                            style: kSmallerTitleR),
                      ],
                    ),

                    const Spacer(),

                    // Proceed To Pay Button
                    Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                        child: customButton(
                          label: 'Proceed to Pay',
                          onPressed: () async {
                            final bool success =
                                await FinanceApiService.joinProgram(
                                    memberId: id,
                                    amount: minBalance?.minimumAmount ?? 0);
                            if (success) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const FinancialProgramPage(),
                                ),
                              );
                            }
                          },
                        )),
                  ],
                );
              },
              loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60.0),
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
              error: (e, st) => SizedBox.shrink()),
        ],
      ),
    );
  }
}
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
