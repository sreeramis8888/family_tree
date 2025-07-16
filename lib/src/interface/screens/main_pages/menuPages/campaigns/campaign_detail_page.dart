import 'dart:math';

import 'package:familytree/src/data/models/campaign_model.dart';
import 'package:familytree/src/interface/screens/CampaignPaymentPage.dart';
import 'package:flutter/material.dart';

import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:intl/intl.dart';

class CampaignDetailPage extends StatefulWidget {
  final CampaignModel campaign;
  const CampaignDetailPage({Key? key, required this.campaign})
      : super(key: key);

  @override
  State<CampaignDetailPage> createState() => _CampaignDetailPageState();
}

class _CampaignDetailPageState extends State<CampaignDetailPage> {
  final TextEditingController _donationController =
      TextEditingController();

  @override
  void dispose() {
    _donationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;
    final collected = campaign.donatedAmount ?? 0;
    final target =campaign.targetAmount ?? 0;
    final progress = (collected / target).clamp(0.0, 1.0);
    final dueDate = DateFormat('dd MMM yyyy').format(campaign.deadline);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kBlack),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Campaign Details', style: kBodyTitleM),
      ),
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 7,
                  child: 
                  // campaign.member?.chapter != null
                  //     ? Image.asset(
                  //         'assets/pngs/graduation_hat.png',
                  //         fit: BoxFit.cover,
                  //       )
                      // :
                       Container(color: kGreyLight),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: kRed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#${campaign.tagType}',
                  style: const TextStyle(
                      color: kWhite, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('₹$collected',
                      style: kSubHeadingB.copyWith(color: kGreen)),
                  const SizedBox(width: 4),
                  const Text('collected out of '),
                  Text('₹$target', style: kSmallTitleB),
                  const SizedBox(width: 60),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: kGreyLight,
                      color: kGreen,
                      minHeight: 7,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('DUE DATE',
                      style:
                          kSmallerTitleB.copyWith(color: kGrey, fontSize: 10)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, color: kRed, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          dueDate,
                          style: kSmallerTitleB.copyWith(
                              color: kPrimaryLightColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                campaign.title,
                style: kSubHeadingB.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                campaign.organizedBy ,
                style: kSmallerTitleR,
              ),
              const SizedBox(height: 28),
              Text('Enter Donation Amount', style: kSmallTitleB),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kGreyLight),
                  borderRadius: BorderRadius.circular(10),
                  color: kWhite,
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('₹', style: TextStyle(fontSize: 20)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _donationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Amount',
                        ),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your donation will help provide educational support to children in need',
                style: TextStyle(fontSize: 13, color: kGrey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.volunteer_activism, color: kWhite),
                  label: const Text('Donate Now',
                      style: TextStyle(fontSize: 18, color: kWhite)),
                    
              onPressed: () {
                      debugPrint("Controller is: $_donationController");

                      try {
                        final amountText = _donationController.text.trim();
                        debugPrint("Amount entered: $amountText");

                        final amount = double.tryParse(amountText);

                        if (amount == null || amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please enter a valid amount")),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CampaignPaymentPage(
                              campaign: widget.campaign,
                              amount: amount,
                            ),
                          ),
                        );
                      } catch (e, stack) {
                        debugPrint("❌ Error: $e\n$stack");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Something went wrong")),
                        );
                      }
                    }



                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
