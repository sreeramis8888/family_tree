import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/notifiers/user_notifier.dart';
import 'package:familytree/src/interface/components/Dialogs/blockPersonDialog.dart';
import 'package:familytree/src/interface/components/Dialogs/report_dialog.dart';
import 'package:familytree/src/interface/components/DropDown/blockreport_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:familytree/src/data/api_routes/chat_api/chat_api.dart';
import 'package:familytree/src/data/models/chat_conversation_model.dart';
import 'package:familytree/src/data/models/chat_message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:familytree/src/data/services/socket_service.dart';
import 'package:familytree/src/data/models/chat_model.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:familytree/src/data/services/image_upload.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'dart:io';

class IndividualPage extends ConsumerStatefulWidget {
  final String conversationTitle;
  final String conversationImage;
  final ChatConversation conversation;
  final String currentUserId;
  final String? initialMessage;
  final String? initialImageUrl;
  const IndividualPage({
    required this.conversation,
    required this.currentUserId,
    this.initialMessage,
    this.initialImageUrl,
    Key? key,
    required this.conversationTitle,
    required this.conversationImage,
  }) : super(key: key);

  @override
  ConsumerState<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends ConsumerState<IndividualPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  List<ChatMessage> messages = [];
  late SocketService socketService;
  bool socketConnected = false;
  bool isTyping = false;
  String? typingUserId;
  bool _hasSentTyping = false;
  Timer? _typingTimer;
  ChatUser? otherUserId;
  String otherUserStatus = '';
  late AnimationController _sendButtonController;
  late AnimationController _typingController;
  late Animation<double> _sendButtonAnimation;
  late Animation<double> _typingAnimation;
  bool _isInputFocused = false;
  bool isBlocked = false;
  bool _showEmojiPicker = false;
  // bool _isRecording = false;
  final ImagePicker _imagePicker = ImagePicker();

  // String? _recordingPath;
  // Duration _recordingDuration = Duration.zero;
  // Timer? _recordingTimer;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final asyncUser = ref.watch(userProvider);
    asyncUser.whenData(
      (user) {
        if (!mounted) return;
        setState(() {
          if (user.blockedUsers != null) {
            isBlocked = user.blockedUsers!
                .any((blockedUser) => blockedUser.id == widget.currentUserId);
          }
        });
      },
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _typingController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _sendButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sendButtonController, curve: Curves.elasticOut),
    );

    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _typingController, curve: Curves.easeInOut),
    );

    // Focus node listener
    _focusNode.addListener(() {
      setState(() {
        _isInputFocused = _focusNode.hasFocus;
      });

      // Close emoji picker when text field gets focus
      if (_focusNode.hasFocus && _showEmojiPicker) {
        setState(() {
          _showEmojiPicker = false;
        });
      }
    });

    socketService = SocketService();
    socketService.connect();
    socketService.joinRoom(widget.conversation.id ?? '');
    socketService.onMessage((data) {
      if (data['conversationId'] == widget.conversation.id &&
          data['message'] != null) {
        final newMsg = ChatMessage.fromJson(data['message']);
        setState(() {
          messages.add(newMsg);
        });
        // Emit delivered if not own message
        if (newMsg.sender?.id != widget.currentUserId) {
          socketService.emitMessageDelivered(newMsg.id ?? '');
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });

    // Find the other participant's userId
    final other = widget.conversation.participants.firstWhere(
      (p) => isOtherParticipant(p.userId, widget.currentUserId),
      orElse: () => Participant(userId: ChatUser(), isActive: false),
    );
    otherUserId = other.userId;

    // Listen for presence updates for the other user
    socketService.onPresenceUpdate((userId, status) {
      if (userId == otherUserId) {
        setState(() {
          otherUserStatus = status;
        });
      }
    });

    socketService.onUserTyping((userId, conversationId) {
      if (conversationId == widget.conversation.id &&
          userId != widget.currentUserId) {
        setState(() {
          isTyping = true;
          typingUserId = userId;
        });
        _typingController.repeat(reverse: true);
      }
    });

    socketService.onUserStopTyping((userId, conversationId) {
      if (conversationId == widget.conversation.id &&
          userId != widget.currentUserId) {
        setState(() {
          isTyping = false;
          typingUserId = null;
        });
        _typingController.stop();
      }
    });

    fetchInitialMessages().then((_) async {
      if (widget.initialMessage != null || widget.initialImageUrl != null) {
        String content = widget.initialMessage ?? '';
        List<Map<String, dynamic>>? attachments;
        if (widget.initialImageUrl != null &&
            widget.initialImageUrl!.isNotEmpty) {
          attachments = [
            {
              'type': 'image',
              'url': widget.initialImageUrl,
            },
          ];
        }
        // Send the message only if not already sent (avoid duplicate on back navigation)
        if (content.isNotEmpty ||
            (attachments != null && attachments.isNotEmpty)) {
          await ChatApi().sendMessage(
            widget.conversation.id ?? '',
            content,
            messageType: attachments != null ? 'image' : 'text',
            attachments: attachments,
          );
        }
      }
    });
  }

  Future<void> fetchInitialMessages() async {
    final api = ChatApi();
    final fetched = await api.fetchMessages(widget.conversation.id ?? '');
    setState(() {
      messages = fetched;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Emit "message read" for unread messages
    for (final msg in fetched) {
      final isOwn = msg.sender?.id == widget.currentUserId;
      final alreadyRead =
          msg.readBy.any((r) => r.userId == widget.currentUserId);
      if (!isOwn && !alreadyRead && msg.id != null) {
        socketService.emitMessageRead(msg.id!);
      }
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    // _recordingTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _sendButtonController.dispose();
    _typingController.dispose();
    socketService.leaveRoom(widget.conversation.id ?? '');
    socketService.disconnect();
    super.dispose();
  }

  void sendTyping() {
    if (!_hasSentTyping) {
      socketService.emitTypingStart(
          widget.conversation.id, widget.currentUserId);
      _hasSentTyping = true;
    }
  }

  void sendStopTyping() {
    if (_hasSentTyping) {
      socketService.emitTypingStop(
          widget.conversation.id, widget.currentUserId);
      _hasSentTyping = false;
    }
  }

  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      // Haptic feedback
      HapticFeedback.lightImpact();

      final msg = {
        'conversationId': widget.conversation.id,
        'senderId': widget.currentUserId,
        'content': _controller.text,
        'messageType': 'text',
        'createdAt': DateTime.now().toIso8601String(),
      };
      final api = ChatApi();
      api.sendMessage(
        widget.conversation.id ?? '',
        _controller.text,
      );
      setState(() {
        messages.add(ChatMessage.fromJson(msg));
      });
      _controller.clear();
      sendStopTyping();
      _sendButtonController.reverse();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  // Camera functionality
  Future<void> _takePicture() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        await _uploadAndSendImage(image.path);
      }
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  // Gallery functionality
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        await _uploadAndSendImage(image.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Upload and send image
  Future<void> _uploadAndSendImage(String imagePath) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Upload image
      final imageUrl = await imageUpload(imagePath);

      // Close loading dialog
      Navigator.pop(context);

      // Send message with image
      final api = ChatApi();
      await api.sendMessage(
        widget.conversation.id ?? '',
        'Image',
        messageType: 'image',
        attachments: [
          {
            'type': 'image',
            'url': imageUrl,
          },
        ],
      );

      // Add message to local list
      final msg = {
        'conversationId': widget.conversation.id,
        'senderId': widget.currentUserId,
        'content': 'Image',
        'messageType': 'image',
        'attachments': [
          {
            'type': 'image',
            'url': imageUrl,
          },
        ],
        'createdAt': DateTime.now().toIso8601String(),
      };

      setState(() {
        messages.add(ChatMessage.fromJson(msg));
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image')),
      );
    }
  }

  // Audio recording functionality with WhatsApp-like UI
  // Future<void> _startRecording() async {
  //   try {
  //     // Request microphone permission
  //     final status = await Permission.microphone.request();
  //     if (status != PermissionStatus.granted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Microphone permission required')),
  //       );
  //       return;
  //     }

  //     setState(() {
  //       _isRecording = true;
  //       _recordingDuration = Duration.zero;
  //     });

  //     // Start recording timer
  //     _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
  //       setState(() {
  //         _recordingDuration += Duration(seconds: 1);
  //       });
  //     });

  //     // Show recording UI
  //     _showRecordingUI();
  //   } catch (e) {
  //     print('Error starting recording: $e');
  //   }
  // }

  // void _showRecordingUI() {
  //   showModalBottomSheet(
  //     context: context,
  //     isDismissible: false,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => Container(
  //       height: 200,
  //       decoration: BoxDecoration(
  //         color: kWhite,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: Column(
  //         children: [
  //           Container(
  //             padding: EdgeInsets.all(16),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //               Text('Recording...', style: kBodyTitleB),
  //               Text(
  //                 '${_recordingDuration.inMinutes}:${(_recordingDuration.inSeconds % 60).toString().padLeft(2, '0')}',
  //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //               ),
  //             ],
  //           ),
  //           Expanded(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //               Container(
  //                 width: 80,
  //                 height: 80,
  //                 decoration: BoxDecoration(
  //                   color: kRed,
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: Icon(
  //                   Icons.mic,
  //                   color: kWhite,
  //                   size: 40,
  //                 ),
  //               ),
  //               SizedBox(height: 16),
  //               Text(
  //                 'Slide to cancel',
  //                 style: TextStyle(color: kGreyDark),
  //               ),
  //             ],
  //           ),
  //           Container(
  //             padding: EdgeInsets.all(16),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //               Expanded(
  //                 child: GestureDetector(
  //                   onTap: _cancelRecording,
  //                   child: Container(
  //                 padding: EdgeInsets.symmetric(vertical: 12),
  //                 decoration: BoxDecoration(
  //                   color: kGrey,
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Center(
  //                   child: Text('Cancel', style: TextStyle(color: kBlack)),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 16),
  //             Expanded(
  //               child: GestureDetector(
  //                 onTap: _stopRecording,
  //                 child: Container(
  //                 padding: EdgeInsets.symmetric(vertical: 12),
  //                 decoration: BoxDecoration(
  //                   color: kRed,
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Center(
  //                   child: Text('Stop', style: TextStyle(color: kWhite)),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _cancelRecording() {
  //   setState(() {
  //     _isRecording = false;
  //     _recordingDuration = Duration.zero;
  //   });
  //   _recordingTimer?.cancel();
  //   Navigator.pop(context);
  // }

  // Future<void> _stopRecording() async {
  //   try {
  //     setState(() {
  //       _isRecording = false;
  //     });

  //     _recordingTimer?.cancel();
  //     Navigator.pop(context);

  //     // Create a simple audio file for demonstration
  //     final tempDir = await Directory.systemTemp.createTemp();
  //     final audioFile = File('${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav');

  //     // Create a simple WAV file header (minimal valid WAV file)
  //     final wavHeader = [
  //       0x52, 0x49, 0x46, 0x46, // RIFF
  //       0x24, 0x00, 0x00, 0x00, // File size - 36
  //       0x57, 0x41, 0x56, 0x45, // WAVE
  //       0x66, 0x6D, 0x74, 0x20, // fmt
  //       0x10, 0x00, 0x00, 0x00, // Chunk size
  //       0x01, 0x00, // Audio format (PCM)
  //       0x01, 0x00, // Channels (1)
  //       0x44, 0xAC, 0x00, 0x00, // Sample rate (44100)
  //       0x88, 0x58, 0x01, 0x00, // Byte rate
  //       0x02, 0x00, // Block align
  //       0x10, 0x00, // Bits per sample
  //       0x64, 0x61, 0x74, 0x61, // data
  //       0x00, 0x00, 0x00, 0x00  // Data size (0 for silence)
  //     ];

  //     await audioFile.writeAsBytes(wavHeader);

  //     // Show loading indicator
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     );

  //     try {
  //       // Upload audio file using the image_upload service
  //       final audioUrl = await audioUpload(audioFile.path);

  //       // Close loading dialog
  //       Navigator.pop(context);

  //       // Send message with audio attachment
  //       final durationText = '${_recordingDuration.inMinutes}:${(_recordingDuration.inSeconds % 60).toString().padLeft(2, '0')}';
  //       final api = ChatApi();
  //       await api.sendMessage(
  //         widget.conversation.id ?? '',
  //         'Audio message',
  //         messageType: 'audio',
  //         attachments: [
  //           {
  //             'type': 'audio',
  //             'url': audioUrl,
  //           },
  //         ],
  //       );

  //       // Add message to local list
  //       final msg = {
  //         'conversationId': widget.conversation.id,
  //         'senderId': widget.currentUserId,
  //         'content': 'Audio message',
  //         'messageType': 'audio',
  //         'attachments': [
  //           {
  //             'type': 'audio',
  //             'url': audioUrl,
  //           },
  //         ],
  //         'createdAt': DateTime.now().toIso8601String(),
  //       };

  //       setState(() {
  //         messages.add(ChatMessage.fromJson(msg));
  //       });

  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         _scrollToBottom();
  //       });
  //     } catch (e) {
  //       // Close loading dialog if still open
  //       if (Navigator.canPop(context)) {
  //         Navigator.pop(context);
  //       }
  //       print('Error uploading audio: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to upload audio')),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error stopping recording: $e');
  //   }
  // }

  Future<void> _uploadAndSendAudio(String audioPath) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Upload audio file (you'll need to implement audio upload)
      // For now, we'll just send a placeholder
      final api = ChatApi();
      await api.sendMessage(
        widget.conversation.id ?? '',
        'Audio message',
        messageType: 'audio',
        attachments: [
          {
            'type': 'audio',
            'url': audioPath, // This should be the uploaded URL
          },
        ],
      );

      // Close loading dialog
      Navigator.pop(context);

      // Add message to local list
      final msg = {
        'conversationId': widget.conversation.id,
        'senderId': widget.currentUserId,
        'content': 'Audio message',
        'messageType': 'audio',
        'attachments': [
          {
            'type': 'audio',
            'url': audioPath,
          },
        ],
        'createdAt': DateTime.now().toIso8601String(),
      };

      setState(() {
        messages.add(ChatMessage.fromJson(msg));
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      print('Error uploading audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload audio')),
      );
    }
  }

  // Emoji picker functionality
  void _onEmojiSelected(Category? category, Emoji emoji) {
    setState(() {
      _controller.text += emoji.emoji;
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });

    // Hide keyboard when emoji picker is shown
    if (_showEmojiPicker) {
      _focusNode.unfocus();
    }
  }

  // Show attachment options
  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: kPrimaryColor),
              title: Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: kPrimaryColor),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _takePicture();
              },
            ),
            ListTile(
              leading: Icon(Icons.mic, color: kPrimaryColor),
              title: Text('Audio'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Audio recording is disabled')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiPicker() {
    if (!_showEmojiPicker) return SizedBox.shrink();

    return Expanded(
      child: EmojiPicker(
        onEmojiSelected: _onEmojiSelected,
        config: Config(
          categoryViewConfig: CategoryViewConfig(
            backgroundColor: kWhite,
            dividerColor: kPrimaryLightColor,
            indicatorColor: kPrimaryColor,
            iconColor: kGrey,
            iconColorSelected: kPrimaryColor,
            backspaceColor: kPrimaryColor,
            categoryIcons: const CategoryIcons(),
            tabIndicatorAnimDuration: Duration(milliseconds: 300),
          ),
          skinToneConfig: SkinToneConfig(
            dialogBackgroundColor: kWhite,
            indicatorColor: kWhite,
          ),
          height: 200,
          bottomActionBarConfig: BottomActionBarConfig(
              backgroundColor: kPrimaryLightColor, buttonColor: kPrimaryColor),
          checkPlatformCompatibility: true,
        ),
      ),
    );
  }

  void _onInputChanged(String value) {
    if (value.isNotEmpty) {
      if (!_sendButtonController.isCompleted) {
        _sendButtonController.forward();
      }
      sendTyping();
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 2), () {
        sendStopTyping();
      });
    } else {
      if (_sendButtonController.isCompleted) {
        _sendButtonController.reverse();
      }
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

  Widget _buildStatusIndicator() {
    Color statusColor;
    switch (otherUserStatus) {
      case 'online':
        statusColor = kGreen;
        break;
      case 'away':
      case 'busy':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = kGreyDark;
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: statusColor,
        shape: BoxShape.circle,
        border: Border.all(color: kGrey, width: 2),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return AnimatedBuilder(
      animation: _typingAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: kGrey,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(3, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  margin: const EdgeInsets.only(right: 3),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: kGreyDark
                        .withOpacity(0.5 + (_typingAnimation.value * 0.5)),
                    shape: BoxShape.circle,
                  ),
                );
              }),
              const SizedBox(width: 8),
              Text(
                'typing...',
                style: TextStyle(
                  color: kGreyDark,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isOwn, String time) {
    bool isDelivered = false;
    bool isRead = false;
    if (isOwn) {
      isDelivered =
          message.deliveredTo.any((d) => d.userId != widget.currentUserId);
      isRead = message.readBy.any((r) => r.userId != widget.currentUserId);
    }

    // Display attachments if present
    List<Widget> attachmentWidgets = [];
    if (message.attachments.isNotEmpty) {
      for (final att in message.attachments) {
        if (att.type == 'image' && att.url.isNotEmpty) {
          attachmentWidgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GestureDetector(
                onTap: () {
                  // Optionally implement fullscreen view
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: InteractiveViewer(
                        child: Image.network(att.url),
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    att.url,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        } else if (att.type == 'audio' && att.url.isNotEmpty) {
          attachmentWidgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kTertiary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, color: kPrimaryColor),
                    SizedBox(width: 8),
                    Text('Audio Message', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }

    return Container(
      margin: EdgeInsets.only(
        left: isOwn ? 64 : 16,
        right: isOwn ? 16 : 64,
        top: 2,
        bottom: 2,
      ),
      child: Align(
        alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isOwn ? kSecondaryColor : kWhite,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isOwn ? 18 : 4),
              bottomRight: Radius.circular(isOwn ? 4 : 18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Show images first
              ...attachmentWidgets,
              // Then text content
              if ((message.content ?? '').isNotEmpty)
                Text(
                  message.content ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: kBlack.withOpacity(0.85),
                    height: 1.3,
                  ),
                ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11,
                      color: kGreyDark,
                    ),
                  ),
                  if (isOwn) ...[
                    const SizedBox(width: 4),
                    Icon(
                      isRead
                          ? Icons.done_all
                          : isDelivered
                              ? Icons.done_all
                              : Icons.done,
                      size: 14,
                      color: isRead ? kGreen : kGreyDark,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = widget.conversation.participants[1].userId ?? ChatUser();
    List<ChatMessage> sortedMessages = List.from(messages)
      ..sort((a, b) {
        final aTime = a.createdAt is DateTime
            ? a.createdAt as DateTime
            : (a.createdAt != null
                    ? DateTime.tryParse(a.createdAt.toString())
                    : null) ??
                DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.createdAt is DateTime
            ? b.createdAt as DateTime
            : (b.createdAt != null
                    ? DateTime.tryParse(b.createdAt.toString())
                    : null) ??
                DateTime.fromMillisecondsSinceEpoch(0);
        return aTime.compareTo(bTime);
      });

    return Scaffold(
      backgroundColor: kTertiary,
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            color: kWhite,
            icon: const Icon(
              Icons.more_vert,
              color: kWhite,
            ),
            onSelected: (value) {
              if (value == 'report') {
                showReportPersonDialog(
                  context: context,
                  onReportStatusChanged: () {},
                  reportType: 'Users',
                  reportedItemId: widget.currentUserId ?? '',
                );
              } else if (value == 'block') {
                showBlockPersonDialog(
                  context: context,
                  userId: widget.currentUserId ?? '',
                  onBlockStatusChanged: () {
                    Future.delayed(const Duration(seconds: 1), () {
                      if (!mounted) return;
                      setState(() {
                        isBlocked = !isBlocked;
                      });
                    });
                  },
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.report, color: kPrimaryColor),
                    SizedBox(width: 8),
                    Text(
                      'Report',
                      style: kSmallTitleR,
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(height: 1),
              PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block),
                    SizedBox(width: 8),
                    isBlocked
                        ? Text(
                            'Unblock',
                            style: kSmallTitleR,
                          )
                        : Text(
                            'Block',
                            style: kSmallTitleR,
                          ),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            offset: const Offset(0, 40),
          )
        ],
        elevation: 0,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: kGrey,
                  backgroundImage: widget.conversationImage != '' &&
                          widget.conversationImage.isNotEmpty
                      ? NetworkImage(otherUser.image!)
                      : null,
                ),
                if (otherUserStatus == 'online')
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: _buildStatusIndicator(),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversationTitle ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kWhite,
                    ),
                  ),
                  // const SizedBox(height: 2),
                  // Text(
                  //   overflow: TextOverflow.ellipsis,
                  //   maxLines: 2,
                  //   otherUserStatus.isNotEmpty
                  //       ? otherUserStatus[0].toUpperCase() +
                  //           otherUserStatus.substring(1)
                  //       : (widget.conversation.lastActivity != null
                  //           ? 'Last seen ' +
                  //               timeAgo(widget.conversation.lastActivity!)
                  //           : 'Offline'),
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     color: kWhite.withOpacity(0.8),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  if (isTyping) _buildTypingIndicator(),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: sortedMessages.length,
                      itemBuilder: (context, index) {
                        final message = sortedMessages[index];
                        final isOwn =
                            message.sender?.id == widget.currentUserId;

                        // Format time
                        String time = '';
                        if (message.createdAt != null) {
                          final dt = message.createdAt is DateTime
                              ? message.createdAt as DateTime
                              : DateTime.tryParse(
                                      message.createdAt.toString()) ??
                                  DateTime.fromMillisecondsSinceEpoch(0);
                          time = DateFormat('h:mm a').format(dt.toLocal());
                        }

                        return _buildMessageBubble(message, isOwn, time);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: kTertiary,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: _isInputFocused
                                ? kPrimaryColor.withOpacity(0.3)
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.emoji_emotions_outlined,
                                  color: kInputFieldcolor),
                              onPressed: _toggleEmojiPicker,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                onChanged: _onInputChanged,
                                maxLines: 5,
                                minLines: 1,
                                style: const TextStyle(fontSize: 16),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                  hintStyle: TextStyle(color: kInputFieldcolor),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.attach_file,
                                  color: kInputFieldcolor),
                              onPressed: () {
                                _showAttachmentOptions();
                              },
                            ),
                            if (_controller.text.isEmpty)
                              IconButton(
                                icon: Icon(Icons.camera_alt,
                                    color: kInputFieldcolor),
                                onPressed: _takePicture,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: kWhite,
                          size: 20,
                        ),
                        onPressed: sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Emoji picker
            _buildEmojiPicker(),
          ],
        ),
      ),
    );
  }
}
