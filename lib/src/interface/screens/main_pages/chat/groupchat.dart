// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:familytree/src/data/api_routes/chat_api/chat_api.dart';
// import 'package:familytree/src/data/models/chat_conversation_model.dart';
// import 'package:familytree/src/interface/screens/main_pages/chat/chat_screen.dart';

// class GroupChatPage extends ConsumerWidget {
//   const GroupChatPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final token = 'YOUR_TOKEN'; // Replace with actual token
//     final conversationsAsync = ref.watch(fetchChatConversationsProvider(token: token));

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: conversationsAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(child: Text('Error: $error')),
//         data: (chats) {
//           final groups = chats.where((c) => c.type == 'group').toList();
//           if (groups.isEmpty) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(child: Image.asset('assets/pngs/nochat.png')),
//                 ),
//                 const Text('No group chat yet!'),
//               ],
//             );
//           }
//           return ListView.builder(
//             itemCount: groups.length,
//             itemBuilder: (context, index) {
//               final group = groups[index];
//               final messagesAsync = ref.watch(
//                 fetchChatMessagesProvider(token: token, conversationId: group.id),
//               );
//               return messagesAsync.when(
//                 loading: () => ListTile(
//                   leading: CircleAvatar(child: Icon(Icons.groups)),
//                   title: Text(group.name ?? 'Group'),
//                   subtitle: const Text('Loading...'),
//                 ),
//                 error: (error, stack) => ListTile(
//                   leading: CircleAvatar(child: Icon(Icons.groups)),
//                   title: Text(group.name ?? 'Group'),
//                   subtitle: const Text('Error loading message'),
//                 ),
//                 data: (messages) {
//                   String lastMessageText = '';
//                   if (messages.isNotEmpty) {
//                     lastMessageText = messages.last.content ?? '';
//                     if (lastMessageText.length > 30) {
//                       lastMessageText = lastMessageText.substring(0, 30) + '...';
//                     }
//                   }
//                   return ListTile(
//                     leading: CircleAvatar(child: Icon(Icons.groups)),
//                     title: Text(group.name ?? 'Group'),
//                     subtitle: Text(lastMessageText),
//                     onTap: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => IndividualPage(
//                           conversation: group,
//                           currentUserId: token,
//                         ),
//                       ));
//                     },
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
