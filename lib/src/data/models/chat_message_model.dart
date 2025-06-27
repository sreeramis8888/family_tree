import 'package:meta/meta.dart';
import 'chat_model.dart';

class ChatMessage {
  final String? id;
  final String? conversationId;
  final ChatUser? sender;
  final String? content;
  final String? messageType;
  final List<Attachment> attachments;
  final dynamic replyTo; // String or ChatMessage
  final Edited? edited;
  final Deleted? deleted;
  final List<ReadReceipt> readBy;
  final List<DeliveredTo> deliveredTo;
  final Metadata? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatMessage({
    this.id,
    this.conversationId,
    this.sender,
    this.content,
    this.messageType,
    this.attachments = const [],
    this.replyTo,
    this.edited,
    this.deleted,
    this.readBy = const [],
    this.deliveredTo = const [],
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['_id']?.toString(),
        conversationId: json['conversationId']?.toString(),
        sender: json['senderId'] != null
            ? (json['senderId'] is String
                ? ChatUser(id: json['senderId'])
                : ChatUser.fromJson(json['senderId']))
            : null,
        content: json['content']?.toString(),
        messageType: json['messageType']?.toString(),
        attachments: (json['attachments'] as List<dynamic>? ?? [])
            .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
            .toList(),
        replyTo: json['replyTo'] != null
            ? (json['replyTo'] is String
                ? json['replyTo']
                : ChatMessage.fromJson(json['replyTo']))
            : null,
        edited: json['edited'] != null
            ? Edited.fromJson(json['edited'] as Map<String, dynamic>)
            : null,
        deleted: json['deleted'] != null
            ? Deleted.fromJson(json['deleted'] as Map<String, dynamic>)
            : null,
        readBy: (json['readBy'] as List<dynamic>? ?? [])
            .map((e) => ReadReceipt.fromJson(e as Map<String, dynamic>))
            .toList(),
        deliveredTo: (json['deliveredTo'] as List<dynamic>? ?? [])
            .map((e) => DeliveredTo.fromJson(e as Map<String, dynamic>))
            .toList(),
        metadata: json['metadata'] != null
            ? Metadata.fromJson(json['metadata'] as Map<String, dynamic>)
            : null,
        createdAt: json['createdAt'] != null && (json['createdAt'] as String).isNotEmpty
            ? DateTime.tryParse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null && (json['updatedAt'] as String).isNotEmpty
            ? DateTime.tryParse(json['updatedAt'])
            : null,
      );

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (conversationId != null) 'conversationId': conversationId,
      if (sender != null) 'senderId': sender?.toJson(),
      if (content != null) 'content': content,
      if (messageType != null) 'messageType': messageType,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'replyTo': replyTo is ChatMessage ? (replyTo as ChatMessage).toJson() : replyTo,
      if (edited != null) 'edited': edited?.toJson(),
      if (deleted != null) 'deleted': deleted?.toJson(),
      'readBy': readBy.map((e) => e.toJson()).toList(),
      'deliveredTo': deliveredTo.map((e) => e.toJson()).toList(),
      if (metadata != null) 'metadata': metadata?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Attachment {
  final String type;
  final String url;
  final String? filename;
  final int? size;
  final String? mimeType;
  final String? thumbnail;
  final num? duration;
  final Location? location;

  Attachment({
    required this.type,
    required this.url,
    this.filename,
    this.size,
    this.mimeType,
    this.thumbnail,
    this.duration,
    this.location,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        type: json['type'] as String,
        url: json['url'] as String,
        filename: json['filename'] as String?,
        size: json['size'] as int?,
        mimeType: json['mimeType'] as String?,
        thumbnail: json['thumbnail'] as String?,
        duration: json['duration'] as num?,
        location: json['location'] != null
            ? Location.fromJson(json['location'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
      if (filename != null) 'filename': filename,
      if (size != null) 'size': size,
      if (mimeType != null) 'mimeType': mimeType,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (duration != null) 'duration': duration,
      if (location != null) 'location': location?.toJson(),
    };
  }
}

class Location {
  final double? latitude;
  final double? longitude;
  final String? address;

  Location({this.latitude, this.longitude, this.address});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        address: json['address'] as String?,
      );

  Map<String, dynamic> toJson() {
    return {
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (address != null) 'address': address,
    };
  }
}

class Edited {
  final bool isEdited;
  final DateTime? editedAt;
  final String? originalContent;

  Edited({required this.isEdited, this.editedAt, this.originalContent});

  factory Edited.fromJson(Map<String, dynamic> json) => Edited(
        isEdited: json['isEdited'] as bool? ?? false,
        editedAt: json['editedAt'] != null
            ? DateTime.parse(json['editedAt'] as String)
            : null,
        originalContent: json['originalContent'] as String?,
      );

  Map<String, dynamic> toJson() {
    return {
      'isEdited': isEdited,
      if (editedAt != null) 'editedAt': editedAt?.toIso8601String(),
      if (originalContent != null) 'originalContent': originalContent,
    };
  }
}

class Deleted {
  final bool isDeleted;
  final DateTime? deletedAt;
  final String? deletedBy;
  final String? deletedFor;

  Deleted({
    required this.isDeleted,
    this.deletedAt,
    this.deletedBy,
    this.deletedFor,
  });

  factory Deleted.fromJson(Map<String, dynamic> json) => Deleted(
        isDeleted: json['isDeleted'] as bool? ?? false,
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'] as String)
            : null,
        deletedBy: json['deletedBy'] as String?,
        deletedFor: json['deletedFor'] as String?,
      );

  Map<String, dynamic> toJson() {
    return {
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toIso8601String(),
      if (deletedBy != null) 'deletedBy': deletedBy,
      if (deletedFor != null) 'deletedFor': deletedFor,
    };
  }
}

class ReadReceipt {
  final String userId;
  final DateTime readAt;

  ReadReceipt({required this.userId, required this.readAt});

  factory ReadReceipt.fromJson(Map<String, dynamic> json) => ReadReceipt(
        userId: json['userId'] as String,
        readAt: DateTime.parse(json['readAt'] as String),
      );

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'readAt': readAt.toIso8601String(),
    };
  }
}

class DeliveredTo {
  final String userId;
  final DateTime deliveredAt;

  DeliveredTo({required this.userId, required this.deliveredAt});

  factory DeliveredTo.fromJson(Map<String, dynamic> json) => DeliveredTo(
        userId: json['userId'] as String,
        deliveredAt: DateTime.parse(json['deliveredAt'] as String),
      );

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'deliveredAt': deliveredAt.toIso8601String(),
    };
  }
}

class Metadata {
  final List<Mention> mentions;
  final String? systemMessageType;

  Metadata({this.mentions = const [], this.systemMessageType});

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        mentions: (json['mentions'] as List<dynamic>? ?? [])
            .map((e) => Mention.fromJson(e as Map<String, dynamic>))
            .toList(),
        systemMessageType: json['systemMessageType'] as String?,
      );

  Map<String, dynamic> toJson() {
    return {
      'mentions': mentions.map((e) => e.toJson()).toList(),
      if (systemMessageType != null) 'systemMessageType': systemMessageType,
    };
  }
}

class Mention {
  final String userId;
  final int startIndex;
  final int length;

  Mention({required this.userId, required this.startIndex, required this.length});

  factory Mention.fromJson(Map<String, dynamic> json) => Mention(
        userId: json['userId'] as String,
        startIndex: json['startIndex'] as int,
        length: json['length'] as int,
      );

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'startIndex': startIndex,
      'length': length,
    };
  }
} 