import 'dart:developer';
import 'package:familytree/src/interface/screens/main_pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/user_model.dart';
import 'package:familytree/src/data/services/extract_level_details.dart';
import 'package:familytree/src/data/services/hex_to_color.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/data/services/save_contact.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:familytree/src/interface/components/Cards/award_card.dart';
import 'package:familytree/src/interface/components/Cards/certificate_card.dart';
import 'package:familytree/src/interface/components/animations/glowing_profile.dart';
import 'package:familytree/src/interface/components/common/review_barchart.dart';
import 'package:familytree/src/interface/components/custom_widgets/blue_tick_names.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_icon_container.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/components/shimmers/preview_shimmer.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:familytree/src/data/api_routes/chat_api/chat_api.dart';
import 'package:familytree/src/interface/screens/main_pages/chat/chat_screen.dart';

class ReviewsState extends StateNotifier<int> {
  ReviewsState() : super(1);

  void showMoreReviews(int totalReviews) {
    state = (state + 2).clamp(0, totalReviews);
  }
}

final reviewsProvider = StateNotifierProvider<ReviewsState, int>((ref) {
  return ReviewsState();
});

class ProfilePreviewUsingId extends ConsumerWidget {
  final String userId;
  ProfilePreviewUsingId({
    super.key,
    required this.userId,
  });

  final List<String> svgIcons = [
    'assets/svg/icons/icons8-facebook.svg',
    'assets/svg/icons/twitter.svg',
    'assets/svg/icons/instagram.svg',
    'assets/svg/icons/linkedin.svg',
  ];

  final ValueNotifier<int> _currentVideo = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

//for launching dialar
  Future<void> _launchDialer(String number) async {
  final Uri launchUrL = Uri(
    scheme: 'tel',
    path: number,
    );
  if (!await launchUrl(launchUrL)) {
    throw Exception('Could not launch $number');
  }
  }


    final reviewsToShow = ref.watch(reviewsProvider);
    PageController _videoCountController = PageController();

    _videoCountController.addListener(() {
      _currentVideo.value = _videoCountController.page!.round();
    });
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(fetchUserDetailsProvider(userId));
        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              flexibleSpace: Container(),
              actions: [
                // if (userId == id)
                //   asyncUser.when(
                //     data: (user) {
                //       return IconButton(
                //         icon: const Icon(
                //           size: 20,
                //           Icons.qr_code,
                //           color: kPrimaryColor,
                //         ),
                //         onPressed: () {
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) => ProfilePage(user: user),
                //             ),
                //           );
                //         },
                //       );
                //     },
                //     error: (error, stackTrace) {
                //       return SizedBox();
                //     },
                //     loading: () {
                //       return IconButton(
                //         icon: const Icon(
                //           size: 20,
                //           Icons.qr_code,
                //           color: kPrimaryColor,
                //         ),
                //         onPressed: () {},
                //       );
                //     },
                //   ),
                if (userId == id)
                  IconButton(
                    icon: const Icon(
                      size: 20,
                      Icons.edit,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      NavigationService navigationService = NavigationService();
                      navigationService.pushNamed('EditUser');
                    },
                  ),
              ],
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 0),
                child: Container(
                    width: double.infinity, height: 1, color: kTertiary),
              ),
              backgroundColor: kWhite,
              title: const Text(
                'Preview',
                style: kBodyTitleL,
              ),
            ),
            backgroundColor: kWhite,
            body: asyncUser.when(
              data: (user) {
                List<Media> videos =
                    user.media?.where((m) => m.metadata == 'video').toList() ??
                        [];
                List<Media> certificates = user.media
                        ?.where((m) => m.metadata == 'certificate')
                        .toList() ??
                    [];
                List<Media> awards =
                    user.media?.where((m) => m.metadata == 'award').toList() ??
                        [];

                // final designations = user.company!
                //     .map((i) => i.designation)
                //     .where((d) => d != null && d.isNotEmpty)
                //     .map((d) => d!)
                //     .toList();

                // final companyNames = user.company!
                //     .map((i) => i.name)
                //     .where((n) => n != null && n.isNotEmpty)
                //     .map((n) => n!)
                //     .toList();
                // String joinedDate =
                //     DateFormat('dd/MM/yyyy').format(user.createdAt!);
                // Map<String, String> levelData =
                //     extractLevelDetails(user.level ?? '');
                // log(levelData.toString());
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Column(children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 110,
                                  ),
                                  GlowingAnimatedAvatar(
                                    imageUrl: user.image,
                                    defaultAvatarAsset:
                                        'assets/svg/icons/dummy_person_large.svg',
                                    size: 110,
                                    glowColor: kRed,
                                    borderColor: kWhite,
                                    borderWidth: 3.0,
                                  ),
                                  Text(
                                    user.fullName ?? '',
                                    style: kHeadTitleSB,
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Column(
                                      children: [
                                        // if (designations.isNotEmpty ||
                                        //     companyNames.isNotEmpty)
                                        //   Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     children: [
                                        //       if (designations.isNotEmpty)
                                        //         Text(
                                        //           designations.join(' | '),
                                        //           textAlign: TextAlign.center,
                                        //           style: const TextStyle(
                                        //             fontSize: 12,
                                        //             color: kBlack,
                                        //           ),
                                        //         ),
                                        //       if (companyNames.isNotEmpty)
                                        //         Text(
                                        //           companyNames.join(' | '),
                                        //           textAlign: TextAlign.center,
                                        //           style: const TextStyle(
                                        //             fontSize: 12,
                                        //             color: kBlack,
                                        //           ),
                                        //         ),
                                        //     ],
                                        //   ),
                                        if (user.occupation != null)
                                          Text('${user.occupation}'),
                                        if (user.occupation != null)
                                          const SizedBox(height: 5),
                                        // Text(
                                        //   'Joined Date: $joinedDate',
                                        //   style: const TextStyle(
                                        //     fontSize: 11,
                                        //     color: kBlack,
                                        //   ),
                                        // ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        if (user.birthDate != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                                color: kWhite,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: const Color.fromARGB(
                                                        255, 234, 226, 226))),
                                            child: IntrinsicWidth(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Image.asset(
                                                        scale: 40,
                                                        'assets/pngs/familytree_logo.png'),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  if (user.birthDate != null)
                                                    Text(
                                                        'BirthDate: ${DateFormat('yyyy-MM-dd').format(user.birthDate!)}',
                                                        style: kSmallerTitleB
                                                            .copyWith(
                                                                color:
                                                                    kPrimaryColor)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              if (user.biography != null &&
                                  user.biography != '' &&
                                  user.biography != 'null')
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: kTertiary,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'About',
                                            style: kBodyTitleB.copyWith(
                                                color: kBlack),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Flexible(
                                                  child: Text(
                                                '''${user.biography}''',
                                                style: kSmallTitleR,
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: kTertiary,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Contact Info',
                                          style: kBodyTitleB.copyWith(
                                              color: kBlack),
                                        ),
                                        const SizedBox(height: 15),
                                        GestureDetector(
                                          onTap: () => _launchDialer(user.phone.toString()),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CustomIconContainer(
                                                  icon: Icons.phone),
                                              const SizedBox(width: 10),
                                              Text(user.phone.toString()),
                                            ],
                                          ),
                                        ),
                                        if (user.address != null &&
                                            user.address != '')
                                          const SizedBox(height: 15),
                                        if (user.email != null &&
                                            user.email != '')
                                          Row(
                                            children: [
                                              CustomIconContainer(
                                                  icon: Icons.email),
                                              const SizedBox(width: 10),
                                              Text(user.email ?? ''),
                                            ],
                                          ),
                                        if (user.address != null &&
                                            user.address != '')
                                          const SizedBox(height: 15),
                                        if (user.address != null &&
                                            user.address != '')
                                          Row(
                                            children: [
                                              CustomIconContainer(
                                                  icon: Icons.location_on),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  user.address!,
                                                ),
                                              )
                                            ],
                                          ),
                                        // if (user.secondaryPhone?.whatsapp !=
                                        //         null &&
                                        //     user.secondaryPhone?.whatsapp != '')
                                        //   const SizedBox(height: 15),
                                        // if (user.secondaryPhone?.whatsapp !=
                                        //         null &&
                                        //     user.secondaryPhone?.whatsapp != '')
                                        //   Row(
                                        //     children: [
                                        //       CustomIconContainer(
                                        //         icon: FontAwesomeIcons
                                        //             .squareWhatsapp,
                                        //       ),
                                        //       const SizedBox(width: 10),
                                        //       Expanded(
                                        //         child: Text(user
                                        //             .secondaryPhone!.whatsapp!),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // const SizedBox(height: 15),
                                        // if (user.secondaryPhone?.business !=
                                        //         null &&
                                        //     user.secondaryPhone!.business!
                                        //         .isNotEmpty)
                                        //   Row(
                                        //     children: [
                                        //       CustomIconContainer(
                                        //         svgPath:
                                        //             'assets/svg/icons/whatsapp-business.svg',
                                        //       ),
                                        //       const SizedBox(width: 10),
                                        //       Expanded(
                                        //         child: Text(user
                                        //             .secondaryPhone!.whatsapp!),
                                        //       ),
                                        //     ],
                                        //   ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              // if (user.id != id)
                              //   Row(
                              //     children: [
                              //       SizedBox(
                              //           width: 100,
                              //           child: customButton(
                              //               label: 'Write a Review',
                              //               onPressed: () {
                              //                 showModalBottomSheet(
                              //                   context: context,
                              //                   isScrollControlled: true,
                              //                   shape: const RoundedRectangleBorder(
                              //                     borderRadius:
                              //                         BorderRadius.vertical(
                              //                             top: Radius.circular(20)),
                              //                   ),
                              //                   builder: (context) =>
                              //                       ShowWriteReviewSheet(
                              //                     userId: user.id!,
                              //                   ),
                              //                 );
                              //               },
                              //               fontSize: 15)),
                              //     ],
                              //   ),

                              // if (user.company?.designation != null ||
                              //     user.company?.email != null ||
                              //     user.company?.websites != null ||
                              //     user.company?.phone != null ||
                              //     user.company?.designation != '' ||
                              //     user.company?.email != '' ||
                              //     user.company?.websites != '' ||
                              //     user.company?.phone != '' ||
                              //     user.company != null)
                              //   const Row(
                              //     children: [
                              //       Padding(
                              //         padding: EdgeInsets.only(left: 10),
                              //         child: Text(
                              //           'Company',
                              //           style: TextStyle(
                              //               fontSize: 17, fontWeight: FontWeight.w600),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Column(
                              //   children: [
                              //     if (user.company?.phone != null)
                              //       Padding(
                              //         padding: const EdgeInsets.only(left: 10),
                              //         child: Row(
                              //           mainAxisAlignment: MainAxisAlignment.start,
                              //           children: [
                              //             const Icon(Icons.phone, color: kPrimaryColor),
                              //             const SizedBox(width: 10),
                              //             Text(user.company?.phone ?? ''),
                              //           ],
                              //         ),
                              //       ),
                              //     // const SizedBox(height: 10),
                              //     // if (user.company?.address != null)
                              //     //   Padding(
                              //     //     padding: const EdgeInsets.only(left: 10),
                              //     //     child: Row(
                              //     //       children: [
                              //     //         const Icon(Icons.location_on,
                              //     //             color: kPrimaryColor),
                              //     //         const SizedBox(width: 10),
                              //     //         if (user.company?.address != null)
                              //     //           Expanded(
                              //     //             child: Text(user.company?.address ?? ''),
                              //     //           )
                              //     //       ],
                              //     //     ),
                              //     //   ),
                              //     const SizedBox(height: 30),
                              //   ],
                              // ),
                              if (user.social?.isNotEmpty == true)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: kTertiary,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Social Media',
                                                  style: kBodyTitleB.copyWith(
                                                      color: kBlack)),
                                            ],
                                          ),
                                          if (user.social?.isNotEmpty == true)
                                            for (int index = 0;
                                                index < user.social!.length;
                                                index++)
                                              customSocialPreview(index,
                                                  social: user.social![index]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(height: 10),
                              if (user.website?.isNotEmpty == true)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: kTertiary,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Websites & Links',
                                                  style: kBodyTitleB.copyWith(
                                                      color: kBlack)),
                                            ],
                                          ),
                                          if (user.website?.isNotEmpty == true)
                                            for (int index = 0;
                                                index < user.website!.length;
                                                index++)
                                              customSocialPreview(index,
                                                  isWebsite: true,
                                                  social: user.website![index]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              const SizedBox(
                                height: 30,
                              ),
                              if (videos.isNotEmpty == true)
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 500,
                                      height: 260,
                                      child: PageView.builder(
                                        controller: _videoCountController,
                                        itemCount: videos.length,
                                        physics: const PageScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return profileVideo(
                                              title:
                                                  videos[index].caption ?? '',
                                              context: context,
                                              url: videos[index].url ?? '');
                                        },
                                      ),
                                    ),
                                    ValueListenableBuilder<int>(
                                      valueListenable: _currentVideo,
                                      builder: (context, value, child) {
                                        return SmoothPageIndicator(
                                          controller: _videoCountController,
                                          count: videos.length,
                                          effect: const ExpandingDotsEffect(
                                            dotHeight: 8,
                                            dotWidth: 6,
                                            activeDotColor: Colors.black,
                                            dotColor: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              if (videos.isNotEmpty == true)
                                const SizedBox(
                                  height: 30,
                                ),

                              SizedBox(
                                height: 20,
                              ),
                              if (certificates.isNotEmpty == true)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 8),
                                      child: Text('Certificates',
                                          style: kBodyTitleB.copyWith(
                                              color: kBlack)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets
                                          .zero, // Remove default ListView padding
                                      itemCount: certificates.length,
                                      itemBuilder: (context, index) {
                                        return CertificateCard(
                                          onEdit: null,
                                          name:
                                              certificates[index].caption ?? '',
                                          url: certificates[index].url ?? '',
                                          onRemove: null,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              if (awards.isNotEmpty == true)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 8, left: 10),
                                      child: Text(
                                        'Awards',
                                        style:
                                            kBodyTitleB.copyWith(color: kBlack),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets
                                          .zero, // Remove default padding
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8.0,
                                        mainAxisSpacing:
                                            16.0, // Reduced slightly from 20.0
                                        childAspectRatio:
                                            0.9, // Optional: adjust for better card proportions
                                      ),
                                      itemCount: awards.length,
                                      itemBuilder: (context, index) {
                                        return AwardCard(
                                          onEdit: null,
                                          award: awards[index],
                                          onRemove: null,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                            ]),
                          ),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    ),
                    if (user.id != id)
                      Positioned(
                          bottom: 40,
                          left: 15,
                          right: 15,
                          child: SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: customButton(
                                        buttonHeight: 60,
                                        fontSize: 16,
                                        label: 'SAY HI',
                                        onPressed: () async {
                                          final userId = user.id ?? '';
                                          try {
                                            final conversations =
                                                await ChatApi()
                                                    .fetchConversations();
                                            final directConversation = conversations
                                                    .where((c) =>
                                                        c.type == 'direct' &&
                                                        c.participants.any(
                                                            (p) =>
                                                                p.userId ==
                                                                userId))
                                                    .isNotEmpty
                                                ? conversations
                                                    .where((c) =>
                                                        c.type == 'direct' &&
                                                        c.participants.any(
                                                            (p) =>
                                                                p.userId ==
                                                                userId))
                                                    .first
                                                : null;
                                            if (directConversation != null) {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      IndividualPage(
                                                    conversationImage:
                                                        user.image ?? '',
                                                    conversationTitle:
                                                        user.fullName ?? '',
                                                    conversation:
                                                        directConversation,
                                                    currentUserId: id,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              final newConversation =
                                                  await ChatApi()
                                                      .fetchDirectConversation(
                                                          userId);
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      IndividualPage(
                                                    conversationImage:
                                                        user.image ?? '',
                                                    conversationTitle:
                                                        user.fullName ?? '',
                                                    conversation:
                                                        newConversation,
                                                    currentUserId: id,
                                                  ),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            // Handle error (show snackbar, etc.)
                                          }
                                        }),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: customButton(
                                        sideColor: const Color.fromARGB(
                                            255, 219, 217, 217),
                                        labelColor: const Color(0xFF2C2829),
                                        buttonColor: const Color.fromARGB(
                                            255, 222, 218, 218),
                                        buttonHeight: 60,
                                        fontSize: 13,
                                        label: 'SAVE CONTACT',
                                        onPressed: () {
                                          if (user.phone != null) {
                                            saveContact(
                                                firstName: user.fullName ?? '',
                                                number: user.phone ?? '',
                                                email: user.email ?? '',
                                                context: context);
                                          }
                                        }),
                                  ),
                                ],
                              ))),
                  ],
                );
              },
              loading: () => ProfileShimmer(),
              error: (error, stackTrace) {
                return Center(
                  child: LoadingAnimation(),
                );
              },
            ));
      },
    );
  }

  Widget profileVideo(
      {required BuildContext context,
      required String url,
      required String title}) {
    final ytController = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(url)!,
      autoPlay: false,
      params: const YoutubePlayerParams(
        enableJavaScript: true,
        loop: true,
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width:
                  MediaQuery.of(context).size.width - 32, // Full-screen width
              height: 200,
              decoration: BoxDecoration(
                color: Colors.transparent, // Transparent background
                borderRadius: BorderRadius.circular(8.0),
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: YoutubePlayer(
                  controller: ytController,
                  aspectRatio: 16 / 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding customSocialPreview(int index,
      {Link? social, bool isWebsite = false}) {
    log('Icons: ${svgIcons[index]}');
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: GestureDetector(
        onTap: () {
          if (social != null) {
            _launchURL(social.link ?? '');
          }
        },
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: kWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(1, 1),
                ),
              ],
              border: Border.all(color: kTertiary),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Align(
                        alignment: Alignment.topCenter,
                        widthFactor: 1.0,
                        child: isWebsite
                            ? Icon(Icons.language, color: kPrimaryColor)
                            : SvgPicture.asset(svgIcons[index],
                                color: kPrimaryColor)),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Text('${social?.name}')),
                  Spacer(),
                  SvgPicture.asset('assets/svg/icons/arrow_up_square.svg'),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            )),
      ),
    );
  }
}

void _launchURL(String url) async {
  // Check if the URL starts with 'http://' or 'https://', if not add 'http://'
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'http://' + url;
  }

  try {
    await launchUrl(Uri.parse(url));
  } catch (e) {
    print(e);
  }
}
