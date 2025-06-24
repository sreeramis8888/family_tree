import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/financial_program/financial_program_page.dart';
import 'package:flutter/material.dart';

class FinancialAssistancePage extends StatelessWidget {
  const FinancialAssistancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/hands_image.jpg'), // Replace with your image
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Description
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Financial Assistance Program',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                            'This program is designed to provide financial support to the family of a deceased member through equal contributions collected from all participating members. It fosters unity, shared responsibility, and a compassionate response in times of loss.',
                            style: kSmallerTitleR),
                      ],
                    ),
                  ),

                  // Key Benefits Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Key Benefits', style: kSmallTitleB),
                        const SizedBox(height: 16),
                        _buildBenefitItem(
                          'One-time Assistance',
                          'The deceased member\'s family receives a fixed amount (e.g., ₹10,000).',
                        ),
                        _buildBenefitItem(
                          'Community Funded',
                          'Amount is equally deducted from wallets of all active program members.',
                        ),
                        _buildBenefitItem(
                          'Quick Disbursement',
                          'Funds are transferred within 48 hours of verification and admin approval.',
                        ),
                        _buildBenefitItem(
                          'Secure & Verified',
                          'Only verified members can join, ensuring transparency and eligibility.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Eligibility Criteria Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Eligibility Criteria', style: kSmallTitleB),
                        const SizedBox(height: 16),
                        _buildCriteriaItem(
                            'Must be a verified member of the Family Tree app'),
                        _buildCriteriaItem(
                            'Minimum wallet balance as per requirement'),
                        _buildCriteriaItem(
                            'Admin approval required to activate participation'),
                        _buildCriteriaItem(
                            'Members must remain active to continue coverage'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // How It Works Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('How It Works', style: kSmallTitleB),
                        const SizedBox(height: 16),
                        _buildStepItem(
                          '1.',
                          'Join the Program',
                          'Apply and get verified by the admin.',
                        ),
                        _buildStepItem(
                          '2.',
                          'Maintain Wallet Balance',
                          'Ensure your wallet has a minimum balance for participation.',
                        ),
                        _buildStepItem(
                          '3.',
                          'In Case of Demise',
                          'Admin verifies the incident and triggers fund collection.',
                        ),
                        _buildStepItem(
                          '4.',
                          'Assistance Disbursed',
                          'The beneficiary receives the collective amount via bank transfer.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Important Notes Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Important Notes', style: kSmallTitleB),
                        const SizedBox(height: 16),
                        const Text(
                            'The contribution per member is calculated equally from all active members at the time of disbursement. Members are required to maintain a sufficient wallet balance to ensure uninterrupted participation; failure to do so may result in suspension from the program. Any misuse or submission of false claims will lead to permanent removal from the program and may invite legal action. It is important to note that regular wallet withdrawals unrelated to this program will not be affected.',
                            style: kSmallerTitleR),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Request for Join Button
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: customButton(
                      label: 'Request For Join',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FinancialProgramPage(),
                          ),
                        );
                      },
                    ),
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

  Widget _buildBenefitItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2, right: 12),
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
              color: Color(0xFF38A169),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 10,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: kSmallerTitleB),
                const SizedBox(height: 4),
                Text(description, style: kSmallerTitleR),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(text, style: kSmallerTitleR),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(number, style: kSmallerTitleB),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: kSmallerTitleM),
                const SizedBox(height: 4),
                Text(description, style: kSmallerTitleR),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
