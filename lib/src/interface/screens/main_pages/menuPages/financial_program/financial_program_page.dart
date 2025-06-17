import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/models/transaction_model.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_choicechip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinancialProgramPage extends StatefulWidget {
  const FinancialProgramPage({Key? key}) : super(key: key);

  @override
  State<FinancialProgramPage> createState() => _FinancialProgramPageState();
}

class _FinancialProgramPageState extends State<FinancialProgramPage>
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
          _LowBalanceAlert(),
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

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
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
            const Text('₹2500',
                style: TextStyle(
                    fontSize: 36,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
                width: double.infinity,
                child: customButton(
                  label: '+ Top Up Wallet',
                  onPressed: () {},
                )),
          ],
        ),
      ),
    );
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

class _MembershipTab extends StatelessWidget {
  const _MembershipTab();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter, // Keep it top-aligned if needed
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
                  Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('Active',
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Last renewed on:', style: kSmallTitleM),
                  Text('19 July 2025',
                      style: kSmallTitleB.copyWith(color: kPrimaryColor)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Next renewal on:', style: kSmallTitleM),
                  Text('19 July 2025',
                      style: kSmallTitleM.copyWith(color: kPrimaryColor)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionsTab extends StatefulWidget {
  const _TransactionsTab();

  @override
  State<_TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<_TransactionsTab> {
  String selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildChoiceChip('All'),
              _buildChoiceChip('Pending'),
              _buildChoiceChip('Approved'),
              _buildChoiceChip('Rejected'),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _transactionCard(
                  id: 'VCRU65789900',
                  category: 'Wallet Recharge',
                  date: DateTime(2025, 5, 18, 10, 45),
                  amount: 1500,
                  status: 'Pending'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceChip(String label) {
    return CustomChoiceChip(
      label: label,
      selected: selectedStatus == label,
      onTap: () {
        setState(() {
          selectedStatus = label;
        });
      },
    );
  }

  Widget _transactionCard( {required String id,required String category,required DateTime date,required int amount, required String status}) {
    String formattedDate = '';
    if (date != null) {
      formattedDate =
          DateFormat('d\'th\' MMMM y, h:mm a').format(date!);
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
                      status?.toUpperCase() ?? '',
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
              if (date != null)
                _detailRow('Date & time', formattedDate),
              _detailRow('Amount paid',
                  '${amount ?? ''}'), // Placeholder for now
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

class _MembersTab extends StatelessWidget {
  const _MembersTab();

  @override
  Widget build(BuildContext context) {
    final members = [
      {'name': 'John flitzgerald', 'role': 'Event Manager', 'image': null},
      {'name': 'Céline Wolf', 'role': 'Event Manager', 'image': null},
      {'name': 'Céline Wolf', 'role': 'Event Manager', 'image': null},
      {'name': 'Céline Wolf', 'role': 'Event Manager', 'image': null},
      {'name': 'Céline Wolf', 'role': 'Event Manager', 'image': null},
      {'name': 'Céline Wolf', 'role': 'Event Manager', 'image': null},
    ];
    return ListView.separated(
      itemCount: members.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final member = members[index];
        return Column(
          children: [
            Container(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: member['image'] == null
                      ? null
                      : NetworkImage(member['image']!),
                  child:
                      member['image'] == null ? const Icon(Icons.person) : null,
                ),
                title: Text(member['name']!),
                subtitle: Text(member['role']!),
                trailing: const Icon(Icons.chat_bubble_outline),
                onTap: () {},
              ),
            ),
          ],
        );
      },
    );
  }
}
