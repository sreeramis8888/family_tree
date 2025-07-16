<<<<<<< HEAD
import 'dart:convert';
import 'dart:developer';
import 'package:familytree/src/data/globals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../models/chat_conversation_model.dart';
import '../../models/chat_message_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_api.g.dart';

class ChatApi {
  final bool debug = true;

  static Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      };

  void _log(String name, String message) {
    if (debug) log(message, name: name);
  }

  Future<List<ChatConversation>> fetchConversations(
      {int page = 1, int limit = 20}) async {
    final url = '$baseUrl/chat/conversations?page=$page&limit=$limit';
    _log('FETCH_CONVERSATIONS', 'GET $url');

    final response = await http.get(Uri.parse(url), headers: _headers());

    _log('FETCH_CONVERSATIONS', 'Status: ${response.statusCode}');
    _log('FETCH_CONVERSATIONS', 'Response: ${response.body}');

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => ChatConversation.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load conversations');
    }
  }

  Future<ChatConversation> fetchDirectConversation(String recipientId) async {
    final url = '$baseUrl/chat/conversations/direct/$recipientId';
    _log('FETCH_DIRECT_CONVERSATION', 'GET $url');

    final response = await http.get(Uri.parse(url), headers: _headers());

    _log('FETCH_DIRECT_CONVERSATION', 'Status: ${response.statusCode}');
    _log('FETCH_DIRECT_CONVERSATION', 'Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return ChatConversation.fromJson(data);
    } else {
      throw Exception('Failed to load direct conversation');
    }
  }

  Future<ChatConversation> createGroupConversation({
    required String name,
    String? description,
    required List<String> participantIds,
    String? familyId,
  }) async {
    final url = '$baseUrl/chat/conversations/group';
    final payload = {
      'name': name,
      'description': description,
      'participantIds': participantIds,
      'familyId': familyId,
    };

    _log('CREATE_GROUP_CONVERSATION', 'POST $url');
    _log('CREATE_GROUP_CONVERSATION', 'Payload: ${json.encode(payload)}');

    final response = await http.post(
      Uri.parse(url),
      headers: _headers(),
      body: json.encode(payload),
    );

    _log('CREATE_GROUP_CONVERSATION', 'Status: ${response.statusCode}');
    _log('CREATE_GROUP_CONVERSATION', 'Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return ChatConversation.fromJson(data);
    } else {
      throw Exception('Failed to create group conversation');
    }
  }

  Future<List<ChatMessage>> fetchMessages(String conversationId,
      {int page = 1, int limit = 50}) async {
    final url =
        '$baseUrl/chat/conversations/$conversationId/messages?page=$page&limit=$limit';
    _log('FETCH_MESSAGES', 'GET $url');

    final response = await http.get(Uri.parse(url), headers: _headers());

    _log('FETCH_MESSAGES', 'Status: ${response.statusCode}');
    _log('FETCH_MESSAGES', 'Response: ${response.body}');

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => ChatMessage.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<ChatMessage> sendMessage(String conversationId, String content,
      {String messageType = 'text',
      List<Map<String, dynamic>>? attachments,
      dynamic replyTo}) async {
    log(
        name: 'HITTING API',
        '$baseUrl/chat/conversations/$conversationId/messages');
    final response = await http.post(
      Uri.parse('$baseUrl/chat/conversations/$conversationId/messages'),
      headers: _headers(),
      body: json.encode({
        'content': content,
        'messageType': messageType,
        if (attachments != null) 'attachments': attachments,
        if (replyTo != null)
          'replyTo': replyTo is String
              ? replyTo
              : (replyTo is ChatMessage ? replyTo.id : null),
      }),
    );
    final data = json.decode(response.body)['data'];
    log(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return ChatMessage.fromJson(data);
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<bool> markMessagesAsRead(
      String conversationId, List<String> messageIds) async {
    final url = '$baseUrl/chat/conversations/$conversationId/messages/read';
    _log('MARK_MESSAGES_AS_READ', 'PUT $url');
    final response = await http.put(
      Uri.parse(url),
      headers: _headers(),
      body: json.encode({'messageIds': messageIds}),
    );
    _log('MARK_MESSAGES_AS_READ', 'Status: \\${response.statusCode}');
    _log('MARK_MESSAGES_AS_READ', 'Response: \\${response.body}');
    return response.statusCode == 200;
  }
}

@riverpod
Future<List<ChatConversation>> fetchChatConversations(Ref ref) async {
  final api = ChatApi();
  return api.fetchConversations();
}

@riverpod
Future<List<ChatMessage>> fetchChatMessages(Ref ref,
    {required String conversationId}) async {
  final api = ChatApi();
  return api.fetchMessages(conversationId);
}

@riverpod
Future<ChatMessage> sendChatMessage(Ref ref,
    {required String conversationId,
    required String content,
    List<Map<String, dynamic>>? attachments,
    dynamic replyTo}) async {
  final api = ChatApi();
  return api.sendMessage(conversationId, content,
      attachments: attachments, replyTo: replyTo);
}
=======
import 'dart:convert';
import 'dart:developer';
import 'package:familytree/src/data/globals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../models/chat_conversation_model.dart';
import '../../models/chat_message_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_api.g.dart';

class ChatApi {
  final bool debug = true;

  static Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      };

  void _log(String name, String message) {
    if (debug) log(message, name: name);
  }

  Future<List<ChatConversation>> fetchConversations(
      {int page = 1, int limit = 20}) async {
    final url = '$baseUrl/chat/conversations?page=$page&limit=$limit';
    _log('FETCH_CONVERSATIONS', 'GET $url');

    final response = await http.get(Uri.parse(url), headers: _headers());

    _log('FETCH_CONVERSATIONS', 'Status: ${response.statusCode}');
    _log('FETCH_CONVERSATIONS', 'Response: ${response.body}');

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => ChatConversation.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load conversations');
    }
  }

  Future<ChatConversation> fetchDirectConversation(String recipientId) async {
    final url = '$baseUrl/chat/conversations/direct/$recipientId';
    _log('FETCH_DIRECT_CONVERSATION', 'GET $url');

    final response = await http.get(Uri.parse(url), headers: _headers());

    _log('FETCH_DIRECT_CONVERSATION', 'Status: ${response.statusCode}');
    _log('FETCH_DIRECT_CONVERSATION', 'Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return ChatConversation.fromJson(data);
    } else {
      throw Exception('Failed to load direct conversation');
    }
  }

  Future<ChatConversation> createGroupConversation({
    required String name,
    String? description,
    required List<String> participantIds,
    String? familyId,
  }) async {
    final url = '$baseUrl/chat/conversations/group';
    final payload = {
      'name': name,
      'description': description,
      'participantIds': participantIds,
      'familyId': familyId,
    };

    _log('CREATE_GROUP_CONVERSATION', 'POST $url');
    _log('CREATE_GROUP_CONVERSATION', 'Payload: ${json.encode(payload)}');

    final response = await http.post(
      Uri.parse(url),
      headers: _headers(),
      body: json.encode(payload),
    );

    _log('CREATE_GROUP_CONVERSATION', 'Status: ${response.statusCode}');
    _log('CREATE_GROUP_CONVERSATION', 'Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return ChatConversation.fromJson(data);
    } else {
      throw Exception('Failed to create group conversation');
    }
  }

  Future<List<ChatMessage>> fetchMessages(String conversationId,
      {int page = 1, int limit = 50}) async {
    final url =
        '$baseUrl/chat/conversations/$conversationId/messages?page=$page&limit=$limit';
    _log('FETCH_MESSAGES', 'GET $url');

    final response = await http.get(Uri.parse(url), headers: _headers());

    _log('FETCH_MESSAGES', 'Status: ${response.statusCode}');
    _log('FETCH_MESSAGES', 'Response: ${response.body}');

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => ChatMessage.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<ChatMessage> sendMessage(String conversationId, String content,
      {String messageType = 'text',
      List<Map<String, dynamic>>? attachments,
      dynamic replyTo}) async {
    log(
        name: 'HITTING API',
        '$baseUrl/chat/conversations/$conversationId/messages');
    final response = await http.post(
      Uri.parse('$baseUrl/chat/conversations/$conversationId/messages'),
      headers: _headers(),
      body: json.encode({
        'content': content,
        'messageType': messageType,
        if (attachments != null) 'attachments': attachments,
        if (replyTo != null)
          'replyTo': replyTo is String
              ? replyTo
              : (replyTo is ChatMessage ? replyTo.id : null),
      }),
    );
    final data = json.decode(response.body)['data'];
    log(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return ChatMessage.fromJson(data);
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<bool> markMessagesAsRead(
      String conversationId, List<String> messageIds) async {
    final url = '$baseUrl/chat/conversations/$conversationId/messages/read';
    _log('MARK_MESSAGES_AS_READ', 'PUT $url');
    final response = await http.put(
      Uri.parse(url),
      headers: _headers(),
      body: json.encode({'messageIds': messageIds}),
    );
    _log('MARK_MESSAGES_AS_READ', 'Status: \\${response.statusCode}');
    _log('MARK_MESSAGES_AS_READ', 'Response: \\${response.body}');
    return response.statusCode == 200;
  }
}

@riverpod
Future<List<ChatConversation>> fetchChatConversations(Ref ref) async {
  final api = ChatApi();
  return api.fetchConversations();
}

@riverpod
Future<List<ChatMessage>> fetchChatMessages(Ref ref,
    {required String conversationId}) async {
  final api = ChatApi();
  return api.fetchMessages(conversationId);
}

@riverpod
Future<ChatMessage> sendChatMessage(Ref ref,
    {required String conversationId,
    required String content,
    List<Map<String, dynamic>>? attachments,
    dynamic replyTo}) async {
  final api = ChatApi();
  return api.sendMessage(conversationId, content,
      attachments: attachments, replyTo: replyTo);
}
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
