import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:familytree/src/data/services/validate_url.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:familytree/src/interface/components/custom_widgets/custom_textFormField.dart';

void showWebsiteSheet({
  required VoidCallback addWebsite,
  required String title,
  required String fieldName,
  required BuildContext context,
  required TextEditingController textController1,
  required TextEditingController textController2,
}) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return Form(
        key: _formKey,
        child: Stack(
          clipBehavior:
              Clip.none, // Allow content to overflow outside the stack
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ModalSheetTextFormField(
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'This is a required field';
                    //   }
                    //   return null;
                    // },
                    label: 'Add name',
                    textController: textController1,
                  ),
                  const SizedBox(height: 10),
                  ModalSheetTextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a website';
                      }

                      return null;
                    },
                    label: fieldName,
                    textController: textController2,
                  ),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      return customButton(
                        label: 'SAVE',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addWebsite();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Saved')),
                            );
                            Navigator.pop(context);
                          }
                        },
                        fontSize: 16,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Positioned(
              right: 5,
              top: -50,
              child: Container(
                padding: const EdgeInsets.all(0),
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showVideoLinkSheet({
  required VoidCallback addVideo,
  required String title,
  required String fieldName,
  required BuildContext context,
  required TextEditingController textController1,
  required TextEditingController textController2,
}) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return Form(
        key: _formKey,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ModalSheetTextFormField(
                    label: 'Add name',
                    textController: textController1,
                  ),
                  const SizedBox(height: 10),
                  ModalSheetTextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is a required field';
                      }
                      return null;
                    },
                    label: fieldName,
                    textController: textController2,
                  ),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      return customButton(
                        label: 'SAVE',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addVideo();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Saved')),
                            );
                            Navigator.pop(context);
                          }
                        },
                        fontSize: 16,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Positioned(
              right: 5,
              top: -50,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
