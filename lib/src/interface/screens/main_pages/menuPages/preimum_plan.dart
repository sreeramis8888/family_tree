// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:familytree/src/data/constants/color_constants.dart';
// import 'package:familytree/src/data/services/save_qr.dart';
// import 'package:familytree/src/data/services/snackbar_service.dart';
// import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
// import 'package:familytree/src/interface/components/ModalSheets/payment_model_sheet.dart';
// import 'package:screenshot/screenshot.dart';

// class PremiumPlanPage extends StatefulWidget {
//   final String subcriptionType;
//   const PremiumPlanPage({super.key, required this.subcriptionType});

//   @override
//   State<PremiumPlanPage> createState() => _PremiumPlanPageState();
// }

// SnackbarService snackbarService = SnackbarService();

// class _PremiumPlanPageState extends State<PremiumPlanPage> {
//   ScreenshotController screenshotController = ScreenshotController();
//   File? _paymentImage;

//   void _openModalSheet({required subscriptionType}) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return ShowPaymentUploadSheet(
//             subscriptionType: subscriptionType,
//             pickImage: _pickFile,
//             imageType: 'payment',
//             paymentImage: _paymentImage,
//           );
//         });
//   }

//   Future<File?> _pickFile({required String imageType}) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: [
//         'png',
//         'jpg',
//         'jpeg',
//       ],
//     );

//     if (result != null) {
//       _paymentImage = File(result.files.single.path!);
//       return _paymentImage;
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     String textToCopy = '';
//     return Scaffold(
//       backgroundColor: kWhite,
//       appBar: AppBar(
//         title: const Text(
//           "Upgrade Plan",
//           style: TextStyle(fontSize: 17),
//         ),
//         backgroundColor: kWhite,
//         scrolledUnderElevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 16.0),
//               const Text(
//                 'PAY NOW',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Color.fromARGB(255, 53, 52, 52),
//                 ),
//               ),
//               const SizedBox(height: 8.0),
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     '₹1000',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 40,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(width: 8.0),
//                   Text(
//                     'per year',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24.0),
//               Container(
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       kPrimaryColor,
//                       kPrimaryColor.withOpacity(.8),
//                       kPrimaryLightColor,
//                     ],
//                     stops: [0.0, 0.7, 1.0],
//                   ),
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'BANK DETAILS',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: kWhite,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8.0),
//                     Row(
//                       children: [
//                         const Text(
//                           'Bank Name: SOUTH INDIAN BANK',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: kWhite,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             setState(() {
//                               textToCopy = ' SOUTH INDIAN BANK';
//                             });
//                             Clipboard.setData(ClipboardData(text: textToCopy));
//                             snackbarService
//                                 .showSnackBar('Text copied to clipboard');
//                           },
//                           icon: const Icon(
//                             Icons.copy,
//                             color: kWhite,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Text(
//                           'Branch: CHEBUKKAVU BRANCH',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: kWhite,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             setState(() {
//                               textToCopy = 'CHEBUKKAVU BRANCH';
//                             });
//                             Clipboard.setData(ClipboardData(text: textToCopy));
//                             snackbarService
//                                 .showSnackBar('Text copied to clipboard');
//                           },
//                           icon: const Icon(
//                             Icons.copy,
//                             color: kWhite,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Text(
//                           'A/c no.: 0834073000000169',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: kWhite,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             setState(() {
//                               textToCopy = '0834073000000169';
//                             });
//                             Clipboard.setData(ClipboardData(text: textToCopy));
//                             snackbarService
//                                 .showSnackBar('Text copied to clipboard');
//                           },
//                           icon: const Icon(
//                             Icons.copy,
//                             color: kWhite,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Text(
//                           'A/c name: Hindu Economic Forum',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: kWhite,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             setState(() {
//                               textToCopy = 'Hindu Economic Forum';
//                             });
//                             Clipboard.setData(ClipboardData(text: textToCopy));
//                             snackbarService
//                                 .showSnackBar('Text copied to clipboard');
//                           },
//                           icon: const Icon(
//                             Icons.copy,
//                             color: kWhite,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Text(
//                           'IFS code: SIBL0000834',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: kWhite,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             setState(() {
//                               textToCopy = 'SIBL0000834';
//                             });
//                             Clipboard.setData(ClipboardData(text: textToCopy));
//                             snackbarService
//                                 .showSnackBar('Text copied to clipboard');
//                           },
//                           icon: const Icon(
//                             Icons.copy,
//                             color: kWhite,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24.0),
//               Center(
//                 child: Column(
//                   children: [
//                     const Text(
//                       'or SCAN',
//                       style: TextStyle(
//                           color: Color.fromARGB(255, 29, 28, 28),
//                           fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 16.0),
//                     const SizedBox(height: 8.0),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 233, 229, 229),
//                             width: 2.0), // Border color and width
//                         borderRadius:
//                             BorderRadius.circular(16.0), // Curved radius
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(
//                             16.0), // Same radius as the border
//                         child: Screenshot(
//                             controller: screenshotController,
//                             child: Image.asset('assets/pngs/bank_details.png')),
//                       ),
//                     ),
//                     const SizedBox(height: 16.0),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 50),
//                       child: customButton(
//                           label: 'Download QR Code',
//                           onPressed: () {
//                             saveQr(
//                               screenshotController: screenshotController,
//                             );
//                           },
//                           sideColor: const Color(0xFFF2F2F7),
//                           buttonColor: const Color(0xFFF2F2F7),
//                           labelColor: const Color(0xFF333333)),
//                     )
//                   ],
//                 ),
//               ),
//               // const Spacer(),
//               const SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 50),
//                     child: customButton(
//                         label: 'Upload Reciept',
//                         onPressed: () {
//                           _openModalSheet(
//                               subscriptionType: widget.subcriptionType);
//                         }),
//                   )),
//               const SizedBox(height: 16.0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
