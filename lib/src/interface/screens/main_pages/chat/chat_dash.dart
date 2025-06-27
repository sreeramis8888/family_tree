import 'package:familytree/src/data/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/api_routes/chat_api/chat_api.dart';
import 'package:familytree/src/interface/screens/main_pages/chat/chat_screen.dart';
import 'package:familytree/src/data/models/chat_conversation_model.dart';
import 'package:familytree/src/data/models/chat_model.dart';
import 'package:familytree/src/data/services/socket_service.dart';

extension ChatConversationUnread on ChatConversation {
  int get unreadCount => (this as dynamic).unreadCount ?? 0;
}

bool isOtherParticipant(dynamic userId, String currentUserId) {
  if (userId is String) return userId != currentUserId;
  if (userId is ChatUser) return userId.id != currentUserId;
  return false;
}

class ChatDash extends ConsumerStatefulWidget {
  ChatDash({super.key});

  @override
  ConsumerState<ChatDash> createState() => _ChatDashState();
}

class _ChatDashState extends ConsumerState<ChatDash> {
  final Map<String, Map<String, String?>> _userPresence = {};
  late SocketService _socketService;

  @override
  void initState() {
    super.initState();
    _socketService = SocketService();
    _socketService.onUserStatusUpdate((userId, status, lastSeen) {
      setState(() {
        _userPresence[userId] = {'status': status, 'lastSeen': lastSeen};
      });
    });
  }

  String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} days ago';
  }

  String getPresenceText(String userId) {
    final presence = _userPresence[userId];
    if (presence == null) return '';
    if (presence['status'] == 'online') return 'Online';
    if (presence['lastSeen'] != null && presence['lastSeen']!.isNotEmpty) {
      final dt = DateTime.tryParse(presence['lastSeen']!);
      if (dt != null) return 'Last seen ' + timeAgo(dt);
    }
    return 'Offline';
  }

  @override
  Widget build(BuildContext context) {
    final conversationsAsync = ref.watch(fetchChatConversationsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: conversationsAsync.when(  
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (chats) {
          if (chats.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Image.asset('assets/pngs/nochat.png')),
                ),
                const Text('No chat yet!'),
              ],
            );
          }
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final conversation = chats[index];
              final messagesAsync = ref.watch(
                fetchChatMessagesProvider(conversationId: conversation.id??''),
              );
              return Column(
                children: [
                  messagesAsync.when(
                    loading: () => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: (conversation.participants.length == 2 && conversation.participants.firstWhere((p) => isOtherParticipant(p.userId, id), orElse: () => Participant(userId: '', isActive: false))?.isActive == true)
                            ? Colors.green[100]
                            : Colors.grey[200],
                        backgroundImage: conversation.avatar != null && conversation.avatar!.isNotEmpty
                            ? NetworkImage(conversation.avatar!)
                            : null,
                        child: conversation.avatar == null || conversation.avatar!.isEmpty
                            ? Text(conversation.name != null && conversation.name!.isNotEmpty ? conversation.name![0] : '?')
                            : null,
                      ),
                      title: Text(conversation.name ?? 'Chat'),
                      subtitle: () {
                        if (conversation.participants.length > 2) {
                          final onlineCount = conversation.participants.where((p) => p.isActive == true).length;
                          return Text('${conversation.participants.length} members, $onlineCount online');
                        } else {
                          final other = conversation.participants.firstWhere(
                            (p) => isOtherParticipant(p.userId, id),
                            orElse: () => Participant(userId: '', isActive: false),
                          );
                          if (other != null && other.isActive == true) {
                            return const Text('Online', style: TextStyle(color: Colors.green));
                          } else if (conversation.lastActivity != null) {
                            return Text('Last seen ' + timeAgo(conversation.lastActivity!));
                          } else {
                            return const Text('Offline');
                          }
                        }
                      }(),
                      trailing: conversation.unreadCount != null && conversation.unreadCount! > 0
                        ? CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Text('${conversation.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                          )
                        : null,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => IndividualPage(
                            conversation: conversation,
                            currentUserId: id,
                          ),
                        ));
                      },
                    ),
                    error: (error, stack) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: conversation.avatar != null && conversation.avatar!.isNotEmpty
                            ? NetworkImage(conversation.avatar!)
                            : null,
                        child: conversation.avatar == null || conversation.avatar!.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(conversation.name ?? 'Chat'),
                      subtitle: const Text('Error loading message'),
                      trailing: const SizedBox.shrink(),
                    ),
                    data: (messages) {
                      String lastMessageText = '';
                      if (messages.isNotEmpty) {
                        lastMessageText = messages.last.content ?? '';
                        if (lastMessageText.length > 30) {
                          lastMessageText = lastMessageText.substring(0, 30) + '...';
                        }
                      }
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: conversation.avatar != null && conversation.avatar!.isNotEmpty
                              ? NetworkImage(conversation.avatar!)
                              : null,
                          child: conversation.avatar == null || conversation.avatar!.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(conversation.name ?? 'Chat'),
                        subtitle: Text(lastMessageText),
                        trailing: const SizedBox.shrink(),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => IndividualPage(
                              conversation: conversation,
                              currentUserId: id,
                            ),
                          ));
                        },
                      );
                    },
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.grey[350],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
