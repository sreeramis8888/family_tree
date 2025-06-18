import 'package:flutter/material.dart';
import 'package:familytree/src/data/models/transaction_model.dart';
import 'package:familytree/src/interface/components/Cards/transaction_card.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_choicechip.dart';

class TransactionsListPage extends StatefulWidget {
  const TransactionsListPage({Key? key}) : super(key: key);

  @override
  State<TransactionsListPage> createState() => _TransactionsListPageState();
}

class _TransactionsListPageState extends State<TransactionsListPage>
    with TickerProviderStateMixin {
  late TabController _subTabController;
  final List<String> _transactionSubTabs = [
    'All Transactions',
    'Approved',
    'Pending',
    'Rejected'
  ];

  // Mock data for demonstration
  final List<TransactionModel> allTransactions = [
    TransactionModel(
      id: 'VCRU65789900',
      type: 'csr',
      dateTime: '18th May 2025, 10:45 am',
      amountPaid: 1500,
      status: 'pending',
    ),
    TransactionModel(
      id: 'VCRU65789901',
      type: 'zakath',
      dateTime: '12th July 2025, 12:20 pm',
      amountPaid: 200,
      status: 'rejected',
      reasonForRejection: 'Reason',
      description:
          'Lorem ipsum dolor sit amet consectetur. Sem aliquet odio bibendum non ultrices. Quis gravida fames tempor enim.',
    ),
    TransactionModel(
      id: 'VCRU65789902',
      type: 'csr',
      dateTime: '20th April 2025, 09:00 am',
      amountPaid: 500,
      status: 'approved',
    ),
    TransactionModel(
      id: 'VCRU65789903',
      type: 'zakath',
      dateTime: '01st June 2025, 03:00 pm',
      amountPaid: 1000,
      status: 'pending',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _subTabController =
        TabController(length: _transactionSubTabs.length, vsync: this);

    _subTabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _subTabController.dispose();
    super.dispose();
  }

  List<TransactionModel> _getTransactionsForTab(int index) {
    switch (_transactionSubTabs[index]) {
      case 'Approved':
        return allTransactions.where((t) => t.status == 'approved').toList();
      case 'Pending':
        return allTransactions.where((t) => t.status == 'pending').toList();
      case 'Rejected':
        return allTransactions.where((t) => t.status == 'rejected').toList();
      case 'All Transactions':
      default:
        return allTransactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _transactionSubTabs.asMap().entries.map((entry) {
              int idx = entry.key;
              String text = entry.value;
              return CustomChoiceChip(
                label: text,
                selected: _subTabController.index == idx,
                onTap: () {
                  _subTabController.animateTo(idx);
                },
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            children: List.generate(_transactionSubTabs.length, (tabIndex) {
              final transactions = _getTransactionsForTab(tabIndex);
              if (transactions.isEmpty) {
                return const Center(child: Text('No transactions yet'));
              }
              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return TransactionCard(
                    transaction: transaction,
                    onReUpload: () {
                      // TODO: Implement re-upload logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Re-uploading transaction ${transaction.id}')),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
