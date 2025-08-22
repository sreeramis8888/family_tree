import 'package:dotted_border/dotted_border.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/edit_user.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/models/user_model.dart';
import 'package:familytree/src/data/notifiers/user_notifier.dart';
import 'package:familytree/src/data/services/image_upload.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:familytree/src/interface/components/Cards/award_card.dart';
import 'package:familytree/src/interface/components/Cards/certificate_card.dart';
import 'package:familytree/src/interface/components/Dialogs/upgrade_dialog.dart';
import 'package:familytree/src/interface/components/ModalSheets/add_award.dart';
import 'package:familytree/src/interface/components/ModalSheets/add_certificate.dart';
import 'package:familytree/src/interface/components/ModalSheets/add_website_video.dart';
import 'package:familytree/src/interface/components/Switch/custom_switch.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_textFormField.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_websiteVideo_card.dart';
import 'package:familytree/src/interface/components/edit_user/contact_editor.dart';
import 'package:familytree/src/interface/components/edit_user/social_media_editor.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/components/permission_check_wrapper.dart';
import 'package:familytree/src/interface/components/shimmers/edit_user_shimmer.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/preimum_plan.dart';
import 'package:familytree/src/data/api_routes/family_api.dart/family_api.dart';
import 'package:familytree/src/interface/components/DropDown/searchableDropdown.dart';
import 'package:familytree/src/interface/components/DropDown/selectionDropdown.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/relationship_api.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class EditUser extends ConsumerStatefulWidget {
  const EditUser({super.key});

  @override
  ConsumerState<EditUser> createState() => _EditUserState();
}

class _EditUserState extends ConsumerState<EditUser> {
  // final isPhoneNumberVisibleProvider = StateProvider<bool>((ref) => false);

  // final isLandlineVisibleProvider = StateProvider<bool>((ref) => false);

  // final isContactDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  // final isSocialDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  // final isWebsiteDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  // final isVideoDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  // final isAwardsDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  // final isProductsDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  // final isCertificateDetailsVisibleProvider =
  //     StateProvider<bool>((ref) => false);
  // final isBrochureDetailsVisibleProvider = StateProvider<bool>((ref) => false);

  List<Map<String, TextEditingController>> companyDetailsControllers = [];
  @override
  void initState() {
    super.initState();
    // Remove the automatic addition of empty controllers
    // _addNewCompanyDetails();
  }

  // bool _isInitialized = false;

  // void _initializeCompanyDetails(List<Company>? companies) {
  //   if (!_isInitialized && companies != null) {
  //     setState(() {
  //       // Clear existing controllers
  //       companyDetailsControllers.clear();

  //       // If companies list is empty, add one empty controller
  //       if (companies.isEmpty) {
  //         _addNewCompanyDetails();
  //       } else {
  //         // Create controllers for each existing company
  //         companyDetailsControllers = companies.map((company) {
  //           return {
  //             'designation':
  //                 TextEditingController(text: company.designation ?? ''),
  //             'name': TextEditingController(text: company.name ?? ''),
  //             'phone': TextEditingController(text: company.phone ?? ''),
  //             'email': TextEditingController(text: company.email ?? ''),
  //             'website': TextEditingController(text: company.websites ?? ''),
  //           };
  //         }).toList();
  //       }
  //       _isInitialized = true;
  //     });
  //   }
  // }

  void _addNewCompanyDetails() {
    setState(() {
      companyDetailsControllers.add({
        'designation': TextEditingController(),
        'name': TextEditingController(),
        'phone': TextEditingController(),
        'email': TextEditingController(),
        'website': TextEditingController(),
      });
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController secondaryPhoneController =
      TextEditingController();
  final TextEditingController landlineController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController profilePictureController =
      TextEditingController();
  final TextEditingController personalPhoneController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();

  final TextEditingController designationController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyWebsiteController =
      TextEditingController();
  final TextEditingController companyAddressController =
      TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController igController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController twtitterController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController websiteNameController = TextEditingController();
  final TextEditingController websiteLinkController = TextEditingController();
  final TextEditingController videoNameController = TextEditingController();
  final TextEditingController videoLinkController = TextEditingController();
  final TextEditingController awardNameController = TextEditingController();
  final TextEditingController awardAuthorityController =
      TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productMoqController = TextEditingController();
  final TextEditingController productActualPriceController =
      TextEditingController();
  final TextEditingController productOfferPriceController =
      TextEditingController();
  final TextEditingController certificateNameController =
      TextEditingController();
  final TextEditingController brochureNameController = TextEditingController();
  File? _profileImageFile;
  File? _companyImageFile;
  File? _awardImageFIle;
  File? _certificateImageFIle;
  File? _brochurePdfFile;
  ImageSource? _profileImageSource;
  ImageSource? _companyImageSource;
  ImageSource? _awardImageSource;
  ImageSource? _certificateSource;
  NavigationService navigationService = NavigationService();
  final _formKey = GlobalKey<FormState>();
  SnackbarService snackbarService = SnackbarService();
  String productUrl = '';

  // Add new controller for tags
  final TextEditingController _tagController = TextEditingController();

  bool _isProfileImageLoading = false;
  Map<int, bool> _companyLogoLoadingStates = {};

  // Relation logic
  String? _linkedMember;
  String? _relationship;
  List<Map<String, String?>> _relations = [];
  final List<String> _relationships = ["spouse", "parent", "child"];
  String? _lastConfirmedMember;
  String? _lastConfirmedRelationship;

  // Add state for other families
  List<String> _otherFamilies = [];
  // Add state for other family (single selection)
  String? _otherFamily;

  // Add new _addRelation that takes memberName
  void _addRelation(String memberName) {
    if (_linkedMember != null && _relationship != null) {
      setState(() {
        _relations.add({
          'memberId': _linkedMember,
          'memberName': memberName,
          'relationship': _relationship,
        });
        _linkedMember = null;
        _relationship = null;
        _lastConfirmedMember = null;
        _lastConfirmedRelationship = null;
      });
    }
  }

  void _showRelationshipConfirmation(String memberName, String relationship) {
    final currentUserName =
        nameController.text.trim().isNotEmpty ? nameController.text : 'you';
    final isYou = currentUserName.toLowerCase() == 'you';
    final verb = isYou ? 'are' : 'is';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Icon(
                Icons.people,
                color: kPrimaryColor,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                'Confirm Relationship',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kBlack,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: kBlack,
                  ),
                  children: [
                    TextSpan(text: '$currentUserName '),
                    TextSpan(text: '$verb '),
                    TextSpan(text: '$relationship of '),
                    TextSpan(
                      text: '$memberName',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Is this relationship correct?',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: kWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Confirm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addRelation(memberName);
              },
            ),
          ],
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        );
      },
    );
  }

  Future<File?> _pickFile(
      {required String imageType, int? companyIndex}) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (imageType == 'profile') {
        setState(() {
          _isProfileImageLoading = true;
          _profileImageFile = File(image.path);
        });
        try {
          String profileUrl = await imageUpload(_profileImageFile!.path);
          _profileImageSource = ImageSource.gallery;
          ref.read(userProvider.notifier).updateProfilePicture(profileUrl);
          print((profileUrl));
          return _profileImageFile;
        } catch (e) {
          print('Error uploading profile image: $e');
          snackbarService.showSnackBar('Failed to upload profile image');
        } finally {
          setState(() {
            _isProfileImageLoading = false;
          });
        }
      }
      // else if (imageType == 'company') {
      //   if (companyIndex != null) {
      //     setState(() {
      //       _companyLogoLoadingStates[companyIndex] = true;
      //       _companyImageFile = File(image.path);
      //     });
      //     try {
      //       String companyUrl = await imageUpload(_companyImageFile!.path);
      //       _companyImageSource = ImageSource.gallery;
      //       final companyList = ref.read(userProvider).value?.company ?? [];

      //       final existingCompany = (companyIndex != null &&
      //               companyIndex >= 0 &&
      //               companyIndex < companyList.length)
      //           ? companyList[companyIndex]
      //           : null;
      //       final updatedCompany = Company(
      //         logo: companyUrl,
      //         name: existingCompany?.name,
      //         designation: existingCompany?.designation,
      //         email: existingCompany?.email,
      //         phone: existingCompany?.phone,
      //         websites: existingCompany?.websites,
      //       );

      //       final insertIndex =
      //           (existingCompany == null) ? companyList.length : companyIndex!;
      //       ref
      //           .read(userProvider.notifier)
      //           .updateCompany(updatedCompany, insertIndex);
      //       return _companyImageFile;
      //     }
      //     catch (e) {
      //       print('Error uploading company logo: $e');
      //       snackbarService.showSnackBar('Failed to upload company logo');
      //     } finally {
      //       setState(() {
      //         _companyLogoLoadingStates[companyIndex] = false;
      //       });
      //     }
      //   } else {
      //     log('Warning: No company index provided for logo update');
      //   }
      // }
      else if (imageType == 'award') {
        _awardImageFIle = File(image.path);
        _awardImageSource = ImageSource.gallery;
        return _awardImageFIle;
      } else if (imageType == 'certificate') {
        _certificateImageFIle = File(image.path);
        _certificateSource = ImageSource.gallery;
        return _certificateImageFIle;
      } else {
        _brochurePdfFile = File(image.path);
        return _brochurePdfFile;
      }
    }
    return null;
  }

  // void _addAwardCard() async {
  // await api.createFileUrl(file: _awardImageFIle!).then((url) {
  //   awardUrl = url;
  //   print((awardUrl));
  // });
  //   ref.read(userProvider.notifier).updateAwards([...?ref.read(userProvider).value?.awards, newAward]);
  // }

  Future<void> _addNewAward() async {
    await imageUpload(_awardImageFIle!.path).then((url) {
      final String awardUrl = url;
      final newAward = Media(
        metadata: 'award',
        caption: awardNameController.text,
        url: awardUrl,
        notes: {"authority": awardAuthorityController.text},
      );

      ref.read(userProvider.notifier).updateAwards([
        ...ref
                .read(userProvider)
                .value
                ?.media
                ?.where((m) => m.metadata == 'award')
                .toList() ??
            [],
        newAward
      ]);
    });

    _awardImageFIle = null;
  }

  // void _removeAward(int index) async {
  //   print('remove award is working');
  //   ref.read(userProvider.notifier).removeAward(ref
  //           .read(userProvider)
  //           .value
  //           ?.media
  //           ?.where((m) => m.metadata == 'award')
  //           .toList() ??
  //       [][index]);
  // }
  void _removeAward(int index) async {
  print('remove award is working');

  final awardsList = ref
      .read(userProvider)
      .value
      ?.media
      ?.where((m) => m.metadata == 'award')
      .toList() ?? [];

  if (index < awardsList.length) {
    ref.read(userProvider.notifier).removeAward(awardsList[index]);
  } else {
    print('Invalid award index: $index');
  }
}



  void _addNewWebsite() async {
    Link newWebsite = Link(
        link: websiteLinkController.text.toString(),
        name: websiteNameController.text.toString());
    ref
        .read(userProvider.notifier)
        .updateWebsite([...?ref.read(userProvider).value?.website, newWebsite]);
    websiteLinkController.clear();
    websiteNameController.clear();
  }

  void _removeWebsite(int index) async {
    ref
        .read(userProvider.notifier)
        .removeWebsite(ref.read(userProvider).value!.website![index]);
  }

  void _addNewVideo() async {
    Media newVideo = Media(
        metadata: 'video',
        url: videoLinkController.text.toString(),
        caption: videoNameController.text.toString());
    log('Hello im in website bug:${ref.read(userProvider).value?.media?.where((m) => m.metadata == 'video').toList() ?? []}');
    ref.read(userProvider.notifier).updateVideos([
      ...ref
              .read(userProvider)
              .value
              ?.media
              ?.where((m) => m.metadata == 'video')
              .toList() ??
          [],
      newVideo
    ]);
    videoLinkController.clear();
    videoNameController.clear();
  }

  // void _removeVideo(int index) async {
  //   print('remove video funtion is working');
  //   ref.read(userProvider.notifier).removeVideo(ref
  //           .read(userProvider)
  //           .value
  //           ?.media
  //           ?.where((m) => m.metadata == 'video')
  //           .toList() ??
  //       [][index]);
  // }

  void _removeVideo(int index) {
  print('remove video function is working');

  // Get only the videos from media
  final videosList = ref
      .read(userProvider)
      .value
      ?.media
      ?.where((m) => m.metadata == 'video')
      .toList();

  // Ensure list exists and index is valid
  if (videosList != null && index < videosList.length) {
    ref.read(userProvider.notifier).removeVideo(videosList[index]);
  } else {
    print('No video found at index $index');
  }
}


  Future<void> _addNewCertificate() async {
    await imageUpload(_certificateImageFIle!.path).then((url) {
      final String certificateUrl = url;
      final newCertificate = Media(
          metadata: 'certificate',
          caption: certificateNameController.text,
          url: certificateUrl);

      ref.read(userProvider.notifier).updateCertificates([
        ...ref
                .read(userProvider)
                .value
                ?.media
                ?.where((m) => m.metadata == 'certificate')
                .toList() ??
            [],
        newCertificate
      ]);
    });

    _certificateImageFIle = null;
  }

  // void _removeCertificate(int index) async {
  //   ref.read(userProvider.notifier).removeCertificate(ref
  //           .read(userProvider)
  //           .value
  //           ?.media
  //           ?.where((m) => m.metadata == 'certificate')
  //           .toList() ??
  //       [][index]);
  // }
  void _removeCertificate(int index) async {
  print('remove certificate is working');

  final certificatesList = ref
      .read(userProvider)
      .value
      ?.media
      ?.where((m) => m.metadata == 'certificate')
      .toList() ?? [];

  if (index < certificatesList.length) {
    ref.read(userProvider.notifier).removeCertificate(certificatesList[index]);
  } else {
    print('Invalid certificate index: $index');
  }
}


  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    nameController.dispose();
    birthDateController.dispose();
    bloodGroupController.dispose();
    emailController.dispose();
    profilePictureController.dispose();
    personalPhoneController.dispose();
    landlineController.dispose();
    companyPhoneController.dispose();
    designationController.dispose();
    companyNameController.dispose();
    companyEmailController.dispose();
    bioController.dispose();
    addressController.dispose();

    super.dispose();
  }

  Future<String> _submitData({required UserModel user}) async {
    final Map<String, dynamic> profileData = {
      'fullName': user.fullName,
      'birthDate': user.birthDate?.toIso8601String(),
      'occupation': user.occupation,
      'biography': user.biography,
      'email': user.email,
      'phone': user.phone,
      'secondaryPhone': user.secondaryPhone,
      // 'address': user.address,
      'address': addressController.text.trim(), //takes from controller
      'image': user.image,
      'location': user.location,
      'social': user.social?.map((e) => e.toJson()).toList(),
      'website': user.website?.map((e) => e.toJson()).toList(),
      'media': user.media?.map((e) => e.toJson()).toList(),
      'otherFamilyId': _otherFamily,
    };

    log("Submitting profile data: ${profileData.toString()}");
    String response = await editUser(profileData, id);
    log(profileData.toString());
    return response;
  }

  // Future<void> _selectImageFile(ImageSource source, String imageType) async {
  //   final XFile? image = await _picker.pickImage(source: source);
  //   print('$image');
  //   if (image != null && imageType == 'profile') {
  //     setState(() {
  //       _profileImageFile = _pickFile()
  //     });
  //   } else if (image != null && imageType == 'company') {
  //     setState(() {
  //       _companyImageFile = File(image.path);
  //     });
  //   }
  // }

  void _showPermissionDeniedDialog(bool isPermanentlyDenied) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: Text(isPermanentlyDenied
              ? 'Permission is permanently denied. Please enable it from the app settings.'
              : 'Permission is denied. Please grant the permission to proceed.'),
          actions: [
            TextButton(
              onPressed: () {
                navigationService.pop();
                if (isPermanentlyDenied) {
                  openAppSettings();
                }
              },
              child: Text(isPermanentlyDenied ? 'Open Settings' : 'OK'),
            ),
          ],
        );
      },
    );
  }

  void _openModalSheet({required String sheet}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        if (sheet == 'award') {
          return ShowEnterAwardSheet(
            pickImage: _pickFile,
            addAwardCard: _addNewAward,
            imageType: sheet,
            textController1: awardNameController,
            textController2: awardAuthorityController,
          );
        } else {
          return ShowAddCertificateSheet(
              addCertificateCard: _addNewCertificate,
              textController: certificateNameController,
              imageType: sheet,
              pickImage: _pickFile);
        }
      },
    );
  }

  void navigateBasedOnPreviousPage() {
    final previousPage = ModalRoute.of(context)?.settings.name;
    log('previousPage: $previousPage');
    if (previousPage == 'ProfileCompletion') {
      navigationService.pushNamedReplacement('MainPage');
    } else {
      navigationService.pop();
      ref.read(userProvider.notifier).refreshUser();
    }
  }

  void _removeCompanyDetails(int index) {
    setState(() {
      if (companyDetailsControllers.length > 1) {
        // Ensure at least one company remains
        companyDetailsControllers.removeAt(index);
      }
    });
  }

  // void _addBusinessTag() {
  //   final tag = _tagController.text.trim();
  //   if (tag.isNotEmpty) {
  //     final currentTags = [...?ref.read(userProvider).value?.businessTags];
  //     // Check if tag already exists (case-insensitive comparison)
  //     if (!currentTags.any(
  //         (existingTag) => existingTag.toLowerCase() == tag.toLowerCase())) {
  //       ref
  //           .read(userProvider.notifier)
  //           .updateBusinessTags([...currentTags, tag]);
  //       _tagController.clear();
  //       setState(() {
  //         businessTagSearch = null; // Clear search when tag is added
  //       });
  //     } else {
  //       // Show snackbar or some indication that tag already exists
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Tag "$tag" already exists'),
  //           duration: const Duration(seconds: 2),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //       _tagController.clear();
  //     }
  //   }
  // }

  // void _removeBusinessTag(String tag) {
  //   final currentTags = [...?ref.read(userProvider).value?.businessTags];
  //   currentTags.remove(tag);
  //   ref.read(userProvider.notifier).updateBusinessTags(currentTags);
  // }

  String? businessTagSearch;
  @override
  Widget build(BuildContext context) {
    final asyncUser = ref.watch(userProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: kWhite,
          body: asyncUser.when(
            loading: () {
              return const EditUserShimmer();
            },
            error: (error, stackTrace) {
              return Center(
                child: Text('Error loading User: $error '),
              );
            },
            data: (user) {
              // _initializeCompanyDetails(user.company);
              // log(user.company.toString());
              if (nameController.text.isEmpty) {
                nameController.text = user.fullName ?? '';
              }
              if (user.birthDate != null && birthDateController.text.isEmpty) {
                birthDateController.text =
                    '${user.birthDate!.day.toString().padLeft(2, '0')}-${user.birthDate!.month.toString().padLeft(2, '0')}-${user.birthDate!.year}';
              }
              if (user.secondaryPhone != null &&
                  secondaryPhoneController.text.isEmpty) {
                secondaryPhoneController.text = user.secondaryPhone ?? '';
              }
              if (bioController.text.isEmpty) {
                bioController.text = user.biography ?? '';
              }

              if (personalPhoneController.text.isEmpty) {
                personalPhoneController.text = user.phone ?? '';
              }
              if (emailController.text.isEmpty) {
                emailController.text = user.email ?? '';
              }
              if (addressController.text.isEmpty) {
                addressController.text = user.address ?? '';
              }
              for (Link social in user.social ?? []) {
                if (social.name == 'instagram' && igController.text.isEmpty) {
                  igController.text = social.link ?? '';
                } else if (social.name == 'linkedin' &&
                    linkedinController.text.isEmpty) {
                  linkedinController.text = social.link ?? '';
                } else if (social.name == 'twitter' &&
                    twtitterController.text.isEmpty) {
                  twtitterController.text = social.link ?? '';
                } else if (social.name == 'facebook' &&
                    facebookController.text.isEmpty) {
                  facebookController.text = social.link ?? '';
                }
              }
              final videos =
                  user.media?.where((m) => m.metadata == 'video').toList() ??
                      [];
              final awards =
                  user.media?.where((m) => m.metadata == 'award').toList() ??
                      [];
              final certificates = user.media
                      ?.where((m) => m.metadata == 'certificate')
                      .toList() ??
                  [];
              Widget relationSection = SizedBox.shrink();
              // Use selected family for member selection
              String? selectedFamilyId = _otherFamily ??
                  (user.familyId != null && user.familyId!.isNotEmpty
                      ? user.familyId!.first
                      : null);
              if (selectedFamilyId != null) {
                relationSection = Consumer(
                  builder: (context, ref, child) {
                    final asyncFamily = ref.watch(
                        fetchSingleFamilyProvider(familyId: selectedFamilyId));
                    return asyncFamily.when(
                      data: (family) {
                        final hasMembers = family.members != null &&
                            family.members!.isNotEmpty &&
                            family.members!.length > 1;
                        if (!hasMembers) {
                          return SizedBox.shrink();
                        } else {
                          // Track previous selection to avoid repeated dialogs
                          String? lastMember;
                          String? lastRelation;
                          return StatefulBuilder(
                            builder: (context, setStateSB) {
                              if (_linkedMember != null &&
                                  _relationship != null &&
                                  (_linkedMember != lastMember ||
                                      _relationship != lastRelation)) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  final selectedMember = family.members!
                                      .firstWhere((m) => m.id == _linkedMember);
                                  final memberName =
                                      selectedMember.fullName ?? '';
                                  final relationship = _relationship!;
                                  _showRelationshipConfirmation(
                                      memberName, relationship);
                                  setStateSB(() {
                                    lastMember = _linkedMember;
                                    lastRelation = _relationship;
                                    _lastConfirmedMember = _linkedMember;
                                    _lastConfirmedRelationship = _relationship;
                                  });
                                });
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 24),
                                  Text('Link to Family Member 1 *',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 16),
                                  SearchableDropDown(
                                    label: null,
                                    hintText: 'Select existing family member',
                                    value: _linkedMember,
                                    items: family.members!
                                        .where((m) =>
                                            m.id != user.id &&
                                            !_relations.any((rel) =>
                                                rel['memberId'] == m.id))
                                        .map((m) => DropdownMenuItem(
                                            value: m.id,
                                            child: Text(m.fullName ?? '')))
                                        .toList(),
                                    onChanged: (val) =>
                                        setStateSB(() => _linkedMember = val),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                      _linkedMember != null
                                          ? 'Who are you to ' +
                                              (family.members!
                                                      .firstWhere((m) =>
                                                          m.id == _linkedMember)
                                                      .fullName ??
                                                  '')
                                          : 'Relationship *',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 16),
                                  SelectionDropDown(
                                    label: null,
                                    hintText: 'Select Relationship',
                                    value: _relationship,
                                    items: _relationships
                                        .map((r) => DropdownMenuItem(
                                            value: r,
                                            child: Text(r.toUpperCase())))
                                        .toList(),
                                    onChanged: (val) =>
                                        setStateSB(() => _relationship = val),
                                  ),
                                  SizedBox(height: 8),
                                  ..._relations
                                      .asMap()
                                      .entries
                                      .map((entry) => ListTile(
                                            title: Text(
                                                'Member: ${entry.value['memberName']}'),
                                            subtitle: Text(
                                                'Relationship: ${entry.value['relationship']}'),
                                            trailing: IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                setStateSB(() {
                                                  _relations
                                                      .removeAt(entry.key);
                                                });
                                              },
                                            ),
                                          )),
                                ],
                              );
                            },
                          );
                        }
                      },
                      loading: () => const Center(child: LoadingAnimation()),
                      error: (error, stackTrace) {
                        log(error.toString());
                        return const Center(child: SizedBox.shrink());
                      },
                    );
                  },
                );
              }
              Widget relationshipsSection = SizedBox.shrink();
              if (user.id != null) {
                relationshipsSection = Consumer(
                  builder: (context, ref, child) {
                    final asyncRelationships =
                        ref.watch(fetchRelationshipsProvider(user.id!));
                    return asyncRelationships.when(
                      data: (relationships) {
                        if (relationships.isEmpty) {
                          return SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text('Existing Relationships',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            ...relationships.map((rel) {
                              final isPerson1 =
                                  rel['person1']['_id'] == user.id;
                              final otherPerson =
                                  isPerson1 ? rel['person2'] : rel['person1'];
                              final type = rel['type'] ?? '';
                              final imageUrl = otherPerson['image'] as String?;
                              final relationshipId = rel['_id'] as String?;
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  bool isDeleting = false;
                                  return ListTile(
                                    leading: imageUrl != null
                                        ? CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(imageUrl))
                                        : CircleAvatar(
                                            child: Icon(Icons.person)),
                                    title: Text(otherPerson['fullName'] ?? ''),
                                    subtitle: Text('Relationship: $type'),
                                    trailing: relationshipId != null
                                        ? isDeleting
                                            ? SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2))
                                            : IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () async {
                                                  setState(
                                                      () => isDeleting = true);
                                                  await RelationshipApi
                                                      .deleteRelationship(
                                                          relationshipId:
                                                              relationshipId);
                                                  setState(
                                                      () => isDeleting = false);
                                                  ref.invalidate(
                                                      fetchRelationshipsProvider(
                                                          user.id!));
                                                },
                                              )
                                        : null,
                                  );
                                },
                              );
                            }).toList(),
                          ],
                        );
                      },
                      loading: () => const Center(child: LoadingAnimation()),
                      error: (error, stackTrace) {
                        log(error.toString());
                        return const Center(child: SizedBox.shrink());
                      },
                    );
                  },
                );
              }
              // Insert Other Families selection here
              Widget otherFamilySection = Consumer(
                builder: (context, ref, child) {
                  final asyncFamilies = ref.watch(fetchAllFamilyProvider);
                  return asyncFamilies.when(
                    data: (families) {
                      // Exclude user's main family (assume user.familyId is List<String>)
                      final mainFamilyIds = user.familyId ?? [];
                      final filteredFamilies = families
                          .where((f) => !mainFamilyIds.contains(f.id))
                          .toList();
                      if (filteredFamilies.isEmpty) return SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 10),
                            child: Text('Other Family (if any)',
                                style: kBodyTitleB),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SearchableDropDown(
                              label: null,
                              hintText: 'Select other family',
                              value: _otherFamily,
                              items: filteredFamilies
                                  .map((f) => DropdownMenuItem<String>(
                                        value: f.id ?? '',
                                        child: Text(f.name ?? ''),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _otherFamily = val;
                                });
                              },
                              validator: (val) => null, // optional
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(child: LoadingAnimation()),
                    error: (error, stackTrace) {
                      log(error.toString());
                      return const Center(child: SizedBox.shrink());
                    },
                  );
                },
              );
              return PopScope(
                onPopInvoked: (didPop) {
                  if (didPop) {
                    ref.read(userProvider.notifier).refreshUser();
                  }
                },
                child: SafeArea(
                  child: Stack(
                    children: [
                      KeyboardAvoider(
                        autoScroll: true,
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  child: AppBar(
                                    scrolledUnderElevation: 0,
                                    backgroundColor: kWhite,
                                    elevation: 0,
                                    leadingWidth: 50,
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Image.asset(
                                            'assets/pngs/familytree_logo.png'),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            ref
                                                .read(userProvider.notifier)
                                                .refreshUser();
                                            navigateBasedOnPreviousPage();
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: kPrimaryColor,
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 35),
                                FormField<File>(
                                  builder: (FormFieldState<File> state) {
                                    return Center(
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              DottedBorder(
                                                borderType: BorderType.Circle,
                                                dashPattern: [6, 3],
                                                color: Colors.grey,
                                                strokeWidth: 2,
                                                child: ClipOval(
                                                  child: Container(
                                                    width: 120,
                                                    height: 120,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    child:
                                                        _isProfileImageLoading
                                                            ? const Center(
                                                                child:
                                                                    LoadingAnimation())
                                                            : Image.network(
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return SvgPicture
                                                                      .asset(
                                                                          'assets/svg/icons/dummy_person_large.svg');
                                                                },
                                                                user.image ??
                                                                    '',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 4,
                                                right: 4,
                                                child: InkWell(
                                                  onTap: () {
                                                    _pickFile(
                                                        imageType: 'profile');
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          offset: const Offset(
                                                              2, 2),
                                                          blurRadius: 4,
                                                        ),
                                                      ],
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const CircleAvatar(
                                                      radius: 17,
                                                      backgroundColor: kWhite,
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: kPrimaryColor,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (state.hasError)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15),
                                              child: Text(
                                                state.errorText ?? '',
                                                style: const TextStyle(
                                                    color: kPrimaryColor),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 60, left: 16, bottom: 10),
                                      child: Text('Personal Details',
                                          style: kSubHeadingB.copyWith(
                                              color: const Color(0xFF2C2829))),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Column(
                                    children: [
                                      CustomTextFormField(
                                        title: 'Full Name',
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Your Name';
                                          }

                                          // Regex to allow only basic English letters and spaces (no emojis or fancy unicode)
                                          final regex =
                                              RegExp(r'^[a-zA-Z0-9\s.,-]*$');

                                          if (!regex.hasMatch(value)) {
                                            return 'Only standard letters, numbers, and basic punctuation allowed';
                                          }

                                          return null;
                                        },
                                        textController: nameController,
                                        labelText: 'Enter your Name',
                                      ),
                                      const SizedBox(height: 20.0),
                                      GestureDetector(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();
                                          DateTime initialDate =
                                              user.birthDate ??
                                                  DateTime(2000, 1, 1);
                                          DateTime? picked =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: initialDate,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                          );
                                          if (picked != null) {
                                            birthDateController.text =
                                                '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
                                            ref
                                                .read(userProvider.notifier)
                                                .updateBirthDate(picked);
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: CustomTextFormField(
                                            title: 'Date of Birth',
                                            textController: birthDateController,
                                            labelText: 'Select your Birthdate',
                                            readOnly: true,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please select your birthdate';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      CustomTextFormField(
                                          title: 'Description',
                                          // validator: (value) {
                                          //   if (value == null || value.isEmpty) {
                                          //     return 'Please Enter Your Bio';
                                          //   }
                                          //   return null;
                                          // },
                                          textController: bioController,
                                          labelText: 'Bio',
                                          maxLines: 5),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    left: 20,
                                  ),
                                  child: Row(
                                    children: [
                                      Text('Contact',
                                          style: kSubHeadingB.copyWith(
                                              color: const Color(0xFF2C2829))),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: CustomTextFormField(
                                    title: 'Secondary Phone',
                                    textController: secondaryPhoneController,
                                    labelText: 'Enter your Secondary Phone',
                                    textInputType: TextInputType.phone,
                                    onChanged: () {
                                      ref
                                          .read(userProvider.notifier)
                                          .updateSecondaryPhone(
                                              secondaryPhoneController.text);
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // ContactEditor(
                                    //   value: user.secondaryPhone?.whatsapp ?? '',
                                    //   icon: FontAwesomeIcons.whatsapp,
                                    //   onSave: (whatsapp) {
                                    //     ref
                                    //         .read(userProvider.notifier)
                                    //         .updateSecondaryPhone(
                                    //           whatsapp: whatsapp,
                                    //         );
                                    //   },
                                    //   label: 'Whatsapp',
                                    // ),
                                    // ContactEditor(
                                    //     value: user.email ?? '',
                                    //     icon: FontAwesomeIcons.at,
                                    //     onSave: (email) {
                                    //       ref
                                    //           .read(userProvider.notifier)
                                    //           .updateEmail(email);
                                    //     },
                                    //     label: 'Email'),
                                    // ContactEditor(
                                    //   value: user.secondaryPhone?.business ?? '',
                                    //   icon: FontAwesomeIcons.b,
                                    //   onSave: (business) {
                                    //     ref
                                    //         .read(userProvider.notifier)
                                    //         .updateSecondaryPhone(
                                    //           business: business,
                                    //         );
                                    //   },
                                    //   label: 'Whatsapp Business',
                                    // ),
                                    // ContactEditor(
                                    //     value: user.address ?? '',
                                    //     icon: FontAwesomeIcons.locationDot,
                                    //     onSave: (address) {
                                    //       ref
                                    //           .read(userProvider.notifier)
                                    //           .updateAddress(address);
                                    //     },
                                    //     label: 'Address'),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: CustomTextFormField(
                                    title: 'Address',
                                    textController: addressController,
                                    labelText: 'Enter your Address',
                                    onChanged: () {
                                      ref
                                          .read(userProvider.notifier)
                                          .updateAddress(
                                              addressController.text);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 20, bottom: 15),
                                  child: Row(
                                    children: [
                                      Text('Social Media',
                                          style: kSubHeadingB.copyWith(
                                              color: const Color(0xFF2C2829))),
                                    ],
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SocialMediaEditor(
                                      icon: FontAwesomeIcons.instagram,
                                      socialMedias: user.social ?? [],
                                      platform: 'instagram',
                                      onSave: (socialMedias, platform, newUrl) {
                                        ref
                                            .read(userProvider.notifier)
                                            .updateSocialMedia(
                                                socialMedias, platform, newUrl);
                                      },
                                    ),
                                    SocialMediaEditor(
                                      icon: FontAwesomeIcons.linkedinIn,
                                      socialMedias: user.social ?? [],
                                      platform: 'linkedin',
                                      onSave: (socialMedias, platform, newUrl) {
                                        ref
                                            .read(userProvider.notifier)
                                            .updateSocialMedia(
                                                socialMedias, platform, newUrl);
                                      },
                                    ),
                                    SocialMediaEditor(
                                      icon: FontAwesomeIcons.xTwitter,
                                      socialMedias: user.social ?? [],
                                      platform: 'twitter',
                                      onSave: (socialMedias, platform, newUrl) {
                                        ref
                                            .read(userProvider.notifier)
                                            .updateSocialMedia(
                                                socialMedias, platform, newUrl);
                                      },
                                    ),
                                    SocialMediaEditor(
                                      icon: FontAwesomeIcons.facebookF,
                                      socialMedias: user.social ?? [],
                                      platform: 'facebook',
                                      onSave: (socialMedias, platform, newUrl) {
                                        ref
                                            .read(userProvider.notifier)
                                            .updateSocialMedia(
                                                socialMedias, platform, newUrl);
                                      },
                                    ),
                                    // SocialMediaEditor(
                                    //   icon: FontAwesomeIcons.instagram,
                                    //   socialMedias: user.social ?? [],
                                    //   platform: 'Instagram',
                                    //   onSave: (socialMedias, platform, newUrl) {
                                    //     ref
                                    //         .read(userProvider.notifier)
                                    //         .updateSocialMedia(
                                    //             socialMedias, platform, newUrl);
                                    //   },
                                    // ),
                                  ],
                                ),
                                // Insert Other Family section here
                                otherFamilySection,
                                // Show relationships section here
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: relationshipsSection,
                                ),
                                // Place relation section here
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: relationSection,
                                ),

                                // Padding(
                                //   padding:
                                //       const EdgeInsets.only(left: 20, right: 20),
                                //   child: Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       const Text(
                                //         'Social Media',
                                //         style: TextStyle(
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.w600),
                                //       ),
                                //       // CustomSwitch(
                                //       //   value:
                                //       //       ref.watch(isSocialDetailsVisibleProvider),
                                //       //   onChanged: (bool value) {
                                //       //     setState(() {
                                //       //       ref
                                //       //           .read(isSocialDetailsVisibleProvider
                                //       //               .notifier)
                                //       //           .state = value;
                                //       //     });
                                //       //   },
                                //       // ),
                                //     ],
                                //   ),
                                // ),
                                // // if (isSocialDetailsVisible)
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 20, right: 20, top: 20, bottom: 10),
                                //   child: CustomTextFormField(
                                //     textController: igController,
                                //     labelText: 'Enter Instagram',
                                //     prefixIcon: SvgPicture.asset(
                                //         'assets/svg/icons/instagram.svg',
                                //         color: kPrimaryColor),
                                //   ),
                                // ),
                                // // if (isSocialDetailsVisible)
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 20, right: 20, top: 20, bottom: 10),
                                //   child: CustomTextFormField(
                                //     textController: linkedinController,
                                //     labelText: 'Enter Linkedin',
                                //     prefixIcon: SvgPicture.asset(
                                //         'assets/svg/icons/linkedin.svg',
                                //         color: kPrimaryColor),
                                //   ),
                                // ),
                                // // if (isSocialDetailsVisible)
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 20, right: 20, top: 20, bottom: 10),
                                //   child: CustomTextFormField(
                                //     textController: twtitterController,
                                //     labelText: 'Enter Twitter',
                                //     prefixIcon: SvgPicture.asset(
                                //         'assets/svg/icons/twitter.svg',
                                //         color: kPrimaryColor),
                                //   ),
                                // ),
                                // // if (isSocialDetailsVisible)
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 20, right: 20, top: 20, bottom: 10),
                                //   child: CustomTextFormField(
                                //     textController: facebookController,
                                //     labelText: 'Enter Facebook',
                                //     prefixIcon: const Icon(
                                //       Icons.facebook,
                                //       color: kPrimaryColor,
                                //       size: 28,
                                //     ),
                                //   ),
                                // ),
                                // // if (isSocialDetailsVisible)
                                // //   const Padding(
                                // //     padding: EdgeInsets.only(right: 20, bottom: 50),
                                // //     child: Row(
                                // //       mainAxisAlignment: MainAxisAlignment.end,
                                // //       children: [
                                // //         Text(
                                // //           'Add more',
                                // //           style: TextStyle(
                                // //               color: kPrimaryColor
                                // //               fontWeight: FontWeight.w600,
                                // //               fontSize: 15),
                                // //         ),
                                // //         Icon(
                                // //           Icons.add,
                                // //           color: kPrimaryColor
                                // //           size: 18,
                                // //         )
                                // //       ],
                                // //     ),
                                // //   ),
                                // ),

                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Website',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      // CustomSwitch(
                                      //   value: ref
                                      //       .watch(isWebsiteDetailsVisibleProvider),
                                      //   onChanged: (bool value) {
                                      //     setState(() {
                                      //       ref
                                      //           .read(isWebsiteDetailsVisibleProvider
                                      //               .notifier)
                                      //           .state = value;
                                      //     });
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap:
                                      true, // Let ListView take up only as much space as it needs
                                  physics:
                                      const NeverScrollableScrollPhysics(), // Disable ListView's internal scrolling
                                  itemCount: user.website?.length,
                                  itemBuilder: (context, index) {
                                    log('Websites count: ${user.website?.length}');
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0), // Space between items
                                      child: customWebsiteCard(
                                          onEdit: () => _editWebsite(index),
                                          onRemove: () => _removeWebsite(index),
                                          website: user.website?[index]),
                                    );
                                  },
                                ),
                                // if (isWebsiteDetailsVisible)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 30),
                                  child: customButton(
                                      label: 'Add',
                                      onPressed: () {
                                        showWebsiteSheet(
                                            addWebsite: _addNewWebsite,
                                            textController1:
                                                websiteNameController,
                                            textController2:
                                                websiteLinkController,
                                            fieldName: 'Add Website',
                                            title: 'Add Website Link',
                                            context: context);
                                      },
                                      sideColor: kPrimaryColor,
                                      labelColor: kPrimaryColor,
                                      buttonColor: Colors.transparent),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Add Video Link',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      // CustomSwitch(
                                      //   value:
                                      //       ref.watch(isVideoDetailsVisibleProvider),
                                      //   onChanged: (bool value) {
                                      //     setState(() {
                                      //       ref
                                      //           .read(isVideoDetailsVisibleProvider
                                      //               .notifier)
                                      //           .state = value;
                                      //     });
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),

                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: videos.length,
                                  itemBuilder: (context, index) {
                                    log('video count: ${videos.length}');
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0), // Space between items
                                      child: customVideoCard(
                                          onEdit: () => _editVideo(index),
                                          onRemove: () => _removeVideo(index),
                                          video: videos[index]),
                                    );
                                  },
                                ),
                                // if (isVideoDetailsVisible)
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 20, right: 20, bottom: 70),
                                //   child: Row(
                                //     children: [
                                //       Expanded(
                                //         // Ensures the CustomTextFormField takes the available space
                                //         child: CustomTextFormField(
                                //           // onTap: () {
                                //           //   // showVideoLinkSheet(
                                //           //   //     addVideo: _addNewVideo,
                                //           //   //     textController1: videoNameController,
                                //           //   //     textController2: videoLinkController,
                                //           //   //     fieldName: 'Add Youtube Link',
                                //           //   //     title: 'Add Video Link',
                                //           //   //     context: context);
                                //           // },
                                //           textController: videoLinkController,
                                //           readOnly: true,
                                //           labelText: 'Enter Video Link',
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 30),
                                  child: customButton(
                                      label: 'Add',
                                      onPressed: () {
                                        showVideoLinkSheet(
                                            addVideo: _addNewVideo,
                                            textController1:
                                                videoNameController,
                                            textController2:
                                                videoLinkController,
                                            fieldName: 'Add Youtube Link',
                                            title: 'Add Video Link',
                                            context: context);
                                      },
                                      sideColor: kPrimaryColor,
                                      labelColor: kPrimaryColor,
                                      buttonColor: Colors.transparent),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Enter Awards',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      // CustomSwitch(
                                      //   value:
                                      //       ref.watch(isAwardsDetailsVisibleProvider),
                                      //   onChanged: (bool value) {
                                      //     ref
                                      //         .read(isAwardsDetailsVisibleProvider
                                      //             .notifier)
                                      //         .state = value;

                                      //     // if (value == false) {
                                      //     //   setState(
                                      //     //     () {
                                      //     //       awards = [];
                                      //     //     },
                                      //     //   );
                                      //     // }
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                                // if (isAwardsDetailsVisible)
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GridView.builder(
                                    shrinkWrap:
                                        true, // Let GridView take up only as much space as it needs
                                    physics:
                                        const NeverScrollableScrollPhysics(), // Disable GridView's internal scrolling
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Number of columns
                                      crossAxisSpacing:
                                          8.0, // Space between columns
                                      mainAxisSpacing:
                                          8.0, // Space between rows
                                    ),
                                    itemCount: awards.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index < awards.length) {
                                        // Regular award cards
                                        return AwardCard(
                                          onEdit: () => _onAwardEdit(index),
                                          award: awards[index],
                                          onRemove: () => _removeAward(index),
                                        );
                                      } else {
                                        return PermissionWrappers.forAddReward(
                                          onTap: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            _openModalSheet(sheet: 'award');
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 10.0),
                                            decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: kGreyLight),
                                              color: kWhite,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.plus,
                                                  color: kPrimaryColor,
                                                  size: 40,
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Add award',
                                                  style: kBodyTitleM.copyWith(
                                                      color: kPrimaryColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Enter Certificates',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      // CustomSwitch(
                                      //   value: ref.watch(
                                      //       isCertificateDetailsVisibleProvider),
                                      //   onChanged: (bool value) {
                                      //     setState(() {
                                      //       ref
                                      //           .read(
                                      //               isCertificateDetailsVisibleProvider
                                      //                   .notifier)
                                      //           .state = value;
                                      //     });
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                                if (certificates.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap:
                                        true, // Let ListView take up only as much space as it needs
                                    physics:
                                        const NeverScrollableScrollPhysics(), // Disable ListView's internal scrolling
                                    itemCount: certificates.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical:
                                                4.0), // Space between items
                                        child: CertificateCard(
                                          name:
                                              certificates[index].caption ?? '',
                                          url: certificates[index].url ?? '',
                                          onEdit: () => _editCertificate(index),
                                          onRemove: () =>
                                              _removeCertificate(index),
                                        ),
                                      );
                                    },
                                  ),
                                // if (isCertificateDetailsVisible)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, bottom: 60),
                                  child: PermissionWrappers.forAddCertificate(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      _openModalSheet(
                                        sheet: 'certificate',
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 25, bottom: 60),
                                      child: Container(
                                        width: 170,
                                        height: 170,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: kGreyLight),
                                            color: kWhite,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              const Icon(
                                                FontAwesomeIcons.plus,
                                                color: kPrimaryColor,
                                                size: 60,
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Text('Add certificate',
                                                  style: kBodyTitleM.copyWith(
                                                      color: kPrimaryColor)),
                                              // if (subscriptionType != 'premium')
                                              //   Stack(
                                              //     alignment: Alignment.center,
                                              //     children: [
                                              //       Container(
                                              //         color:
                                              //             const Color(0xFFF2F2F2),
                                              //         child: Column(
                                              //           children: [
                                              //             const SizedBox(
                                              //               height: 30,
                                              //             ),
                                              //             Padding(
                                              //               padding:
                                              //                   const EdgeInsets
                                              //                       .only(
                                              //                       left: 20,
                                              //                       right: 20),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .spaceBetween,
                                              //                 children: [
                                              //                   const Text(
                                              //                     'Social Media',
                                              //                     style: TextStyle(
                                              //                         color: Colors
                                              //                             .grey,
                                              //                         fontSize:
                                              //                             16,
                                              //                         fontWeight:
                                              //                             FontWeight
                                              //                                 .w600),
                                              //                   ),
                                              //                   CustomSwitch(
                                              //                     value: false,
                                              //                     onChanged: (bool
                                              //                         value) async {},
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //             Padding(
                                              //               padding:
                                              //                   const EdgeInsets
                                              //                       .only(
                                              //                       left: 20,
                                              //                       right: 20,
                                              //                       top: 20),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .spaceBetween,
                                              //                 children: [
                                              //                   const Text(
                                              //                     'Add Website',
                                              //                     style: TextStyle(
                                              //                         color: Colors
                                              //                             .grey,
                                              //                         fontSize:
                                              //                             16,
                                              //                         fontWeight:
                                              //                             FontWeight
                                              //                                 .w600),
                                              //                   ),
                                              //                   CustomSwitch(
                                              //                     value: false,
                                              //                     onChanged: (bool
                                              //                         value) async {},
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //             Padding(
                                              //               padding:
                                              //                   const EdgeInsets
                                              //                       .only(
                                              //                       left: 20,
                                              //                       right: 20,
                                              //                       top: 20),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .spaceBetween,
                                              //                 children: [
                                              //                   const Text(
                                              //                     'Add Video Link',
                                              //                     style: TextStyle(
                                              //                         color: Colors
                                              //                             .grey,
                                              //                         fontSize:
                                              //                             16,
                                              //                         fontWeight:
                                              //                             FontWeight
                                              //                                 .w600),
                                              //                   ),
                                              //                   CustomSwitch(
                                              //                     value: false,
                                              //                     onChanged: (bool
                                              //                         value) async {},
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //             Padding(
                                              //               padding:
                                              //                   const EdgeInsets
                                              //                       .only(
                                              //                       left: 20,
                                              //                       right: 20,
                                              //                       top: 20),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .spaceBetween,
                                              //                 children: [
                                              //                   const Text(
                                              //                     'Enter Awards',
                                              //                     style: TextStyle(
                                              //                         color: Colors
                                              //                             .grey,
                                              //                         fontSize:
                                              //                             16,
                                              //                         fontWeight:
                                              //                             FontWeight
                                              //                                 .w600),
                                              //                   ),
                                              //                   CustomSwitch(
                                              //                     value: false,
                                              //                     onChanged: (bool
                                              //                         value) async {},
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //             Padding(
                                              //               padding:
                                              //                   const EdgeInsets
                                              //                       .only(
                                              //                       left: 20,
                                              //                       right: 20,
                                              //                       top: 20),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .spaceBetween,
                                              //                 children: [
                                              //                   const Text(
                                              //                     'Enter Products',
                                              //                     style: TextStyle(
                                              //                         color: Colors
                                              //                             .grey,
                                              //                         fontSize:
                                              //                             16,
                                              //                         fontWeight:
                                              //                             FontWeight
                                              //                                 .w600),
                                              //                   ),
                                              //                   CustomSwitch(
                                              //                     value: false,
                                              //                     onChanged: (bool
                                              //                         value) async {},
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //             Padding(
                                              //               padding:
                                              //                   const EdgeInsets
                                              //                       .only(
                                              //                       left: 20,
                                              //                       right: 20,
                                              //                       top: 20),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .spaceBetween,
                                              //                 children: [
                                              //                   const Text(
                                              //                     'Enter Certicates',
                                              //                     style: TextStyle(
                                              //                         color: Colors
                                              //                             .grey,
                                              //                         fontSize:
                                              //                             16,
                                              //                         fontWeight:
                                              //                             FontWeight
                                              //                                 .w600),
                                              //                   ),
                                              //                   CustomSwitch(
                                              //                     value: false,
                                              //                     onChanged: (bool
                                              //                         value) async {},
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //             Padding(
                                              //               padding:
                                              //                   const EdgeInsets
                                              //                       .only(
                                              //                       left: 20,
                                              //                       right: 20,
                                              //                       top: 20),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .spaceBetween,
                                              //                 children: [
                                              //                   const Text(
                                              //                     'Enter Borchure',
                                              //                     style: TextStyle(
                                              //                         color: Colors
                                              //                             .grey,
                                              //                         fontSize:
                                              //                             16,
                                              //                         fontWeight:
                                              //                             FontWeight
                                              //                                 .w600),
                                              //                   ),
                                              //                   CustomSwitch(
                                              //                     value: false,
                                              //                     onChanged: (bool
                                              //                         value) async {},
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //             const SizedBox(
                                              //               height: 80,
                                              //             )
                                              //           ],
                                              //         ),
                                              //       ),
                                              //       GestureDetector(
                                              //         onTap: () => showDialog(
                                              //           context: context,
                                              //           builder: (context) =>
                                              //               const UpgradeDialog(),
                                              //         ),
                                              //         child: Container(
                                              //           padding:
                                              //               const EdgeInsets.all(
                                              //                   16),
                                              //           decoration: BoxDecoration(
                                              //             color: kWhite,
                                              //             borderRadius:
                                              //                 BorderRadius
                                              //                     .circular(12),
                                              //             boxShadow: [
                                              //               BoxShadow(
                                              //                 color: Colors.black
                                              //                     .withOpacity(
                                              //                         0.1),
                                              //                 blurRadius: 10,
                                              //                 spreadRadius: 2,
                                              //                 offset:
                                              //                     const Offset(
                                              //                         0, 4),
                                              //               ),
                                              //             ],
                                              //           ),
                                              //           child: Column(
                                              //             mainAxisSize:
                                              //                 MainAxisSize.min,
                                              //             children: [
                                              //               SvgPicture.asset(
                                              //                   'assets/icons/lock_person.svg'),
                                              //               const SizedBox(
                                              //                   height: 8),
                                              //               const Text(
                                              //                 "Upgrade to",
                                              //                 style: TextStyle(
                                              //                   color:
                                              //                       Colors.black,
                                              //                   fontSize: 16,
                                              //                   fontWeight:
                                              //                       FontWeight
                                              //                           .w500,
                                              //                 ),
                                              //               ),
                                              //               const Text(
                                              //                 "unlock",
                                              //                 style: TextStyle(
                                              //                   color:
                                              //                       Colors.black,
                                              //                   fontSize: 16,
                                              //                   fontWeight:
                                              //                       FontWeight
                                              //                           .w500,
                                              //                 ),
                                              //               ),
                                              //             ],
                                              //           ),
                                              //         ),
                                              //       )
                                              //     ],
                                              //   )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 60),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: SizedBox(
                              height: 50,
                              child: customButton(
                                  fontSize: 16,
                                  label: 'Save & Proceed',
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      SnackbarService snackbarService =
                                          SnackbarService();
                                      String response =
                                          await _submitData(user: user);
                                      // Call createRelationship for each relation
                                      if (_relations.isNotEmpty) {
                                        for (final rel in _relations) {
                                          await RelationshipApi
                                              .createRelationship(
                                            person1: user.id!,
                                            person2: rel['memberId']!,
                                            type: rel['relationship']!,
                                          );
                                        }
                                      }
                                      if (response.contains('success')) {
                                        snackbarService.showSnackBar(response);
                                        ref.invalidate(
                                            fetchUserDetailsProvider);
                                        navigateBasedOnPreviousPage();
                                      } else {
                                        snackbarService.showSnackBar(response);
                                      }
                                    }
                                  }))),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  void _onAwardEdit(int index) async {
    final awards = ref
            .read(userProvider)
            .value
            ?.media
            ?.where((m) => m.metadata == 'award')
            .toList() ??
        [];

    if (awards == null || awards.isEmpty || index >= awards.length) {
      snackbarService.showSnackBar('Award not found');
      return;
    }

    final Media oldAward = awards[index];

    awardNameController.text = oldAward.caption ?? '';
    awardAuthorityController.text = oldAward.notes?['authority'] ?? '';

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ShowEnterAwardSheet(
          imageUrl: oldAward.url,
          pickImage: _pickFile,
          editAwardCard: () => _editAward(oldAward: oldAward),
          imageType: 'award',
          textController1: awardNameController,
          textController2: awardAuthorityController,
        );
      },
    );
  }

  Future<void> _editAward({required Media oldAward}) async {
    if (_awardImageFIle != null) {
      // If a new image is selected, upload it
      try {
        final String awardUrl = await imageUpload(_awardImageFIle!.path);
        final newAward = Media(
          metadata: 'award',
          caption: awardNameController.text,
          url: awardUrl,
          notes: {'authority': awardAuthorityController.text},
        );

        ref.read(userProvider.notifier).editAward(oldAward, newAward);
      } catch (e) {
        print('Error uploading award image: $e');
        snackbarService.showSnackBar('Failed to upload award image');
      }
    } else {
      final newAward = Media(
        caption: awardNameController.text,
        url: oldAward.url,
        metadata: 'award',
        notes: {'authority': awardAuthorityController.text},
      );

      ref.read(userProvider.notifier).editAward(oldAward, newAward);
    }
  }

  void _editWebsite(int index) {
    websiteNameController.text =
        ref.read(userProvider).value?.website?[index].name ?? '';
    websiteLinkController.text =
        ref.read(userProvider).value?.website?[index].link ?? '';

    showWebsiteSheet(
        addWebsite: () {
          final Link oldWebsite = ref.read(userProvider).value!.website![index];
          final Link newWebsite = Link(
              name: websiteNameController.text,
              link: websiteLinkController.text);
          ref.read(userProvider.notifier).editWebsite(oldWebsite, newWebsite);
        },
        textController1: websiteNameController,
        textController2: websiteLinkController,
        fieldName: 'Edit Website Link',
        title: 'Edit Website',
        context: context);
  }

  void _editVideo(int index) {
    print('edit video is working');
    final videos = ref
            .read(userProvider)
            .value
            ?.media
            ?.where((m) => m.metadata == 'video')
            .toList() ??
        [];
    videoNameController.text = videos[index].caption ?? '';
    videoLinkController.text = videos[index].url ?? '';

    showVideoLinkSheet(
        addVideo: () {
          final Media oldVideo = videos[index];
          final Media newVideo = Media(
              metadata: 'video',
              caption: videoNameController.text,
              url: videoLinkController.text);
          ref.read(userProvider.notifier).editVideo(oldVideo, newVideo);
        },
        textController1: videoNameController,
        textController2: videoLinkController,
        fieldName: 'Edit Video Link',
        title: 'Edit Video Link',
        context: context);
  }

  void _editCertificate(int index) async {
    final certificates = ref
            .read(userProvider)
            .value
            ?.media
            ?.where((m) => m.metadata == 'certificate')
            .toList() ??
        [];
    final Media oldCertificate = certificates[index];
    certificateNameController.text = oldCertificate.caption ?? '';

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => ShowAddCertificateSheet(
        imageUrl: oldCertificate.url,
        textController: certificateNameController,
        pickImage: _pickFile,
        imageType: 'certificate',
        addCertificateCard: () async {
          if (_certificateImageFIle != null) {
            // If a new image is selected, upload it
            try {
              final String certificateUrl =
                  await imageUpload(_certificateImageFIle!.path);
              final newCertificate = Media(
                  metadata: 'certificate',
                  caption: certificateNameController.text,
                  url: certificateUrl);
              ref
                  .read(userProvider.notifier)
                  .editCertificate(oldCertificate, newCertificate);
            } catch (e) {
              print('Error uploading certificate image: $e');
              snackbarService
                  .showSnackBar('Failed to upload certificate image');
            }
          } else {
            final newCertificate = Media(
              metadata: 'certificate',
              caption: certificateNameController.text,
              url: oldCertificate.url,
            );
            ref
                .read(userProvider.notifier)
                .editCertificate(oldCertificate, newCertificate);
          }
        },
      ),
    );
  }

  Widget _buildDefaultLogoWidget({required int companyIndex}) {
    if (_companyLogoLoadingStates[companyIndex] == true) {
      return const Center(child: LoadingAnimation());
    }
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Upload',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Company',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Logo',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
