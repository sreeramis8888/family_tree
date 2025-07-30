import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/screens/family_tree/home_without_member.dart';
import 'package:familytree/src/interface/screens/family_tree/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:familytree/src/interface/screens/family_tree/family_tree_webview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/api_routes/family_api.dart/family_api.dart';
import 'package:familytree/src/data/models/family_model.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';

class FamilyTree extends StatefulWidget {
  final String familyId;
  const FamilyTree({super.key, required this.familyId});

  @override
  State<FamilyTree> createState() => _FamilyTreeState();
}

class _FamilyTreeState extends State<FamilyTree> {
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhite,
        forceMaterialTransparency: true,
        elevation: 1,
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                size: 15,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.account_tree, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text("Family Tree", style: kHeadTitleB),
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 398,
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(
                    color: const Color.fromARGB(255, 237, 237, 237),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              child: Consumer(
                builder: (context, ref, child) {
                  final asyncFamily = ref.watch(
                      fetchSingleFamilyProvider(familyId: widget.familyId));
                  return asyncFamily.when(
                    loading: () => const SizedBox(
                      height: 152,
                      child: Center(child: LoadingAnimation()),
                    ),
                    error: (e, st) => SizedBox(
                      height: 152,
                      child: Center(child: Text('Something went wrong')),
                    ),
                    data: (family) {
                      final members = family.members ?? [];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: double.infinity,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            family.name ?? 'Family',
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                                      children: List.generate(
                                                        members.length > 5
                                                            ? 5
                                                            : members.length,
                                                        (index) {
                                                          final member =
                                                              members[index];
                                                          return Positioned(
                                                            left: index * 17.0,
                                                            top: -2,
                                                            child: Consumer(
                                                              builder: (context,
                                                                  ref, _) {
                                                                if (member
                                                                        .personId ==
                                                                    null) {
                                                                  return const CircleAvatar(
                                                                    radius: 12,
                                                                    child: Icon(
                                                                        Icons
                                                                            .person,
                                                                        size:
                                                                            16),
                                                                  );
                                                                }
                                                                final asyncUser =
                                                                    ref.watch(
                                                                        fetchUserDetailsProvider(
                                                                            member.personId!));
                                                                return asyncUser
                                                                    .when(
                                                                  loading: () => const CircleAvatar(
                                                                      radius:
                                                                          12,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey),
                                                                  error: (e, st) => const CircleAvatar(
                                                                      radius:
                                                                          12,
                                                                      child: Icon(
                                                                          Icons
                                                                              .person,
                                                                          size:
                                                                              16)),
                                                                  data: (user) {
                                                                    if (user.image !=
                                                                            null &&
                                                                        user.image!
                                                                            .isNotEmpty) {
                                                                      return CircleAvatar(
                                                                        radius:
                                                                            12,
                                                                        backgroundImage:
                                                                            NetworkImage(user.image!),
                                                                      );
                                                                    } else {
                                                                      // Show initials if available
                                                                      final initials = (user.fullName != null &&
                                                                              user
                                                                                  .fullName!.isNotEmpty)
                                                                          ? user
                                                                              .fullName!
                                                                              .trim()
                                                                              .split(' ')
                                                                              .map((e) => e.isNotEmpty ? e[0] : '')
                                                                              .take(2)
                                                                              .join()
                                                                              .toUpperCase()
                                                                          : '';
                                                                      return CircleAvatar(
                                                                        radius:
                                                                            12,
                                                                        child: Text(
                                                                            initials,
                                                                            style:
                                                                                const TextStyle(fontSize: 10)),
                                                                      );
                                                                    }
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${members.length} Relative${members.length == 1 ? '' : 's'}',
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildFamilyOption(
                                    Icons.account_tree,
                                    "Family Tree",
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                               FamilyTreeWebView( familyId: widget.familyId,),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildFamilyOption(Icons.group, "Members",
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FamilyMembers(),
                                      ),
                                    );
                                  }),
                                  _buildFamilyOption(Icons.photo, "Media", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PhotoGalleryPage(),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
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
