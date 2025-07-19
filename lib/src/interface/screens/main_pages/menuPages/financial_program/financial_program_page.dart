// your imports stay the same
import 'package:familytree/src/data/services/payment_service/checkwalletapi.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/transaction_model.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_choicechip.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/api_routes/finance_api/finance_api.dart';
import 'package:familytree/src/data/notifiers/members_notifier.dart';
import 'package:familytree/src/data/notifiers/transactions_notifier.dart';

class FinancialProgramPage extends ConsumerStatefulWidget {
  const FinancialProgramPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FinancialProgramPage> createState() =>
      _FinancialProgramPageState();
}

class _FinancialProgramPageState extends ConsumerState<FinancialProgramPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: kWhite,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 15,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Financial Assistance Program',
          style: kBodyTitleR,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _BalanceCard(),
          const SizedBox(height: 8),
          const _LowBalanceAlert(),
          const SizedBox(height: 8),
          TabBar(
            controller: _tabController,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.red,
            tabs: const [
              Tab(text: 'Membership'),
              Tab(text: 'Transactions'),
              Tab(text: 'Members'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _MembershipTab(),
                _TransactionsTab(),
                _MembersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends ConsumerWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(getProgramMemberByIdProvider(id));
    return memberAsync.when(
      data: (member) {
        final walletBalance = member?.memberId.walletBalance ?? 0.0;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 35),
          decoration: BoxDecoration(
              border: Border.all(color: kTertiary),
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text('Current Balance', style: kSmallTitleR),
                const SizedBox(height: 8),
                Text('₹${walletBalance.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 36,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: customButton(
                    label: '+ Top Up Wallet',
                    onPressed: () async {
                      final amount = await showDialog<double>(
                        context: context,
                        builder: (context) {
                          double? enteredAmount;
                          final controller = TextEditingController();
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: Row(
                              children: const [
                                Icon(Icons.account_balance_wallet,
                                    color: Colors.red),
                                SizedBox(width: 8),
                                Text('Top Up Wallet'),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Enter the amount you want to add to your wallet:',
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: controller,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.currency_rupee),
                                    hintText: 'Amount',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  onChanged: (value) {
                                    enteredAmount = double.tryParse(value);
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton.icon(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.cancel),
                                label: const Text('Cancel'),
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.check_circle_outline),
                                label: const Text("Top Up"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  if (enteredAmount != null &&
                                      enteredAmount! > 0) {
                                    Navigator.of(context).pop();
                                    final amountToTopUp = enteredAmount!;

                                    final topupPayment = TopupPaymentService(
                                      amount: amountToTopUp,
                                      onSuccess: (msg) async {
                                        await handleTopupSuccess(
                                          ref: ref,
                                          context: context,
                                          id: id,
                                          amount: amountToTopUp,
                                        );
                                      },
                                      onError: (msg) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(content: Text(msg)),
                                          );
                                        }
                                      },
                                    );
                                    topupPayment.init();
                                    await topupPayment.startPayment();
                                  } else {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please enter a valid amount.')),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 35),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            border: Border.all(color: kTertiary),
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(12)),
        child: const Text('Failed to load balance'),
      ),
    );
  }
}

Future<void> handleTopupSuccess({
  required WidgetRef ref,
  required BuildContext context,
  required String id,
  required double amount,
}) async {
  final success = await ref.read(joinProgramProvider(
    memberId: id,
    amount: amount,
  ).future);

  debugPrint("success1");

  if (success) {
    debugPrint("success2");

    ref.invalidate(getProgramMemberByIdProvider(id));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallet topped up successfully!')),
      );
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to top up wallet.')),
      );
    }
  }
}


class _LowBalanceAlert extends StatelessWidget {
  const _LowBalanceAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: Color(0xFFA96409), width: 4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Color(0xFFA96409)),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Low Balance Alert.',
                  style: kSmallerTitleM.copyWith(color: Color(0xFFA96409)),
                ),
                Text(
                  'Your wallet balance is low. Please top up to continue accessing benefits.',
                  style: kSmallerTitleR.copyWith(color: Color(0xFFCF811B)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _MembershipTab extends ConsumerWidget {
  const _MembershipTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(getProgramMemberByIdProvider(id));
    return memberAsync.when(
      data: (member) {
        if (member == null) {
          return const Center(child: Text('Not a program member.'));
        }
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kTertiary),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Membership status:', style: kSmallTitleM),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: member.membershipStatus == 'active'
                              ? const Color(0xFF2E7D32)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(member.membershipStatus,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Last renewed on:', style: kSmallTitleM),
                      // TODO: Replace with actual renewal date if available
                      Text('-',
                          style: kSmallTitleB.copyWith(color: kPrimaryColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Next renewal on:', style: kSmallTitleM),
                      // TODO: Replace with actual next renewal date if available
                      Text('-',
                          style: kSmallTitleM.copyWith(color: kPrimaryColor)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) =>
          const Center(child: Text('Failed to load membership info.')),
    );
  }
}

class _TransactionsTab extends ConsumerStatefulWidget {
  const _TransactionsTab();

  @override
  ConsumerState<_TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends ConsumerState<_TransactionsTab> {
  String selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsNotifierProvider);
    final txNotifier = ref.read(transactionsNotifierProvider.notifier);
    final isLoading = txNotifier.isLoading;
    final hasMore = txNotifier.hasMore;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!isLoading &&
            hasMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          txNotifier.fetchMoreTransactions();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async => await txNotifier.refresh(),
        child: transactions.isEmpty && isLoading
            ? const Center(child: CircularProgressIndicator())
            : transactions.isEmpty
                ? const Center(child: Text('No transactions found.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == transactions.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final tx = transactions[index];
                      return _transactionCard(
                        id: tx.id,
                        category: tx.type,
                        date: tx.date,
                        amount: tx.amount,
                        status: tx.method,
                      );
                    },
                  ),
      ),
    );
  }

  Widget _transactionCard(
      {required String id,
      required String category,
      required DateTime date,
      required double amount,
      required String status}) {
    String formattedDate = '';
    if (date != null) {
      formattedDate = DateFormat('d\'th\' MMMM y, h:mm a').format(date!);
    }

    Color statusColor = status == 'approved'
        ? Colors.green
        : status == 'pending'
            ? Colors.orange
            : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: const Color.fromARGB(255, 225, 217, 217)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transaction ID: ${id}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF616161),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _detailRow('Type', category ?? ''),
              if (date != null) _detailRow('Date & time', formattedDate),
              _detailRow(
                  'Amount paid', '${amount ?? ''}'), // Placeholder for now
              // if (transaction.status == 'rejected')
              //   Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const SizedBox(height: 8),
              //       const Text(
              //         'Reason for rejection:',
              //         style: TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //       const Text(
              //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              //         style: TextStyle(fontSize: 12),
              //       ),
              //       const SizedBox(height: 8),
              //       Center(
              //         child: ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: const Color(0xFF004797),
              //             foregroundColor: Colors.white,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(5),
              //             ),
              //           ),
              //           onPressed: () {
              //             // Implement re-upload logic
              //           },
              //           child: const Text('RE-UPLOAD'),
              //         ),
              //       ),
              //     ],
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF616161),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFE0E0E0),
        ),
      ],
    );
  }
}

class _MembersTab extends ConsumerStatefulWidget {
  const _MembersTab();

  @override
  ConsumerState<_MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends ConsumerState<_MembersTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Optionally, fetch initial members if not already loaded
    if (ref.read(membersNotifierProvider).isEmpty) {
      ref.read(membersNotifierProvider.notifier).fetchMoreMembers();
    }
  }

  void _onScroll() {
    final notifier = ref.read(membersNotifierProvider.notifier);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!notifier.isLoading && notifier.hasMore) {
        notifier.fetchMoreMembers();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersNotifierProvider);
    final membersNotifier = ref.read(membersNotifierProvider.notifier);
    final isLoading = membersNotifier.isLoading;
    final hasMore = membersNotifier.hasMore;

    if (members.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (members.isEmpty) {
      return const Center(child: Text('No members found.'));
    }

    return RefreshIndicator(
      onRefresh: () async => await membersNotifier.refresh(),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: members.length + (hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          if (index == members.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final member = members[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(
              member.fullName,
              style: kBodyTitleB,
            ),
            subtitle: Text(member.status),
            trailing: const Icon(Icons.chat_bubble_outline),
            onTap: () {},
          );
        },
      ),
    );
  }
}
