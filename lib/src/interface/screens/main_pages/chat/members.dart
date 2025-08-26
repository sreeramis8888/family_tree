import 'package:familytree/src/data/models/chat_model.dart';
import 'package:familytree/src/interface/screens/main_pages/profile/profile_preview_withUserModel.dart';
import 'package:familytree/src/interface/screens/main_pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:familytree/src/data/api_routes/chat_api/chat_api.dart';
import 'package:familytree/src/data/api_routes/levels_api/levels_api.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/notifiers/people_notifier.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/screens/main_pages/chat/chat_screen.dart';
import 'package:shimmer/shimmer.dart';

import 'dart:async';
import 'dart:developer';

class MembersPage extends ConsumerStatefulWidget {
  const MembersPage({super.key});

  @override
  ConsumerState<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends ConsumerState<MembersPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  FocusNode _searchFocus = FocusNode();
  Timer? _debounce;
  String? selectedDistrictId;
  String? selectedDistrictName;
  String? businessTagSearch;
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialUsers();
  }

  Future<void> _fetchInitialUsers() async {
    await ref.read(peopleNotifierProvider.notifier).fetchMoreUsers();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(peopleNotifierProvider.notifier).fetchMoreUsers();
    }
  }

  void _onSearchChanged(String query) {
    // if (_debounce?.isActive ?? false) _debounce?.cancel();
    // _debounce = Timer(const Duration(milliseconds: 300), () {
    //   ref.read(peopleNotifierProvider.notifier).searchUsers(query);
    // });
    setState(() {});

  }

  void _onSearchSubmitted(String query) {
    ref.read(peopleNotifierProvider.notifier).searchUsers(query);
  }

  @override
  Widget build(BuildContext context) {
    final usersRaw = ref.watch(peopleNotifierProvider);
    final isLoading = ref.read(peopleNotifierProvider.notifier).isLoading;
    final isFirstLoad = ref.read(peopleNotifierProvider.notifier).isFirstLoad;
    final conversationsAsync = ref.watch(fetchChatConversationsProvider);
    // Filter out the current user
    // final users = usersRaw.where((user) => user.id != id).toList();
    final query = _searchController.text.toLowerCase();
    final users = usersRaw
    .where((user) => user.id != id)
    .where((user) => user.fullName?.toLowerCase().contains(query) ?? false)
    .toList();


    return Scaffold(
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kWhite,
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search Members',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 216, 211, 211),
                              ),
                            ),
                          ),
                          onChanged: _onSearchChanged,
                          onSubmitted: _onSearchSubmitted,
                        ),
                      ),
                      // const SizedBox(width: 8),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //       color: const Color.fromARGB(255, 216, 211, 211),
                      //     ),
                      //     borderRadius: BorderRadius.circular(8.0),
                      //   ),
                      //   child: IconButton(
                      //     icon: Icon(
                      //       Icons.filter_list,
                      //       color: selectedDistrictName != null
                      //           ? Colors.blue
                      //           : Colors.grey,
                      //     ),
                      //     onPressed: _showFilterBottomSheet,
                      //   ),
                      // ),
                    ],
                  ),
                  // if (selectedDistrictName != null || selectedTags.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Wrap(
                  //           spacing: 8,
                  //           runSpacing: 8,
                  //           children: [
                  //             if (selectedDistrictName != null)
                  //               Chip(
                  //                 label: Text(selectedDistrictName!),
                  //                 onDeleted: () {
                  //                   setState(() {
                  //                     selectedDistrictId = null;
                  //                     selectedDistrictName = null;
                  //                   });
                  //                   ref
                  //                       .read(peopleNotifierProvider.notifier)
                  //                       .setDistrict(null);
                  //                 },
                  //               ),
                  //             ...selectedTags.map((tag) => Chip(
                  //                   label: Text(tag),
                  //                   onDeleted: () {
                  //                     setState(() {
                  //                       selectedTags.remove(tag);
                  //                     });
                  //                     ref
                  //                         .read(peopleNotifierProvider.notifier)
                  //                         .setTags(selectedTags);
                  //                   },
                  //                 )),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (isFirstLoad)
              const Center(child: LoadingAnimation())
            else if (users.isNotEmpty)
              conversationsAsync.when(
                loading: () => const Center(child: LoadingAnimation()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (conversations) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == users.length) {
                        return const Center(child: LoadingAnimation());
                      }
                      final user = users[index];
                      // Find direct conversation with this user
                      final directConversation = conversations
                              .where(
                                (c) =>
                                    c.type == 'direct' &&
                                    c.participants.any(
                                        (p) => p.userId == (user.id ?? '')),
                              )
                              .isNotEmpty
                          ? conversations
                              .where(
                                (c) =>
                                    c.type == 'direct' &&
                                    c.participants.any(
                                        (p) => p.userId == (user.id ?? '')),
                              )
                              .first
                          : null;
                      final userId = user.id ?? '';
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePreviewWithUserModel(user: user),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ListTile(
                              leading: SizedBox(
                                height: 40,
                                width: 40,
                                child: ClipOval(
                                  child: Image.network(
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      );
                                    },
                                    user.image ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return SvgPicture.asset(
                                          'assets/svg/icons/dummy_person_small.svg');
                                    },
                                  ),
                                ),
                              ),
                              title: Text(user.fullName ?? ''),
                              trailing: SizedBox(
                                width: 40,
                                height: 40,
                                child: IconButton(
                                  icon: const Icon(Icons.chat_bubble_outline),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () async {
                                      if (directConversation != null) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => IndividualPage(conversationUserId: user.id??'',
                                              conversationImage: user.image ?? '',
                                              conversationTitle: user.fullName ?? 'Chat',
                                              conversation: directConversation,
                                              currentUserId: id,
                                            ),
                                          ),
                                        ).then((_) {
                                          ref.invalidate(fetchChatConversationsProvider);
                                        });
                                      } else {
                                        final newConversation = await ChatApi().fetchDirectConversation(userId);
                                        log('DIRECT CONVERSATION:${newConversation.toJson()}');

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => IndividualPage(conversationUserId: user.id??'',
                                              conversationImage: user.image ?? '',
                                              conversationTitle: user.fullName ?? 'Chat',
                                              conversation: newConversation,
                                              currentUserId: id,
                                            ),
                                          ),
                                        ).then((_) {
                                          ref.invalidate(fetchChatConversationsProvider);
                                        });
                                      }
                                    }

                                  // onPressed: () async {
                                  //       if (directConversation != null) {
                                  //         Navigator.of(context).push(
                                  //           MaterialPageRoute(
                                  //             builder: (context) => IndividualPage(
                                  //               conversationImage: directConversation.participants[1].user?.image ?? '',
                                  //               conversationTitle: directConversation.participants[1].user?.fullName ?? '',
                                  //               conversation: directConversation,
                                  //               currentUserId: id,
                                  //             ),
                                  //           ),
                                  //         ).then((_) {
                                  //           // Force ChatDash to update when you come back
                                  //           ref.invalidate(fetchChatConversationsProvider);
                                  //         });


                                  //       } else {
                                  //         final newConversation = await ChatApi().fetchDirectConversation(userId);
                                  //         log('DIRECT CONVERSATION:${newConversation.toJson()}');

                                  //         Navigator.of(context).push(
                                  //           MaterialPageRoute(
                                  //             builder: (context) => IndividualPage(
                                  //               conversationImage: newConversation.participants[1].user?.image ?? '',
                                  //               conversationTitle: newConversation.participants[1].user?.fullName ?? '',
                                  //               conversation: newConversation,
                                  //               currentUserId: id,
                                  //             ),
                                  //           ),
                                  //         ).then((_) {
                                  //           // 🔥 Same for new chats
                                  //           ref.invalidate(fetchChatConversationsProvider);
                                  //         });
                                  //       }
                                  //     }
                                  
                                  
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Color.fromARGB(255, 227, 221, 221),
                              height: 1,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            else
              const Column(
                children: [
                  SizedBox(height: 100),
                  Text(
                    'No Members Found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _tagController.dispose();
    _debounce?.cancel();
    _searchFocus.dispose();
    super.dispose();
  }
}
