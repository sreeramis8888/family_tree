import 'package:familytree/src/data/models/user_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:familytree/src/data/api_routes/chat_api/chat_api.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/models/msg_model.dart';
import 'package:familytree/src/data/notifiers/user_notifier.dart';
import 'package:familytree/src/interface/components/Dialogs/blockPersonDialog.dart';
import 'package:familytree/src/interface/components/Dialogs/report_dialog.dart';
import 'package:familytree/src/interface/components/common/own_message_card.dart';
import 'package:familytree/src/interface/components/common/reply_card.dart';
import 'package:familytree/src/interface/components/custom_widgets/blue_tick_names.dart';
import 'package:familytree/src/interface/screens/main_pages/profile/profile_preview.dart';
import 'package:familytree/src/data/models/chat_conversation_model.dart';
import 'package:familytree/src/data/models/chat_message_model.dart';
import 'package:intl/intl.dart';
import 'package:familytree/src/data/services/socket_service.dart';
import 'package:familytree/src/data/models/chat_model.dart';
import 'dart:async';

class IndividualPage extends StatefulWidget {
  final ChatConversation conversation;
  final String currentUserId;
  const IndividualPage(
      {required this.conversation, required this.currentUserId, super.key});

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [];
  late SocketService socketService;
  bool socketConnected = false;
  bool isTyping = false;
  String? typingUserId;
  bool _hasSentTyping = false;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    socketService = SocketService();
    socketService.connect();
    socketService.joinRoom(widget.conversation.id ?? '');
    socketService.onMessage((data) {
      if (data['conversationId'] == widget.conversation.id) {
        setState(() {
          messages.add(ChatMessage.fromJson(data));
        });
      }
    });

    socketService.onUserTyping((userId, conversationId) {
      if (conversationId == widget.conversation.id && userId != widget.currentUserId) {
        setState(() {
          isTyping = true;
          typingUserId = userId;
        });
      }
    });
    socketService.onUserStopTyping((userId, conversationId) {
      if (conversationId == widget.conversation.id && userId != widget.currentUserId) {
        setState(() {
          isTyping = false;
          typingUserId = null;
        });
      }
    });

    fetchInitialMessages();
  }

  Future<void> fetchInitialMessages() async {
    final api = ChatApi();
    final fetched = await api.fetchMessages(widget.conversation.id ?? '');
    setState(() {
      messages = fetched;
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    socketService.leaveRoom(widget.conversation.id ?? '');
    socketService.disconnect();
    super.dispose();
  }

  void sendTyping() {
    if (!_hasSentTyping) {
      socketService.emitTypingStart(widget.conversation.id, widget.currentUserId);
      _hasSentTyping = true;
    }
  }

  void sendStopTyping() {
    if (_hasSentTyping) {
      socketService.emitTypingStop(widget.conversation.id, widget.currentUserId);
      _hasSentTyping = false;
    }
  }

  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      final msg = {
        'conversationId': widget.conversation.id,
        'senderId': widget.currentUserId,
        'content': _controller.text,
        'messageType': 'text',
        'createdAt': DateTime.now().toIso8601String(),
      };
      final api = ChatApi();
      api.sendMessage(widget.conversation.id??'',_controller.text,);
      setState(() {
        messages.add(ChatMessage.fromJson(msg));
      });
      _controller.clear();
      sendStopTyping();
    }
  }

  void _onInputChanged(String value) {
    if (value.isNotEmpty) {
      sendTyping();
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 2), () {
        sendStopTyping();
      });
    } else {
      sendStopTyping();
      _typingTimer?.cancel();
    }
  }

  String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} days ago';
  }

  bool isOtherParticipant(dynamic userId, String currentUserId) {
    if (userId is String) return userId != currentUserId;
    if (userId is ChatUser) return userId.id != currentUserId;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.conversation.avatar != null && widget.conversation.avatar!.isNotEmpty
                  ? NetworkImage(widget.conversation.avatar!)
                  : null,
              child: widget.conversation.avatar == null || widget.conversation.avatar!.isEmpty
                  ? Text(widget.conversation.name != null && widget.conversation.name!.isNotEmpty ? widget.conversation.name![0] : '?')
                  : null,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.conversation.name ?? 'Chat'),
                Builder(
                  builder: (context) {
                    final other = widget.conversation.participants.firstWhere(
                      (p) => isOtherParticipant(p.userId, widget.currentUserId),
                      orElse: () => Participant(userId: '', isActive: false),
                    );
                    if (other != null && other.isActive == true) {
                      return const Text('Online', style: TextStyle(fontSize: 12, color: Colors.green));
                    } else if (widget.conversation.lastActivity != null) {
                      return Text('Last seen ' + timeAgo(widget.conversation.lastActivity!), style: const TextStyle(fontSize: 12, color: Colors.grey));
                    } else {
                      return const Text('Offline', style: TextStyle(fontSize: 12, color: Colors.grey));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                if (isTyping)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Typing...', style: TextStyle(color: Colors.blue, fontStyle: FontStyle.italic)),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isOwn = message.sender?.id == widget.currentUserId;
                      final isRead = message.readBy.any((r) => r.userId == widget.currentUserId);
                      return Align(
                        alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isOwn ? Colors.blue[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(message.content ?? ''),
                              if (isOwn)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    isRead ? Icons.done_all : Icons.done,
                                    size: 16,
                                    color: isRead ? Colors.blue : Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: _onInputChanged,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type a message",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
