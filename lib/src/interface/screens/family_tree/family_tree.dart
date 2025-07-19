import 'dart:convert';

import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/interface/screens/family_tree/FamilyMembers.dart';
import 'package:familytree/src/interface/screens/family_tree/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:familytree/src/interface/screens/family_tree/family_tree_webview.dart';
import 'package:http/http.dart' as http;

class FamilyTree extends StatefulWidget {
  const FamilyTree({super.key});

  @override
  State<FamilyTree> createState() => _FamilyTreeState();
}

class _FamilyTreeState extends State<FamilyTree> {
  int currentIndex = 2;

  String? familyId;
  String? familyName;
  bool isLoading = true;

  String? personId = id;

  @override
  void initState() {
    super.initState();
    fetchFamilyId();
  }

  Future<void> fetchFamilyId() async {
    try {
      final personRes = await http.get(
        Uri.parse('$baseUrl/people/$personId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (personRes.statusCode != 200) return;

      final personData = jsonDecode(personRes.body)['data'];
      final dynamic familyField =
          personData['family'] ?? personData['familyId'];

      String? id;
      if (familyField is String) {
        id = familyField;
      } else if (familyField is List && familyField.isNotEmpty) {
        id = familyField.first;
      }

      if (id == null) return;

      final familyRes = await http.get(
        Uri.parse('$baseUrl/families/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (familyRes.statusCode != 200) return;

      final familyData = jsonDecode(familyRes.body)['data'];

      if (mounted) {
        setState(() {
          familyId = id;
          familyName = familyData['name'];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching familyId: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 1,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16, top: 12),
          child: Icon(Icons.account_tree, color: Colors.red, size: 20),
        ),
        title: Text(
          "Family Tree",
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ), // sets default icon color
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: 398,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                border: Border.all(
                  color: const Color.fromARGB(255, 237, 237, 237),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 398,
                    height: 152,
                    color: const Color(0xffEAF8EE),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 10,
                          top: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 165,
                              height: 62,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Kalathingal Family",
                                    style: GoogleFonts.roboto(
                                      color: const Color(0XFF272727),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    height: 35,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 85,
                                          child: Center(
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: List.generate(5, (
                                                index,
                                              ) {
                                                return Positioned(
                                                  left: index * 17.0,
                                                  top: -2,
                                                  child: const CircleAvatar(
                                                    radius: 12,
                                                    backgroundImage: AssetImage(
                                                      'assets/pngs/pic.2.jpg',
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            "  5 Relative",
                                            style: GoogleFonts.roboto(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 120,
                          bottom: 0,
                          child: Image.asset(
                            "assets/pngs/Group.png",
                            width: 247,
                            height: 130,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom options
                  Container(
                    height: 81,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    width: 398,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFamilyOption(
                            Icons.account_tree,
                            "Family Tree",
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const FamilyTreeWebView(),
                                ),
                              );
                            },
                          ),
                          _buildFamilyOption(Icons.group, "Members", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FamilyMembers(familyId:familyId! ,familyname: familyName!,),
                              ),
                            );
                          }),
                          _buildFamilyOption(Icons.photo, "Media", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoGalleryPage(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            final isSelected = index == currentIndex;
            final List<Widget> icons = [
              Icon(
                Icons.home,
                color: isSelected ? Colors.white : Colors.grey,
                size: 26,
              ),
              Icon(
                Icons.business_center,
                color: isSelected ? Colors.white : Colors.grey,
                size: 26,
              ),
              Icon(
                Icons.account_tree,
                color: isSelected ? Colors.white : Colors.grey,
                size: 26,
              ),
              SvgPicture.asset(
                'assets/svg/icons/iconamoon_news-fill.svg',
                width: 26,
                height: 26,
                color: isSelected ? Colors.white : Colors.grey,
              ),
              Icon(
                Icons.groups,
                color: isSelected ? Colors.white : Colors.grey,
                size: 26,
              ),
            ];

            return GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 50,
                height: 50,
                decoration: isSelected
                    ? BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 4,
                          ),
                        ],
                      )
                    : const BoxDecoration(),
                child: Center(child: icons[index]),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildFamilyOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xffE83A33), size: 26),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
