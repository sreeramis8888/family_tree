import 'dart:io';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/services/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_textFormField.dart';
import 'package:familytree/src/interface/components/DropDown/selectionDropdown.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:familytree/src/data/api_routes/events_api/events_api.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  String? _eventType;
  String? _category;
  String? _platform;
  File? _eventImage;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickEventImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        _eventImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startDateController.text =
              _startDate!.toLocal().toString().split(' ')[0];
        } else {
          _endDate = picked;
          _endDateController.text =
              _endDate!.toLocal().toString().split(' ')[0];
        }
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          _startTimeController.text = _startTime!.format(context);
        } else {
          _endTime = picked;
          _endTimeController.text = _endTime!.format(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add New Event',
          style: kSmallTitleM,
        ),
        backgroundColor: kWhite,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SelectionDropDown(
                label: 'Type of Event',
                value: _eventType,
                hintText: 'Select',
                items: [
                  DropdownMenuItem(value: 'Offline', child: Text('Offline')),
                  DropdownMenuItem(value: 'Online', child: Text('Online')),
                ],
                onChanged: (val) => setState(() => _eventType = val),
                validator: (val) => val == null ? 'Please select type' : null,
              ),
              SelectionDropDown(
                label: 'Category',
                value: _category,
                hintText: 'Select',
                items: [
                  DropdownMenuItem(
                      value: 'familyEvent', child: Text('Family Event')),
                  DropdownMenuItem(
                      value: "officialEvent", child: Text("Official Event")),
                ],
                onChanged: (val) => setState(() => _category = val),
                validator: (val) =>
                    val == null ? 'Please select category' : null,
              ),
              CustomTextFormField(
                title: 'Name',
                labelText: 'Enter the name of event',
                textController: _eventNameController,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter event name' : null,
              ),
              const SizedBox(height: 10),
              Text('Event Image',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _pickEventImage,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      _eventImage == null
                          ? Icon(Icons.cloud_upload_outlined,
                              color: Colors.grey)
                          : Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _eventImage == null
                              ? 'Upload file here'
                              : 'Photo added',
                          style: TextStyle(
                            color: _eventImage == null
                                ? Colors.grey
                                : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Upload your invitation card here.\nAccepted formats: JPG, PNG / Max size: 5MB\nRecommended dimensions: 1080 x 1920 px for best quality',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                title: 'Description',
                labelText: 'Enter the content here',
                textController: _descriptionController,
                maxLines: 4,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _pickDate(isStart: true),
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    title: 'Start Date',
                    labelText: 'Select Start Date from Calendar',
                    textController: _startDateController,
                    readOnly: true,
                    onChanged: () {},
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Select start date' : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _pickDate(isStart: false),
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    title: 'End Date',
                    labelText: 'Select End Date from Calendar',
                    textController: _endDateController,
                    readOnly: true,
                    onChanged: () {},
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Select end date' : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _pickTime(isStart: true),
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    title: 'Start Time',
                    labelText: 'Select Start Time',
                    textController: _startTimeController,
                    readOnly: true,
                    onChanged: () {},
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Select start time' : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _pickTime(isStart: false),
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    title: 'End Time',
                    labelText: 'Select End Time',
                    textController: _endTimeController,
                    readOnly: true,
                    onChanged: () {},
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Select end time' : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SelectionDropDown(
                label: 'Virtual Platform',
                value: _platform,
                hintText: 'Choose the Virtual Platform',
                items: [
                  DropdownMenuItem(value: 'Zoom', child: Text('Zoom')),
                  DropdownMenuItem(
                      value: 'Google Meet', child: Text('Google Meet')),
                  DropdownMenuItem(value: 'Teams', child: Text('Teams')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (val) => setState(() => _platform = val),
                validator: (val) =>
                    val == null ? 'Please select platform' : null,
              ),
              CustomTextFormField(
                title: 'Link',
                labelText: 'Add Meeting Link here',
                textController: _linkController,
                validator: (val) => null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Collect all required fields
                      final userId = id;
                      final eventName = _eventNameController.text;
                      final description = _descriptionController.text;
                      final eventStartDate = _startDateController.text;
                      final eventEndDate = _endDateController.text;
                      final posterVisibilityStartDate = _startDateController
                          .text; // You may want a separate field
                      final posterVisibilityEndDate = _endDateController
                          .text; // You may want a separate field
                      final platform = _platform ?? '';
                      final link = _linkController.text;
                      final venue = '';
                      final organiserName = '';

                      final limit = 100;
                      final speakers = <Map<String,
                          dynamic>>[]; // TODO: Add speaker fields if needed
                      final eventMode = _eventType ?? '';
                      final type = _category ?? '';
                      final image = await imageUpload(_eventImage?.path ?? '');

                      final result = await postEventByUser(
                        userId: userId,
                        eventName: eventName,
                        description: description,
                        eventStartDate: eventStartDate,
                        eventEndDate: eventEndDate,
                        posterVisibilityStartDate: posterVisibilityStartDate,
                        posterVisibilityEndDate: posterVisibilityEndDate,
                        platform: platform,
                        link: link,
                        venue: venue,
                        organiserName: organiserName,
                        limit: limit,
                        speakers: speakers,
                        eventMode: eventMode,
                        type: type,
                        image: image,
                      );

                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Event applied successfully')),
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to apply event')),
                        );
                      }
                    }
                  },
                  child: const Text('Sent Request',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
