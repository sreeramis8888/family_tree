import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:familytree/src/data/api_routes/chat_api/chat_api.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/chat_model.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/screens/main_pages/chat/chat_screen.dart';

import 'package:shimmer/shimmer.dart';

class ChatDash extends ConsumerStatefulWidget {
  ChatDash({super.key});

  @override
  ConsumerState<ChatDash> createState() => _ChatDashState();
}

class _ChatDashState extends ConsumerState<ChatDash> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final asyncChats = ref.watch(fetchChatThreadProvider);

      return Scaffold(
          backgroundColor: kWhite,
          body: asyncChats.when(
            data: (chats) {
              if (chats.isNotEmpty) {
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    var receiver = chats[index].participants?.firstWhere(
                          (participant) => participant.id != id,
                          orElse: () => Participant(),
                        );
                    var sender = chats[index].participants?.firstWhere(
                          (participant) => participant.id == id,
                          orElse: () => Participant(),
                        );
                    return Column(
                      children: [
                        ListTile(
                          leading: ClipOval(
                            child: Container(
                              width: 40,
                              height: 40,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              child: Image.network(
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }

                                  return Container(
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                receiver?.image ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return SvgPicture.asset(
                                      'assets/svg/icons/dummy_person_small.svg');
                                },
                              ),
                            ),
                          ),
                          title: Text('${receiver?.name ?? ''}'),
                          subtitle: Text(
                            chats[index].lastMessage?.content != null
                                ? (chats[index].lastMessage!.content!.length >
                                        10
                                    ? '${chats[index].lastMessage?.content!.substring(0, chats[index].lastMessage!.content!.length.clamp(0, 10))}...'
                                    : chats[index].lastMessage!.content!)
                                : '',
                          ),
                          trailing: chats[index].unreadCount?[sender?.id] !=
                                      0 &&
                                  chats[index].unreadCount?[sender!.id] != null
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Center(
                                      child: chats[index]
                                                  .unreadCount?[sender!.id] !=
                                              null
                                          ? Text(
                                              '${chats[index].unreadCount?[sender!.id]}',
                                              style: TextStyle(
                                                color: kWhite,
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                          : null,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => IndividualPage(
                                receiver: receiver!,
                                sender: sender!,
                              ),
                            ));
                          },
                        ),
                        Divider(
                            thickness: 1,
                            height: 1,
                            color: Colors.grey[350]), // Full-width divider line
                      ],
                    );
                  },
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Center(child: Image.asset('assets/pngs/nochat.png')),
                    ),
                    Text('No chat yet!')
                  ],
                );
              }
            },
            loading: () => const Center(child: LoadingAnimation()),
            error: (error, stackTrace) {},
          ));
    });
  }
}
