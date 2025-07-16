import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onReUpload;

  const TransactionCard({
    Key? key,
    required this.transaction,
    this.onReUpload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {




    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: kTertiary),
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction ID: ${transaction.id}',
              style: kSubHeadingB,
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Type', transaction.type.toUpperCase()),
            _buildInfoRow('Date & time', DateFormat('dd-MM-yyyy').format(transaction.date)),
            _buildInfoRow('Amount paid', '₹${transaction.amount}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: kSmallerTitleR.copyWith(color: kGrey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: kSmallTitleB,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowWithStatus(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: kSmallerTitleR.copyWith(color: kGrey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  value,
                  style: kSmallerTitleB.copyWith(color: kPrimaryLightColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 