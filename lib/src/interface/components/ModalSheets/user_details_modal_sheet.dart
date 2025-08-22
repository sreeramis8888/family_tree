import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';
import 'package:familytree/src/data/models/user_model.dart';
import 'package:intl/intl.dart';

class UserDetailsModalSheet extends ConsumerWidget {
  final String userId;
  UserDetailsModalSheet({Key? key, required this.userId}) : super(key: key);

  String _getAge(DateTime? birthDate) {
    if (birthDate == null) return '';
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NavigationService navigationService = NavigationService();
    final userAsync = ref.watch(fetchUserDetailsProvider(userId));
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: userAsync.when(
            loading: () => const Center(child: LoadingAnimation()),
            error: (e, st) => Center(child: Text('No User')),
            data: (UserModel user) => ListView(
              controller: scrollController,
              children: [
                // Drag indicator
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage:
                        user.image != null ? NetworkImage(user.image!) : null,
                    child: user.image == null
                        ? const Icon(Icons.person, size: 48)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                // Name
                Center(
                  child: Text(
                    user.fullName ?? '-',
                    style: kSubHeadingB,
                  ),
                ),
                // Age subtitle
                Center(
                  child: Text(
                      user.birthDate != null
                          ? '${user.birthDate!.year} (Age - ${_getAge(user.birthDate)})'
                          : '',
                      style: kSmallerTitleR.copyWith(
                          color: Color(0xFF272727), fontSize: 10)),
                ),
                const SizedBox(height: 20),
                // Action row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionIcon(
                      icon: Icons.person_outline,
                      label: 'View profile',
                      onTap: () {
                        navigationService.pushNamed('ProfilePreview',
                            arguments: user);
                      },
                    ),
                    // _ActionIcon(
                    //   icon: Icons.group_add_outlined,
                    //   label: 'Add Relative',
                    //   onTap: () {},
                    // ),
                    // _ActionIcon(
                    //   icon: Icons.mode_edit_outline_outlined,
                    //   label: 'Edit Profile',
                    //   onTap: () {},
                    // ),
                    // _ActionIcon(
                    //   icon: Icons.more_horiz,
                    //   label: 'More',
                    //   onTap: () {},
                    // ),
                  ],
                ),
                const SizedBox(height: 24),
                // Basic Information Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kTertiary),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Basic Information',
                          style: TextStyle(
                              color: Colors.red[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const SizedBox(height: 16),
                      _InfoRow(
                          label: 'Date of Birth',
                          value: user.birthDate != null
                              ? DateFormat('d MMMM yyyy')
                                  .format(user.birthDate!)
                              : '-'),
                      _InfoRow(label: 'Gender', value: user.gender ?? '-'),
                      _InfoRow(
                          label: 'Marital Status', value: user.status ?? '-'),
                      _InfoRow(label: 'Bio', value: user.biography ?? '-'),
                      _InfoRow(
                          label: 'Contact Number', value: user.phone ?? '-'),
                      _InfoRow(label: 'Email', value: user.email ?? '-'),
                      _InfoRow(label: 'Address', value: user.address ?? '-'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionIcon(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 56,
            height: 56,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: kSecondaryColor),
            child: Icon(icon, size: 28, color: Colors.red[400]),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: kSmallerTitleR.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
