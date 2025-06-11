import 'package:flutter/material.dart';

class FinancialProgramPage extends StatefulWidget {
  const FinancialProgramPage({Key? key}) : super(key: key);

  @override
  State<FinancialProgramPage> createState() => _FinancialProgramPageState();
}

class _FinancialProgramPageState extends State<FinancialProgramPage> with SingleTickerProviderStateMixin {
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Financial Assistance Program'),
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Current Balance', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text('₹2500', style: TextStyle(fontSize: 36, color: Colors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: const Text('+  Top Up Wallet', style: TextStyle(fontSize: 18)),
              ),
            ),
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
        border: Border(left: BorderSide(color: Colors.amber, width: 4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.amber),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Low Balance Alert\nYour wallet balance is low. Please top up to continue accessing benefits.',
              style: TextStyle(color: Colors.black87),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Membership status:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('Active', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Last renewed on:', style: TextStyle(fontSize: 16)),
              const Text('20 July 2024', style: TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              const Text('Next renewal on:', style: TextStyle(fontSize: 16)),
              const Text('19 July 2025', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionsTab extends StatelessWidget {
  const _TransactionsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _TransactionCard(
          id: 'VCRU65789900',
          type: 'Wallet Recharge',
          date: '18th May 2025, 10:45 am',
          amount: '₹1500',
          status: 'Pending',
        ),
        const SizedBox(height: 16),
        _TransactionCard(
          id: 'VCRU65789900',
          type: 'Financial Assistance',
          date: '12th July 2025, 12:20 pm',
          amount: '₹200',
          status: 'Rejected',
          reason: 'Reason',
          description: 'Lorem ipsum dolor sit amet consectetur. Sem aliquet odio bibendum non ultrices. Quis gravida fames tempor enim.',
        ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final String id, type, date, amount, status;
  final String? reason, description;
  const _TransactionCard({
    required this.id,
    required this.type,
    required this.date,
    required this.amount,
    required this.status,
    this.reason,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isRejected = status == 'Rejected';
    final isPending = status == 'Pending';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction ID: $id', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Type: $type'),
            Text('date & time: $date'),
            Text('Amount paid: $amount'),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Status: '),
                if (isPending)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('Pending', style: TextStyle(color: Colors.orange)),
                  ),
                if (isRejected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('Rejected', style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
            if (isRejected) ...[
              const SizedBox(height: 8),
              const Text('Reason for rejection'),
              Text(reason ?? ''),
              const SizedBox(height: 8),
              const Text('Description'),
              Text(description ?? ''),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  child: const Text('Re Upload'),
                ),
              ),
            ],
          ],
        ),
      ),
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
      padding: const EdgeInsets.all(16),
      itemCount: members.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final member = members[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: member['image'] == null ? null : NetworkImage(member['image']!),
              child: member['image'] == null ? const Icon(Icons.person) : null,
            ),
            title: Text(member['name']!),
            subtitle: Text(member['role']!),
            trailing: const Icon(Icons.chat_bubble_outline),
            onTap: () {},
          ),
        );
      },
    );
  }
} 