import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:familytree/src/data/models/activity_model.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:intl/intl.dart';

class CampaignCard extends StatelessWidget {
  final ActivityModel campaign;
  final String tag;
  final String leftButtonLabel;
  final String rightButtonLabel;
  final VoidCallback? leftButtonAction;
  final VoidCallback? rightButtonAction;

  const CampaignCard({
    Key? key,
    required this.campaign,
    required this.tag,
    required this.leftButtonLabel,
    required this.rightButtonLabel,
    this.leftButtonAction,
    this.rightButtonAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final collected = campaign.amount ?? 0;
    final target = 5000; // You may want to make this dynamic
    final progress = (collected / target).clamp(0.0, 1.0);
    final dueDate = campaign.date != null
        ? DateFormat('dd MMM yyyy').format(DateTime.parse(campaign.date!))
        : '-';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: kTertiary),
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 7,
              child: campaign.member?.chapter != null
                  ? Image.asset(
                      'assets/pngs/graduation_hat.png',
                      fit: BoxFit.cover,
                    )
                  : Container(color: kGreyLight),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: kRed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(
                            color: kWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹$collected',
                      style: kSubHeadingB.copyWith(color: kGreen),
                    ),
                    const SizedBox(width: 4),
                    const Text('collected out of '),
                    Text(
                      '₹$target',
                      style: kSmallTitleB,
                    ),
                    const SizedBox(
                        width: 8), // optional spacing before progress bar
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('DUE DATE',
                        style: kSmallerTitleB.copyWith(
                            color: kGrey, fontSize: 10)),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month,
                              color: kRed, size: 12),
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
                const SizedBox(height: 10),
                Text(
                  campaign.title ?? '',
                  style: kSubHeadingB,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  campaign.description ?? '',
                  style: kSmallerTitleR,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (rightButtonLabel != 'View Details')
                      Expanded(
                          child: customButton(
                        labelColor: kBlack,
                        sideColor: kSecondaryColor,
                        buttonColor: kSecondaryColor,
                        label: leftButtonLabel,
                        onPressed: leftButtonAction ?? () {},
                      )),
                    if (rightButtonLabel != 'View Details')
                      const SizedBox(width: 12),
                    Expanded(
                        child: customButton(
                      label: rightButtonLabel,
                      onPressed: rightButtonAction ?? () {},
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
