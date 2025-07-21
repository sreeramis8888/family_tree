import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:familytree/src/data/api_routes/family_api.dart/family_api.dart';
import 'package:familytree/src/data/api_routes/user_api/login/user_login_api.dart';
import 'package:familytree/src/data/services/image_upload.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/data/utils/secure_storage.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/screens/onboarding/approval_waiting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_textFormField.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:familytree/src/interface/components/DropDown/selectionDropdown.dart';
import 'package:familytree/src/interface/screens/crop_image_screen.dart';
import 'package:path_provider/path_provider.dart';

class RegistrationPage extends StatefulWidget {
  final String phone;
  const RegistrationPage({Key? key, required this.phone}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  String? _gender;
  String _status = 'Alive';
  String? _family;
  String? _parentFamily;
  String? _linkedMember;
  String? _relationship;
  List<Map<String, String?>> _relations = [];
  Uint8List? _profileImage;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _relationships = ["spouse", "parent", "sibling", "child"];

  bool _isCreatingFamily = false;
  String? _familyCreationError;

  @override
  void initState() {
    super.initState();
    _mobileController.text = widget.phone;
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final cropped = await Navigator.of(context).push<Uint8List>(
          MaterialPageRoute(
            builder: (context) =>
                CropImageScreen(imageFile: File(pickedFile.path)),
          ),
        );

        if (cropped != null) {
          setState(() {
            _profileImage = cropped;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
      });
    }
  }

  Future<String> saveUint8ListToFile(Uint8List bytes, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      String? profilePictureUrl;
      try {
        String? phone = await SecureStorage.getPhoneNumber();

        if (_profileImage != null) {
          String tempImagePath =
              await saveUint8ListToFile(_profileImage!, 'profile.png');

          profilePictureUrl = await imageUpload(tempImagePath);
        }
        Map<String, dynamic> formData = {
          "fullName": _nameController.text,
          "gender": _gender,
          "parentFamilyId": _parentFamily,
          "isAlive": _status == 'Alive',
          "familyId": _family,
          "phone": phone,
          if (profilePictureUrl != null) "image": profilePictureUrl,
          "relationships": _relations
              .map((rel) => {
                    "personId": rel['memberId'],
                    "type": rel['relationship'],
                  })
              .toList(),
        };

        log(formData.toString());

        final responseStatuscode =
            await sendRequest(formData: formData, context: context);

        if (responseStatuscode == 200) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const ApprovalWaitingPage()),
          );
        }
      } catch (e) {
        log('Error during submission: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit form. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: kWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            NavigationService navigationService = NavigationService();
            navigationService.pushNamedReplacement('PhoneNumber');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImage != null
                          ? MemoryImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? Icon(Icons.person, size: 48, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.black,
                          child: Icon(Icons.camera_alt,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Full Name *',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              CustomTextFormField(
                labelText: 'Enter the full name',
                textController: _nameController,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Gender *', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              SelectionDropDown(
                label: null,
                hintText: 'Select gender',
                value: _gender,
                items: _genders
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => _gender = val),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              // Text('Mobile Number *',
              //     style: TextStyle(fontWeight: FontWeight.bold)),
              // CustomTextFormField(
              //   labelText: 'Enter Mobile Number',
              //   textController: _mobileController,
              //   enabled: false,
              // ),
              // const SizedBox(height: 16),
              Text('Status *', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio<String>(
                    value: 'Alive',
                    groupValue: _status,
                    onChanged: (val) => setState(() => _status = val!),
                  ),
                  Text('Alive'),
                  Radio<String>(
                    value: 'Deceased',
                    groupValue: _status,
                    onChanged: (val) => setState(() => _status = val!),
                  ),
                  Text('Deceased'),
                ],
              ),
              const SizedBox(height: 16),
              Text('Family *', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, child) {
                  final asyncFamilies = ref.watch(fetchAllFamilyProvider);
                  return asyncFamilies.when(
                    data: (families) {
                      final items = families
                          .map((f) => DropdownMenuItem<String>(
                                value: f.id ?? '',
                                child: Text(f.name ?? ''),
                              ))
                          .toList();
                      items.add(
                        const DropdownMenuItem<String>(
                          value: '__add_new__',
                          child: Text('+ Add new family',
                              style: TextStyle(fontStyle: FontStyle.italic)),
                        ),
                      );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectionDropDown(
                            label: null,
                            hintText: 'Select family',
                            value: _family,
                            items: items,
                            onChanged: (val) async {
                              if (val == '__add_new__') {
                                final newFamilyName = await showDialog<String>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    String input = '';
                                    final TextEditingController controller =
                                        TextEditingController();

                                    return Dialog(
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Container(
                                        width: 400,
                                        padding: const EdgeInsets.all(24),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Header with icon
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Icon(
                                                    Icons.group_add,
                                                    color: kPrimaryColor,
                                                    size: 24,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Add New Family',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kBlack,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'Enter the name for the new family',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: kGreyDark,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 24),

                                            // Input field
                                            Text(
                                              'Family Name',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: kBlack,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: kGreyLight),
                                                color: kWhite,
                                              ),
                                              child: TextField(
                                                controller: controller,
                                                autofocus: true,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: kBlack,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: 'Enter family name',
                                                  hintStyle: TextStyle(
                                                    color: kInputFieldcolor,
                                                    fontSize: 16,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 16,
                                                    vertical: 14,
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.family_restroom,
                                                    color: kInputFieldcolor,
                                                    size: 20,
                                                  ),
                                                ),
                                                onChanged: (v) => input = v,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                              ),
                                            ),

                                            const SizedBox(height: 32),

                                            // Action buttons
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  style: TextButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 24,
                                                      vertical: 12,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: kGreyDark,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                SizedBox(
                                                  width: 140,
                                                  child: customButton(
                                                    label: 'Add Family',
                                                    onPressed: () {
                                                      if (input
                                                          .trim()
                                                          .isNotEmpty) {
                                                        Navigator.of(context)
                                                            .pop(input.trim());
                                                      }
                                                    },
                                                    buttonColor: kPrimaryColor,
                                                    labelColor: kWhite,
                                                    fontSize: 16,
                                                    buttonHeight: 44,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (newFamilyName != null &&
                                    newFamilyName.isNotEmpty) {
                                  setState(() {
                                    _isCreatingFamily = true;
                                    _familyCreationError = null;
                                  });
                                  try {
                                    final newFamily =
                                        await FamilyApiService.createFamily(
                                            newFamilyName);
                                    setState(() {
                                      _family = newFamily.id;
                                      _isCreatingFamily = false;
                                    });
                                    // Optionally, refresh the families provider
                                    ref.invalidate(fetchAllFamilyProvider);
                                  } catch (e) {
                                    setState(() {
                                      _isCreatingFamily = false;
                                      _familyCreationError =
                                          'Failed to create family. Please try again.';
                                    });
                                  }
                                }
                              } else {
                                setState(() {
                                  _family = val;
                                });
                              }
                            },
                            validator: (val) => val == null ? 'Required' : null,
                          ),
                          if (_isCreatingFamily)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: LinearProgressIndicator(),
                            ),
                          if (_familyCreationError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(_familyCreationError!,
                                  style: const TextStyle(color: Colors.red)),
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
              ),
              const SizedBox(height: 16),

              Consumer(
                builder: (context, ref, child) {
                  final asyncFamilies = ref.watch(fetchAllFamilyProvider);
                  return asyncFamilies.when(
                    data: (families) {
                      final filteredFamilies =
                          families.where((f) => f.id != _family).toList();
                      if (filteredFamilies.isNotEmpty) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text('Parent Family',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SelectionDropDown(
                              label: null,
                              hintText: 'Select parent family',
                              value: _parentFamily,
                              items: filteredFamilies
                                  .map((f) => DropdownMenuItem<String>(
                                        value: f.id ?? '',
                                        child: Text(f.name ?? ''),
                                      ))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _parentFamily = val),
                              // validator removed to make selection optional
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                    loading: () => const Center(child: LoadingAnimation()),
                    error: (error, stackTrace) {
                      log(error.toString());
                      return const Center(child: SizedBox.shrink());
                    },
                  );
                },
              ),
              if (_family != null) const SizedBox(height: 16),
              if (_family != null)
                Consumer(
                  builder: (context, ref, child) {
                    final asyncFamily = ref.watch(
                        fetchSingleFamilyProvider(familyId: _family ?? ''));
                    return asyncFamily.when(
                      data: (family) {
                        final hasMembers = family.members != null &&
                            family.members!.isNotEmpty;
                        if (!hasMembers) {
                          return Text('No Members exists in this family');
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Link to Family Member 1 *',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              SelectionDropDown(
                                label: null,
                                hintText: 'Select existing family member',
                                value: _linkedMember,
                                items: family.members!
                                    .where((m) => !_relations.any((rel) => rel['memberId'] == m.id))
                                    .map((m) => DropdownMenuItem(
                                        value: m.id,
                                        child: Text(m.fullName ?? '')))
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _linkedMember = val),
                                validator: (val) =>
                                    val == null ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),
                              Text('Relationship *',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              SelectionDropDown(
                                label: null,
                                hintText: 'Select Relationship',
                                value: _relationship,
                                items: _relationships
                                    .map((r) => DropdownMenuItem(
                                        value: r, child: Text(r.toUpperCase())))
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _relationship = val),
                                validator: (val) =>
                                    val == null ? 'Required' : null,
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  final selectedMember = family.members!
                                      .firstWhere((m) => m.id == _linkedMember);
                                  _addRelation(selectedMember.fullName ?? '');
                                },
                                child: Text('+ Add Relation',
                                    style: TextStyle(
                                        color: kRed,
                                        fontWeight: FontWeight.bold)),
                              ),
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
                                            setState(() {
                                              _relations.removeAt(entry.key);
                                            });
                                          },
                                        ),
                                      )),
                            ],
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
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: customButton(
                  label: 'Sent Request',
                  onPressed: _submit,
                  isLoading: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
