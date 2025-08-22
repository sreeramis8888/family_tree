import 'package:firebase_auth/firebase_auth.dart';

import 'chat_message_model.dart';
import 'chat_model.dart';
import 'user_model.dart';

class ChatConversation {
  final String? id;
  final String? type;
  final String? name;
  final String? description;
  final String? avatar;
  final List<Participant> participants;
  final String? familyId;
  final String? createdBy;

  final String? lastMessage;
  final DateTime? lastActivity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? unreadCount;
  final List<UserModel> participantDetails;

  ChatConversation({
    this.id,
    this.type,
    this.name,
    this.description,
    this.avatar,

    this.participants = const [],
    this.familyId,
    this.createdBy,
    this.lastMessage,
    this.lastActivity,
    this.createdAt,
    this.updatedAt,
    this.unreadCount,
    this.participantDetails = const [],
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      ChatConversation(
        id: json['_id']?.toString(),
        type: json['type']?.toString(),
        name: json['name']?.toString(),
        description: json['description']?.toString(),

        avatar: json['avatar']?.toString(),
        participants: (json['participants'] as List<dynamic>? ?? [])
            .map((e) => Participant.fromJson(e as Map<String, dynamic>))
            .toList(),
        familyId: json['familyId']?.toString(),
        createdBy: json['createdBy']?.toString(),
        lastMessage: (json['lastMessageDetail'] != null &&
                json['lastMessageDetail']['content'] != null)
            ? json['lastMessageDetail']['content'].toString()
            : '',
        lastActivity: json['lastActivity'] != null &&
                (json['lastActivity'] as String).isNotEmpty
            ? DateTime.tryParse(json['lastActivity'])
            : null,
        createdAt: json['createdAt'] != null &&
                (json['createdAt'] as String).isNotEmpty
            ? DateTime.tryParse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null &&
                (json['updatedAt'] as String).isNotEmpty
            ? DateTime.tryParse(json['updatedAt'])
            : null,
        unreadCount: json['unreadCount'] != null
            ? int.tryParse(json['unreadCount'].toString())
            : null,
        participantDetails: (json['participantDetails'] as List<dynamic>? ?? [])
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (avatar != null) 'avatar': avatar,
      'participants': participants.map((e) => e.toJson()).toList(),
      if (familyId != null) 'familyId': familyId,
      if (createdBy != null) 'createdBy': createdBy,
      'lastMessage': lastMessage is ChatMessage
          ? (lastMessage as ChatMessage).toJson()
          : lastMessage,
      if (lastActivity != null) 'lastActivity': lastActivity?.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
      if (unreadCount != null) 'unreadCount': unreadCount,
      'participantDetails': participantDetails
          .map((e) => e.toJson())
          .toList(), // ✅ INCLUDE IN JSON
    };
  }
}

class Participant {
  final ChatUser? userId;
  final String? role;
  final UserModel? user;
  final String? fullName;
  final DateTime? joinedAt;
  final DateTime? leftAt;
  final bool? isActive;
  final DateTime? muteUntil;
  final String? lastSeenMessageId;

  Participant({
    this.userId,
    this.fullName,
    this.role,
    this.user,
    this.joinedAt,
    this.leftAt,
    this.isActive,
    this.muteUntil,
    this.lastSeenMessageId,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        userId: ChatUser.fromJson(json['userId']),
        role: json['role']?.toString(),
        fullName: json['fullName']?.toString(),
                user:
            json['user'] != null ? UserModel.fromJson(json['user']) : null,
        joinedAt:
            json['joinedAt'] != null && (json['joinedAt'] as String).isNotEmpty
                ? DateTime.tryParse(json['joinedAt'])
                : null,
        leftAt: json['leftAt'] != null && (json['leftAt'] as String).isNotEmpty
            ? DateTime.tryParse(json['leftAt'])
            : null,
        isActive: json['isActive'] ?? true,
        muteUntil: json['muteUntil'] != null &&
                (json['muteUntil'] as String).isNotEmpty
            ? DateTime.tryParse(json['muteUntil'])
            : null,
        lastSeenMessageId: json['lastSeenMessageId']?.toString(),
      );

  Map<String, dynamic> toJson() {
    return {
      'userId': userId is ChatUser ? (userId as ChatUser).toJson() : userId,
      if (role != null) 'role': role,
      if (fullName != null) 'fullName': fullName,
      if (joinedAt != null) 'joinedAt': joinedAt?.toIso8601String(),
      if (leftAt != null) 'leftAt': leftAt?.toIso8601String(),
      if (isActive != null) 'isActive': isActive,
      if (muteUntil != null) 'muteUntil': muteUntil?.toIso8601String(),
      if (lastSeenMessageId != null) 'lastSeenMessageId': lastSeenMessageId,
    };
  }
}
