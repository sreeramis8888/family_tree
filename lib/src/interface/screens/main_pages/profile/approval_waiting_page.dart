// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:familytree/src/data/constants/color_constants.dart';
// import 'package:familytree/src/data/globals.dart';
// import 'package:familytree/src/data/notifiers/user_notifier.dart';
// import 'package:familytree/src/data/utils/secure_storage.dart';
// import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
// import 'package:familytree/src/interface/screens/main_pages/profile/premium_subscription_flow.dart';

// class UserInactivePage extends ConsumerWidget {
//   const UserInactivePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       backgroundColor: kWhite,
//       body: Consumer(
//         builder: (context, ref, child) {
//           final asyncUser = ref.watch(userProvider);
//           return asyncUser.when(
//             data: (user) {
        
//               if (user.status?.toLowerCase() == 'trial') {
//             return premium_flow_shown != 'true'
//     ? MySubscriptionPage(
//         // onComplete: () async {
//         //   await SecureStorage.write('premium_flow_shown_${user.id}', 'true');
//         //   premium_flow_shown = 'true';
//         //   Navigator.of(context).pushReplacementNamed('MainPage');
//         //   Navigator.of(context).pushNamed('MySubscriptionPage');
//         // },
//       )
//     : Builder(
//         builder: (context) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             Navigator.of(context).pushReplacementNamed('MainPage');
//           });
//           return const SizedBox.shrink();
//         },
//       );
//               } else if (user.status?.toLowerCase() == 'active') {
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   Navigator.of(context).pushReplacementNamed('MainPage');
//                 });
//                 return const SizedBox.shrink();
//               }
          
//               return RefreshIndicator(
//                 backgroundColor: kWhite,
//                 color: kPrimaryColor,
//                 onRefresh: () async {
//                   await ref.read(userProvider.notifier).refreshUser();
//                 },
//                 child: ListView(
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(
//                               'assets/svg/images/approval_waiting.svg'),
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             child: Text(
//                               'Please wait! \nYour request to join has been sent',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.w600),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             child: Text(
//                               'Thank you for your patience! Our team is reviewing your request. Please allow up to 24 hours for approval.',
//                               textAlign: TextAlign.center,
//                               style:
//                                   TextStyle(fontSize: 15, color: Colors.grey),
//                               overflow: TextOverflow.visible,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             loading: () => const Center(child: LoadingAnimation()),
//             error: (error, stackTrace) {
//               return Center(
//                 child: SizedBox.shrink(),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
