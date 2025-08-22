import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/models/transaction_model.dart';
import 'package:familytree/src/data/api_routes/transaction_api/transaction_api.dart';
import 'package:familytree/src/interface/components/Cards/transaction_card.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_choicechip.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';

final fetchAllTransactionsProvider = FutureProvider<List<TransactionModel>>((ref) async {
  return await TransactionApiService.getTransactions(); // No type filter
});

class MyTransactionsPage extends ConsumerWidget {
  const MyTransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('My Transactions', style: kBodyTitleM),
      ),
      body: ref.watch(fetchAllTransactionsProvider).when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(child: Text('No transactions yet'));
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionCard(transaction: transaction);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Failed to load transactions')),
      ),
    );
  }
} 