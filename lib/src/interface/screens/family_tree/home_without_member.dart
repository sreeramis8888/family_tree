import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/user_model.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class FamilyMembers extends StatefulWidget {
  const FamilyMembers({super.key});

  @override
  State<FamilyMembers> createState() => _FamilyMembersState();
}

class _FamilyMembersState extends State<FamilyMembers> {
  Map<String, List<UserModel>> pendingApprovals = {
    'Member': [],
  };

  final String personId = id;
  String? familyName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFamilyMembersFromPerson();
  }

  Future<void> fetchFamilyMembersFromPerson() async {
    try {
      final personRes = await http.get(
        Uri.parse('$baseUrl/people/$personId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      log('Requesting url:$baseUrl/people/$id');
      if (personRes.statusCode != 200) return;
      final personData = jsonDecode(personRes.body)['data'];

      final dynamic familyField =
          personData['family'] ?? personData['familyId'];
      String? familyId;

      if (familyField is String) {
        familyId = familyField;
      } else if (familyField is List && familyField.isNotEmpty) {
        final firstItem = familyField.first;
        if (firstItem is String) {
          familyId = firstItem;
        } else if (firstItem is Map<String, dynamic>) {
          familyId = firstItem['_id'];
        }
      } else {
        familyId = null;
      }

      if (familyId == null) return;

      final familyRes = await http.get(
        Uri.parse('$baseUrl/families/$familyId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (familyRes.statusCode != 200) return;
      final familyData = jsonDecode(familyRes.body)['data'];
      final List members = familyData['members'];

      familyName = familyData['name'];

      List<UserModel> memberList = [];

      for (final member in members) {
        final String id = member['_id'];

        final memberRes = await http.get(
          Uri.parse('$baseUrl/people/$id'),
          headers: {'Authorization': 'Bearer $token'},
        );
        log('Requesting url:$baseUrl/people/$id');
        if (memberRes.statusCode == 200) {
          final memberData = jsonDecode(memberRes.body)['data'];
          final user = UserModel.fromJson(memberData);
          memberList.add(user);
        }
      }

      setState(() {
        pendingApprovals['Member'] = memberList;
        isLoading = false; // ✅ Hide loader when done
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // ✅ Still hide loader on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ✅ AppBar with shadow using a Container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: AppBar(
                backgroundColor: Colors.white,
                forceMaterialTransparency: true,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "Family Members",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color(0xff272727),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 12,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [const SizedBox(width: 48)],
              ),
            ),
          ),

          // ✅ Content with loading or members list
          Expanded(
            child: isLoading
                ? const Center(child: LoadingAnimation())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16),
                            child: Text(
                              "$familyName Family",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: const Color(0xffE83A33),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          for (String category in pendingApprovals.keys)
                            for (UserModel user in pendingApprovals[category]!)
                              GestureDetector(
                                onTap: () {
                                  NavigationService navigationService =
                                      NavigationService();
                                  navigationService.pushNamed(
                                      'ProfilePreviewUsingID',
                                      arguments: user.id);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 0),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (user.image != null)
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: user.image!
                                                    .startsWith("http")
                                                ? NetworkImage(user.image!)
                                                : File(user.image!).existsSync()
                                                    ? FileImage(
                                                        File(user.image!))
                                                    : const AssetImage(
                                                            'assets/pngs/approval-profile.jpg')
                                                        as ImageProvider,
                                          ),
                                        if (user.image == null)
                                          const CircleAvatar(
                                            radius: 20,
                                            backgroundImage: AssetImage(
                                              'assets/pngs/approval-profile.jpg',
                                            ),
                                          ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${user.fullName ?? 'Unnamed'}',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  height: 1.31,
                                                  color:
                                                      const Color(0xff272727),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                familyName!,
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11,
                                                  height: 1.31,
                                                  color:
                                                      const Color(0xff272727),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                user.birthDate != null
                                                    ? '${user.birthDate!.day}/${user.birthDate!.month}/${user.birthDate!.year}'
                                                    : 'Unknown DOB',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 11,
                                                  height: 1.31,
                                                  color:
                                                      const Color(0xff272727),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
