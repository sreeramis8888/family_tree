import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_textFormField.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:familytree/src/interface/components/DropDown/selectionDropdown.dart';
import 'package:familytree/src/interface/screens/crop_image_screen.dart';

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
  String? _linkedMember;
  String? _relationship;
  List<Map<String, String?>> _relations = [];
  Uint8List? _profileImage;

  // Example data for dropdowns
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _families = ['Family A', 'Family B'];
  final List<String> _members = ['Member 1', 'Member 2'];
  final List<String> _relationships = ['Father', 'Mother', 'Sibling'];

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

  void _addRelation() {
    if (_linkedMember != null && _relationship != null) {
      setState(() {
        _relations.add({
          'member': _linkedMember,
          'relationship': _relationship,
        });
        _linkedMember = null;
        _relationship = null;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Submit registration data
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
            Navigator.of(context).popUntil((route) => route.isFirst);
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
              SelectionDropDown(
                label: null,
                hintText: 'Select family',
                value: _family,
                items: _families
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (val) => setState(() => _family = val),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Link to Family Member 1 *',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SelectionDropDown(
                label: null,
                hintText: 'Select existing family member',
                value: _linkedMember,
                items: _members
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (val) => setState(() => _linkedMember = val),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Relationship *',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SelectionDropDown(
                label: null,
                hintText: 'Select Relationship',
                value: _relationship,
                items: _relationships
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (val) => setState(() => _relationship = val),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _addRelation,
                child: Text('+ Add Relation',
                    style: TextStyle(color: kRed, fontWeight: FontWeight.bold)),
              ),
              ..._relations.map((rel) => ListTile(
                    title: Text('Member: ${rel['member']}'),
                    subtitle: Text('Relationship: ${rel['relationship']}'),
                  )),
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
