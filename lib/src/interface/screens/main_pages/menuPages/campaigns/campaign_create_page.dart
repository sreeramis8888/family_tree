import 'dart:developer';
import 'dart:io';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_textFormField.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/interface/screens/main_pages/admin/member_creation.dart'
    show CustomDropdown;
import 'package:familytree/src/data/api_routes/campain_api/campaign_api.dart';
import 'package:familytree/src/interface/components/DropDown/selectionDropdown.dart';

class CampaignCreatePage extends StatefulWidget {
  const CampaignCreatePage({Key? key}) : super(key: key);

  @override
  State<CampaignCreatePage> createState() => _CampaignCreatePageState();
}

class _CampaignCreatePageState extends State<CampaignCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _targetAmountController =
      TextEditingController(text: '₹1,00,000');
  final TextEditingController _tagController = TextEditingController();
  DateTime? _startDate;
  DateTime? _targetDate;
  String _status = 'Active';
  File? _coverImage;
  File? _uploadImage;
  List<_DocumentUpload> _documents = [];

  Future<void> _pickCoverImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _coverImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickUploadImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _uploadImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _documents.add(_DocumentUpload(File(result.files.single.path!)));
      });
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _targetDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kBlack),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Add New Campaign', style: kBodyTitleM),
      ),
      backgroundColor: kWhite,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text('Campaign Name', style: kBodyTitleM),
              CustomTextFormField(
                labelText: 'Enter the Name of campaign',
                textController: _nameController,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Organized by', style: kBodyTitleM),
              CustomTextFormField(
                labelText: 'Enter the Name of organizer',
                textController: _organizerController,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Description', style: kBodyTitleM),
              CustomTextFormField(
                labelText: 'Enter your description here',
                textController: _descriptionController,
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Cover Image', style: kBodyTitleM),
              const SizedBox(height: 4),
              Text('Image (JPG/PNG) – Recommended size: 400x400',
                  style: kSmallerTitleR),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickCoverImage,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.upload_file, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(_coverImage == null
                              ? 'Upload'
                              : 'Image Selected')),
                      const Icon(Icons.cloud_upload_outlined,
                          color: Colors.grey),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Document', style: kBodyTitleM),
              const SizedBox(height: 4),
              Text('Upload Document (PDF only)', style: kSmallerTitleR),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDocument,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.upload_file, color: Colors.grey),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('Upload')),
                      const Icon(Icons.cloud_upload_outlined,
                          color: Colors.grey),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
              ..._documents.map((doc) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.picture_as_pdf, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(child: Text(doc.file.path.split('/').last)),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _documents.remove(doc);
                            });
                          },
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              Text('Status', style: kBodyTitleM),
              SelectionDropDown(
                label: 'Status',
                items: ['Active', 'Inactive']
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                value: _status,
                onChanged: (v) => setState(() => _status = v ?? 'Active'),
              ),
              const SizedBox(height: 16),
              Text('Tag', style: kBodyTitleM),
              SelectionDropDown(
                label: 'Tag',
                items: ['ZAKATH', 'CSR']
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                value: _tagController.text.isEmpty ? null : _tagController.text,
                onChanged: (v) => setState(() => _tagController.text = v ?? ''),
              ),
              const SizedBox(height: 16),
              Text('Start Date', style: kBodyTitleR),
              GestureDetector(
                onTap: () => _pickDate(isStart: true),
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    labelText: 'Start Date',
                    textController: TextEditingController(
                      text: _startDate == null
                          ? ''
                          : _startDate!.toString().split(' ')[0],
                    ),
                    readOnly: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Target Date', style: kBodyTitleR),
              GestureDetector(
                onTap: () => _pickDate(isStart: false),
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    labelText: 'Target Date',
                    textController: TextEditingController(
                      text: _targetDate == null
                          ? ''
                          : _targetDate!.toString().split(' ')[0],
                    ),
                    readOnly: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Target Amount', style: kBodyTitleR),
              CustomTextFormField(
                labelText: 'Target Amount',
                textController: _targetAmountController,
                textInputType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Upload Image', style: kBodyTitleR),
              const SizedBox(height: 4),
              Text('Image (JPG/PNG) – Recommended size: 400x400',
                  style: kSmallerTitleR),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickUploadImage,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.upload_file, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(_uploadImage == null
                              ? 'Upload'
                              : 'Image Selected')),
                      const Icon(Icons.cloud_upload_outlined,
                          color: Colors.grey),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final Map<String, dynamic> data = {
                        'title': _nameController.text,
                        'description': _descriptionController.text,
                        'media': _coverImage?.path ?? '',
                        'targetAmount': int.tryParse(_targetAmountController
                                .text
                                .replaceAll(RegExp(r'[^0-9]'), '')) ??
                            0,
                        'deadline': _targetDate?.toIso8601String(),
                        'tagType': _tagController.text.isNotEmpty
                            ? _tagController.text
                            : null,
                        'organizedBy': _organizerController.text,
                        'documents':
                            _documents.map((doc) => doc.file.path).toList(),
                        'status': _status,
                        'createdBy': id
                      };
                      log(data.toString());
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: LoadingAnimation()),
                      );
                      final success = await CampaignApiService.createCampaign(
                          data: data, context: context);
                      Navigator.of(context).pop();
                      if (success) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const Text('Sent Request',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentUpload {
  final File file;
  _DocumentUpload(this.file);
}
