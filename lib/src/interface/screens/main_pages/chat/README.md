# Chat Module Documentation

## Overview

The Chat Module provides comprehensive real-time messaging functionality for the Family Tree application, supporting one-to-one chats, group chats, and family-specific conversations with advanced features like read receipts, typing indicators, and message management.

## Features

### Core Functionality

- **One-to-One Chat**: Direct messaging between family members
- **Group Chat**: Custom group conversations with multiple participants
- **Family Chat**: Family-specific group conversations
- **Real-time Messaging**: Instant message delivery using Socket.io
- **Read Receipts**: Blue tick indicators for read messages
- **Delivery Status**: Message delivery confirmation
- **Typing Indicators**: Real-time typing status
- **User Presence**: Online/offline status tracking

### Message Features

- **Text Messages**: Standard text messaging
- **Media Support**: Images, videos, audio, documents
- **Location Sharing**: GPS location sharing
- **Reply to Messages**: Quote and reply functionality
- **Edit Messages**: Edit sent messages (within 24 hours)
- **Delete Messages**: Delete for self or everyone
- **Message Search**: Search within conversations

### Group Management

- **Create Groups**: Create custom groups or family-based groups
- **Add/Remove Participants**: Manage group membership
- **Admin Controls**: Group admin permissions
- **Group Settings**: Configure group behavior
- **System Messages**: Automated group activity notifications

## Database Schema

### Conversation Schema

```javascript
{
  type: "direct" | "group" | "family",
  name: String, // Group name
  description: String,
  avatar: String,
  participants: [{
    userId: ObjectId,
    role: "admin" | "member",
    joinedAt: Date,
    leftAt: Date,
    isActive: Boolean,
    lastSeenMessageId: ObjectId
  }],
  familyId: ObjectId, // For family conversations
  createdBy: ObjectId,
  lastMessage: ObjectId,
  lastActivity: Date,
  settings: {
    allowMembersToAddOthers: Boolean,
    onlyAdminsCanSend: Boolean,
    disappearingMessages: {
      enabled: Boolean,
      duration: Number
    }
  }
}
```

### Message Schema

```javascript
{
  conversationId: ObjectId,
  senderId: ObjectId,
  content: String,
  messageType: "text" | "image" | "video" | "audio" | "document" | "location" | "system",
  attachments: [{
    type: String,
    url: String,
    filename: String,
    size: Number,
    mimeType: String,
    thumbnail: String,
    duration: Number,
    location: {
      latitude: Number,
      longitude: Number,
      address: String
    }
  }],
  replyTo: ObjectId,
  readBy: [{
    userId: ObjectId,
    readAt: Date
  }],
  deliveredTo: [{
    userId: ObjectId,
    deliveredAt: Date
  }],
  edited: {
    isEdited: Boolean,
    editedAt: Date,
    originalContent: String
  },
  deleted: {
    isDeleted: Boolean,
    deletedAt: Date,
    deletedBy: ObjectId,
    deletedFor: "sender" | "everyone"
  }
}
```

## API Endpoints

### Authentication

All endpoints require authentication via JWT token in the Authorization header:

```
Authorization: Bearer <jwt_token>
```

### Conversation Endpoints

#### GET /api/v1/chat/conversations

Get user's conversations with pagination and filtering.

**Query Parameters:**

- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 20, max: 100)
- `type` (string): Filter by conversation type ("direct", "group", "family")
- `search` (string): Search conversations by name

**Response:**

```javascript
{
  "success": true,
  "message": "Conversations fetched successfully",
  "data": [
    {
      "_id": "conversationId",
      "type": "direct",
      "name": "John Doe",
      "participants": [...],
      "lastMessage": {...},
      "lastActivity": "2024-01-15T10:30:00Z",
      "unreadCount": 5
    }
  ]
}
```

#### GET /api/v1/chat/conversations/direct/:recipientId

Get or create a direct conversation with a specific user.

**Response:**

```javascript
{
  "success": true,
  "message": "Direct conversation retrieved",
  "data": {
    "_id": "conversationId",
    "type": "direct",
    "participants": [...]
  }
}
```

#### POST /api/v1/chat/conversations/group

Create a new group conversation.

**Request Body:**

```javascript
{
  "name": "Family Group",
  "description": "Our family chat group",
  "participantIds": ["userId1", "userId2"],
  "familyId": "familyId" // Optional, for family groups
}
```

### Message Endpoints

#### GET /api/v1/chat/conversations/:conversationId/messages

Get messages for a conversation.

**Query Parameters:**

- `page` (number): Page number
- `limit` (number): Items per page (max: 100)

#### POST /api/v1/chat/conversations/:conversationId/messages

Send a new message.

**Request Body:**

```javascript
{
  "content": "Hello everyone!",
  "messageType": "text",
  "attachments": [
    {
      "type": "image",
      "url": "https://example.com/image.jpg",
      "filename": "photo.jpg"
    }
  ],
  "replyTo": "messageId" // Optional
}
```

#### PUT /api/v1/chat/conversations/:conversationId/messages/read

Mark messages as read.

**Request Body:**

```javascript
{
  "messageIds": ["messageId1", "messageId2"]
}
```

#### PUT /api/v1/chat/messages/:messageId

Edit a message.

**Request Body:**

```javascript
{
  "content": "Updated message content"
}
```

#### DELETE /api/v1/chat/messages/:messageId

Delete a message.

**Request Body:**

```javascript
{
  "deleteFor": "sender" // or "everyone"
}
```

## Socket.io Events

### Connection

```javascript
// Client connects with JWT token
const socket = io("http://localhost:3000", {
  auth: {
    token: "jwt_token_here",
  },
});
```

### Events to Emit (Client -> Server)

#### typing_start

```javascript
socket.emit("typing_start", {
  conversationId: "conversationId",
});
```

#### typing_stop

```javascript
socket.emit("typing_stop", {
  conversationId: "conversationId",
});
```

#### join_conversation

```javascript
socket.emit("join_conversation", {
  conversationId: "conversationId",
});
```

#### message_delivered

```javascript
socket.emit("message_delivered", {
  messageId: "messageId",
});
```

#### message_read

```javascript
socket.emit("message_read", {
  messageId: "messageId",
});
```

### Events to Listen (Server -> Client)

#### new_message

```javascript
socket.on("new_message", (data) => {
  // data: { conversationId, message }
});
```

#### messages_read

```javascript
socket.on("messages_read", (data) => {
  // data: { conversationId, messageIds, readBy }
});
```

#### user_typing

```javascript
socket.on("user_typing", (data) => {
  // data: { userId, userName, conversationId }
});
```

#### user_status_update

```javascript
socket.on("user_status_update", (data) => {
  // data: { userId, status, lastSeen }
});
```

#### new_conversation

```javascript
socket.on("new_conversation", (conversation) => {
  // New conversation created
});
```

## Frontend Integration Examples

### Flutter Integration

#### Dependencies

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  socket_io_client: ^2.0.3+1
  http: ^1.1.0
  provider: ^6.1.1 # or your preferred state management
  shared_preferences: ^2.2.2
```

#### Flutter Chat Service

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static const String baseUrl = 'http://your-api-url.com/api/v1';
  IO.Socket? socket;
  String? _token;

  // Initialize socket connection
  Future<void> initializeSocket() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');

    if (_token == null) return;

    socket = IO.io('http://your-api-url.com',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .setAuth({'token': _token})
        .build()
    );

    socket?.connect();

    // Listen for connection
    socket?.onConnect((_) {
      print('Connected to chat server');
    });

    // Listen for new messages
    socket?.on('new_message', (data) {
      _handleNewMessage(data);
    });

    // Listen for read receipts
    socket?.on('messages_read', (data) {
      _handleMessagesRead(data);
    });

    // Listen for typing indicators
    socket?.on('user_typing', (data) {
      _handleUserTyping(data);
    });

    // Listen for user status updates
    socket?.on('user_status_update', (data) {
      _handleUserStatusUpdate(data);
    });
  }

  // Send message via API
  Future<Map<String, dynamic>?> sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
    List<Map<String, dynamic>>? attachments,
    String? replyTo,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/conversations/$conversationId/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'content': content,
          'messageType': messageType,
          'attachments': attachments ?? [],
          if (replyTo != null) 'replyTo': replyTo,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error sending message: $e');
      return null;
    }
  }

  // Get conversations
  Future<List<dynamic>?> getConversations({
    int page = 1,
    int limit = 20,
    String? type,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (type != null) 'type': type,
        if (search != null) 'search': search,
      };

      final uri = Uri.parse('$baseUrl/chat/conversations')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching conversations: $e');
      return null;
    }
  }

  // Get messages for conversation
  Future<List<dynamic>?> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse('$baseUrl/chat/conversations/$conversationId/messages')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching messages: $e');
      return null;
    }
  }

  // Mark messages as read
  Future<bool> markMessagesAsRead({
    required String conversationId,
    required List<String> messageIds,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/chat/conversations/$conversationId/messages/read'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'messageIds': messageIds,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error marking messages as read: $e');
      return false;
    }
  }

  // Create group conversation
  Future<Map<String, dynamic>?> createGroupConversation({
    required String name,
    String? description,
    required List<String> participantIds,
    String? familyId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/conversations/group'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'participantIds': participantIds,
          if (familyId != null) 'familyId': familyId,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error creating group: $e');
      return null;
    }
  }

  // Get or create direct conversation
  Future<Map<String, dynamic>?> getOrCreateDirectConversation(String recipientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chat/conversations/direct/$recipientId'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error getting direct conversation: $e');
      return null;
    }
  }

  // Socket event handlers
  void _handleNewMessage(dynamic data) {
    // Update UI with new message
    print('New message received: $data');
  }

  void _handleMessagesRead(dynamic data) {
    // Update read receipts in UI
    print('Messages marked as read: $data');
  }

  void _handleUserTyping(dynamic data) {
    // Show typing indicator
    print('User typing: $data');
  }

  void _handleUserStatusUpdate(dynamic data) {
    // Update user online status
    print('User status update: $data');
  }

  // Emit typing events
  void startTyping(String conversationId) {
    socket?.emit('typing_start', {'conversationId': conversationId});
  }

  void stopTyping(String conversationId) {
    socket?.emit('typing_stop', {'conversationId': conversationId});
  }

  // Join conversation room
  void joinConversation(String conversationId) {
    socket?.emit('join_conversation', {'conversationId': conversationId});
  }

  // Disconnect socket
  void disconnect() {
    socket?.disconnect();
  }
}
```

#### Flutter Chat Provider (State Management)

```dart
import 'package:flutter/foundation.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<dynamic> _conversations = [];
  Map<String, List<dynamic>> _messages = {};
  Map<String, bool> _typingUsers = {};

  List<dynamic> get conversations => _conversations;
  Map<String, List<dynamic>> get messages => _messages;
  Map<String, bool> get typingUsers => _typingUsers;

  Future<void> initializeChat() async {
    await _chatService.initializeSocket();
    await loadConversations();
  }

  Future<void> loadConversations() async {
    final conversations = await _chatService.getConversations();
    if (conversations != null) {
      _conversations = conversations;
      notifyListeners();
    }
  }

  Future<void> loadMessages(String conversationId) async {
    final messages = await _chatService.getMessages(conversationId: conversationId);
    if (messages != null) {
      _messages[conversationId] = messages;
      notifyListeners();
    }
  }

  Future<void> sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
  }) async {
    final result = await _chatService.sendMessage(
      conversationId: conversationId,
      content: content,
      messageType: messageType,
    );

    if (result != null) {
      // Message sent successfully, it will be received via socket
    }
  }

  Future<void> markAsRead(String conversationId, List<String> messageIds) async {
    await _chatService.markMessagesAsRead(
      conversationId: conversationId,
      messageIds: messageIds,
    );
  }

  void startTyping(String conversationId) {
    _chatService.startTyping(conversationId);
  }

  void stopTyping(String conversationId) {
    _chatService.stopTyping(conversationId);
  }
}
```

#### Flutter Chat UI Components

##### Conversation List Screen

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationListScreen extends StatefulWidget {
  @override
  _ConversationListScreenState createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          final conversations = chatProvider.conversations;

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ConversationTile(conversation: conversation);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewChatDialog(),
        child: Icon(Icons.chat),
      ),
    );
  }

  void _showNewChatDialog() {
    // Show dialog to create new chat or group
  }
}

class ConversationTile extends StatelessWidget {
  final Map<String, dynamic> conversation;

  ConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final unreadCount = conversation['unreadCount'] ?? 0;
    final lastMessage = conversation['lastMessageDetail'];

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: conversation['avatar'] != null
          ? NetworkImage(conversation['avatar'])
          : null,
        child: conversation['avatar'] == null
          ? Text(conversation['name'][0].toUpperCase())
          : null,
      ),
      title: Text(
        conversation['name'] ?? 'Unknown',
        style: TextStyle(
          fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        lastMessage?['content'] ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (unreadCount > 0)
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unreadCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              conversationId: conversation['_id'],
              conversationName: conversation['name'],
            ),
          ),
        );
      },
    );
  }
}
```

##### Chat Screen

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String conversationName;

  ChatScreen({required this.conversationId, required this.conversationName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatProvider>().loadMessages(widget.conversationId);
    context.read<ChatProvider>().joinConversation(widget.conversationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversationName),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // Video call functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Voice call functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                final messages = chatProvider.messages[widget.conversationId] ?? [];

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 1)],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () {
              // Show attachment options
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onChanged: (text) {
                if (text.isNotEmpty) {
                  context.read<ChatProvider>().startTyping(widget.conversationId);
                } else {
                  context.read<ChatProvider>().stopTyping(widget.conversationId);
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      context.read<ChatProvider>().sendMessage(
        conversationId: widget.conversationId,
        content: content,
      );
      _messageController.clear();
      context.read<ChatProvider>().stopTyping(widget.conversationId);
    }
  }
}

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMyMessage = message['senderId']['_id'] == 'current_user_id'; // Replace with actual user ID
    final isRead = (message['readBy'] as List).isNotEmpty;
    final isDelivered = (message['deliveredTo'] as List).isNotEmpty;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMyMessage)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(message['senderId']['image'] ?? ''),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMyMessage ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['content'],
                    style: TextStyle(
                      color: isMyMessage ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message['createdAt']),
                        style: TextStyle(
                          fontSize: 12,
                          color: isMyMessage ? Colors.white70 : Colors.grey,
                        ),
                      ),
                      if (isMyMessage) ...[
                        SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 16,
                          color: isRead ? Colors.blue : Colors.grey,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMyMessage) SizedBox(width: 8),
          if (isMyMessage)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(message['senderId']['image'] ?? ''),
            ),
        ],
      ),
    );
  }

  String _formatTime(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
```

#### App Integration

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Family Tree Chat',
        home: ConversationListScreen(),
      ),
    );
  }
}
```

### React Hook for Chat

```javascript
import { useEffect, useState } from "react";
import io from "socket.io-client";

export const useChat = (token) => {
  const [socket, setSocket] = useState(null);
  const [messages, setMessages] = useState([]);
  const [onlineUsers, setOnlineUsers] = useState([]);

  useEffect(() => {
    const newSocket = io("http://localhost:3000", {
      auth: { token },
    });

    // Listen for new messages
    newSocket.on("new_message", (data) => {
      setMessages((prev) => [...prev, data.message]);
    });

    // Listen for read receipts
    newSocket.on("messages_read", (data) => {
      setMessages((prev) =>
        prev.map((msg) =>
          data.messageIds.includes(msg._id)
            ? {
                ...msg,
                readBy: [
                  ...msg.readBy,
                  { userId: data.readBy, readAt: new Date() },
                ],
              }
            : msg
        )
      );
    });

    setSocket(newSocket);

    return () => newSocket.close();
  }, [token]);

  const sendMessage = (conversationId, content) => {
    // Make API call to send message
    fetch(`/api/v1/chat/conversations/${conversationId}/messages`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ content, messageType: "text" }),
    });
  };

  const markAsRead = (conversationId, messageIds) => {
    fetch(`/api/v1/chat/conversations/${conversationId}/messages/read`, {
      method: "PUT",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ messageIds }),
    });
  };

  return { socket, messages, sendMessage, markAsRead };
};
```

### Message Component with Read Receipts

```javascript
const MessageItem = ({ message, currentUserId }) => {
  const isMyMessage = message.senderId._id === currentUserId;
  const isRead = message.readBy.some((r) => r.userId !== currentUserId);
  const isDelivered = message.deliveredTo.length > 0;

  return (
    <div className={`message ${isMyMessage ? "my-message" : "other-message"}`}>
      <div className="message-content">{message.content}</div>
      {isMyMessage && (
        <div className="message-status">
          {isRead ? (
            <span className="read-receipt">✓✓</span> // Blue double tick
          ) : isDelivered ? (
            <span className="delivered">✓✓</span> // Gray double tick
          ) : (
            <span className="sent">✓</span> // Single tick
          )}
        </div>
      )}
    </div>
  );
};
```

## Security Considerations

1. **Authentication**: All Socket.io connections are authenticated using JWT tokens
2. **Authorization**: Users can only access conversations they're participants in
3. **Message Validation**: All message content is validated and sanitized
4. **Rate Limiting**: Consider implementing rate limiting for message sending
5. **Media Upload**: Validate and sanitize all media uploads
6. **Privacy**: Respect user privacy settings and blocked users list

## Performance Optimization

1. **Pagination**: Messages are paginated to reduce load times
2. **Indexing**: Database indexes on frequently queried fields
3. **Socket Rooms**: Efficient socket room management for conversations
4. **Message Cleanup**: Consider implementing message retention policies
5. **Media Optimization**: Compress and optimize media files

## Error Handling

All API endpoints return consistent error responses:

```javascript
{
  "success": false,
  "message": "Error description",
  "error": {
    "code": "ERROR_CODE",
    "details": "Additional error details"
  }
}
```

Common error codes:

- `CONVERSATION_NOT_FOUND`: Conversation doesn't exist
- `ACCESS_DENIED`: User doesn't have permission
- `MESSAGE_NOT_FOUND`: Message doesn't exist
- `VALIDATION_ERROR`: Invalid input data
- `RATE_LIMIT_EXCEEDED`: Too many requests

## API Usage Flow

### Chat Integration Workflow

#### 1. Authentication & Initialization

```dart
// 1. Store JWT token after login
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', jwtToken);

// 2. Initialize chat service
ChatService chatService = ChatService();
await chatService.initializeSocket();
```

#### 2. Loading Conversations

```dart
// Fetch user's conversations
final conversations = await chatService.getConversations(
  page: 1,
  limit: 20,
  type: 'direct', // or 'group', 'family'
);

// Display in conversation list UI
```

#### 3. Opening a Chat

```dart
// For direct conversation
final conversation = await chatService.getOrCreateDirectConversation(recipientId);

// For group/family conversation (if exists)
final conversationId = 'existing_conversation_id';

// Load messages for the conversation
final messages = await chatService.getMessages(
  conversationId: conversationId,
  page: 1,
  limit: 50,
);

// Join socket room for real-time updates
chatService.joinConversation(conversationId);
```

#### 4. Sending Messages

```dart
// Send text message
await chatService.sendMessage(
  conversationId: conversationId,
  content: 'Hello!',
  messageType: 'text',
);

// Send image message
await chatService.sendMessage(
  conversationId: conversationId,
  content: 'Check this photo',
  messageType: 'image',
  attachments: [
    {
      'type': 'image',
      'url': 'https://example.com/image.jpg',
      'filename': 'photo.jpg',
    }
  ],
);

// Reply to message
await chatService.sendMessage(
  conversationId: conversationId,
  content: 'Thanks!',
  replyTo: 'original_message_id',
);
```

#### 5. Read Receipts Implementation

```dart
// Mark messages as read when user views them
await chatService.markMessagesAsRead(
  conversationId: conversationId,
  messageIds: ['msg1', 'msg2', 'msg3'],
);

// Listen for read receipt updates via socket
socket?.on('messages_read', (data) {
  // Update UI to show blue ticks
  final conversationId = data['conversationId'];
  final messageIds = data['messageIds'];
  final readBy = data['readBy'];

  // Update message status in UI
});
```

#### 6. Real-time Features

```dart
// Typing indicators
chatService.startTyping(conversationId); // When user starts typing
chatService.stopTyping(conversationId);  // When user stops typing

// Listen for typing events
socket?.on('user_typing', (data) {
  // Show "User is typing..." indicator
});

socket?.on('user_stop_typing', (data) {
  // Hide typing indicator
});

// User presence
socket?.on('user_status_update', (data) {
  // Update online/offline status
  final userId = data['userId'];
  final status = data['status']; // 'online', 'offline'
});
```

#### 7. Group Management

```dart
// Create group
await chatService.createGroupConversation(
  name: 'Family Group',
  description: 'Our family chat',
  participantIds: ['user1', 'user2', 'user3'],
  familyId: 'family_id', // Optional for family groups
);

// Add participants (admin only)
await http.post(
  Uri.parse('$baseUrl/chat/conversations/$conversationId/participants'),
  headers: headers,
  body: jsonEncode({
    'participantIds': ['new_user_id'],
  }),
);

// Remove participant (admin only or self)
await http.delete(
  Uri.parse('$baseUrl/chat/conversations/$conversationId/participants/$userId'),
  headers: headers,
);
```

### API Response Structures

#### Conversation Response

```json
{
  "_id": "conversation_id",
  "type": "direct|group|family",
  "name": "Conversation Name",
  "participants": [
    {
      "userId": {
        "_id": "user_id",
        "fullName": "User Name",
        "image": "profile_image_url",
        "status": "active"
      },
      "role": "admin|member",
      "joinedAt": "2024-01-15T10:30:00Z",
      "isActive": true
    }
  ],
  "lastMessage": {
    "_id": "message_id",
    "content": "Last message content",
    "createdAt": "2024-01-15T10:30:00Z"
  },
  "unreadCount": 5,
  "lastActivity": "2024-01-15T10:30:00Z"
}
```

#### Message Response

```json
{
  "_id": "message_id",
  "conversationId": "conversation_id",
  "senderId": {
    "_id": "user_id",
    "fullName": "Sender Name",
    "image": "profile_image_url"
  },
  "content": "Message content",
  "messageType": "text|image|video|audio|document|location",
  "attachments": [
    {
      "type": "image",
      "url": "file_url",
      "filename": "photo.jpg",
      "size": 1024000
    }
  ],
  "readBy": [
    {
      "userId": "user_id",
      "readAt": "2024-01-15T10:32:00Z"
    }
  ],
  "deliveredTo": [
    {
      "userId": "user_id",
      "deliveredAt": "2024-01-15T10:31:00Z"
    }
  ],
  "replyTo": {
    "_id": "original_message_id",
    "content": "Original message",
    "senderId": "original_sender_id"
  },
  "edited": {
    "isEdited": false,
    "editedAt": null,
    "originalContent": null
  },
  "createdAt": "2024-01-15T10:30:00Z"
}
```

### Socket.io Connection Flow

#### 1. Client Connection

```dart
socket = IO.io('http://your-server.com',
  IO.OptionBuilder()
    .setTransports(['websocket'])
    .setAuth({'token': jwtToken})
    .build()
);

socket?.connect();
```

#### 2. Server Authentication

```javascript
// Server validates JWT and joins user to personal room
socket.join(`user_${userId}`);
// Also joins all user's conversation rooms
conversations.forEach((conv) => socket.join(`conversation_${conv._id}`));
```

#### 3. Real-time Events Flow

```
User A sends message → API call → Database save →
Socket emit to conversation room → User B receives message →
User B marks as delivered → Socket emit to User A →
User A sees delivery status
```

### Error Handling Patterns

#### API Error Responses

```dart
// Handle API errors
try {
  final result = await chatService.sendMessage(...);
  if (result == null) {
    // Show error message
    showErrorSnackbar('Failed to send message');
  }
} catch (e) {
  // Handle network errors
  showErrorSnackbar('Network error: $e');
}
```

#### Socket Connection Issues

```dart
socket?.onConnectError((error) {
  print('Connection error: $error');
  // Attempt reconnection
});

socket?.onDisconnect((_) {
  print('Disconnected from server');
  // Show offline indicator
});
```

### Performance Optimization Tips

#### 1. Message Pagination

```dart
// Load messages in chunks
final messages = await chatService.getMessages(
  conversationId: conversationId,
  page: currentPage,
  limit: 20, // Small chunks for better performance
);
```

#### 2. Image Optimization

```dart
// Compress images before sending
File compressedImage = await compressImage(originalImage);
String imageUrl = await uploadImage(compressedImage);

await chatService.sendMessage(
  conversationId: conversationId,
  messageType: 'image',
  attachments: [{'type': 'image', 'url': imageUrl}],
);
```

#### 3. Local Caching

```dart
// Cache conversations and messages locally
final cachedConversations = await DatabaseHelper.getConversations();
final cachedMessages = await DatabaseHelper.getMessages(conversationId);

// Sync with server when online
if (await isOnline()) {
  await syncWithServer();
}
```

## Testing

### API Testing with Bruno

The module includes Bruno test files for all endpoints located in the `bruno/chat/` directory.

### Socket.io Testing

Use tools like Socket.IO Client Tool or create custom test scripts to test real-time functionality.

## Migration and Deployment

1. **Database Migration**: Ensure MongoDB indexes are created
2. **Socket.io Configuration**: Configure for production environment
3. **Load Balancing**: Consider sticky sessions for Socket.io
4. **Monitoring**: Implement logging for chat activities
5. **Backup Strategy**: Regular backup of chat data

## Future Enhancements

1. **Voice Messages**: Add voice recording and playback
2. **Video Calls**: Integrate video calling functionality
3. **Message Reactions**: Add emoji reactions to messages
4. **Message Forwarding**: Forward messages between conversations
5. **Chat Backup**: Export chat history functionality
6. **Advanced Search**: Full-text search across all messages
7. **Message Scheduling**: Schedule messages for later delivery
8. **Chat Themes**: Customizable chat interface themes
