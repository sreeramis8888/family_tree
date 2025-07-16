class NotificationModel {
<<<<<<< HEAD
  final String? id;
  final List<UserNotification>? users;
  final String? subject;
  final String? content;
  final String? status; 
=======
  final List<UserNotification>? users;
  final String? subject;
  final String? content;
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
  final String? media;
  final String? link;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
<<<<<<< HEAD
  final List<TargetFamily> targetFamily;

  NotificationModel({
    required this.id,
    this.users,
    this.subject,
    this.content,
    this.status,
=======

  NotificationModel({
    this.users,
    this.subject,
    this.content,
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
    this.media,
    this.link,
    this.type,
    this.createdAt,
    this.updatedAt,
<<<<<<< HEAD
    required this.targetFamily,
=======
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
<<<<<<< HEAD
      id: json['_id'] as String?,
=======
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
      users: json['users'] != null
          ? (json['users'] as List)
              .map((user) => UserNotification.fromJson(user))
              .toList()
          : null,
<<<<<<< HEAD
      subject: json['title'] as String?,
      content: json['content'] as String?,
      status: json['status'] as String?, 
=======
      subject: json['subject'] as String?,
      content: json['content'] as String?,
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
      media: json['media'] as String?,
      link: json['link'] as String?,
      type: json['type'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
<<<<<<< HEAD
      targetFamily: (json['targetFamily'] as List<dynamic>?)
              ?.map((e) => TargetFamily.fromJson(e))
              .toList() ??
          [],
=======
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
    );
  }

  Map<String, dynamic> toJson() {
    return {
<<<<<<< HEAD
      '_id': id,
      'users': users?.map((user) => user.toJson()).toList(),
      'subject': subject,
      'content': content,
      'status': status, 
=======
      'users': users?.map((user) => user.toJson()).toList(),
      'subject': subject,
      'content': content,
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
      'media': media,
      'link': link,
      'type': type,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
<<<<<<< HEAD
      'targetFamily': targetFamily.map((e) => e.toJson()).toList(),
=======
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
    };
  }
}

<<<<<<< HEAD
class NotificationWithPerson {
  final NotificationModel notification;
  final String fullName;
  final String phone;

  NotificationWithPerson({
    required this.notification,
    required this.fullName,
    required this.phone,
  });
}

=======
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
class UserNotification {
  final String? userId;
  final bool? read;

  UserNotification({this.userId, this.read});

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      userId: json['user'] as String?,
      read: json['read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'read': read,
    };
  }
}
<<<<<<< HEAD

class TargetFamily {
  final String? id;
  final String? familyName;

  TargetFamily({this.id, this.familyName});

  factory TargetFamily.fromJson(Map<String, dynamic> json) {
    return TargetFamily(
      id: json['_id'] as String?,
      familyName: json['familyName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'familyName': familyName,
    };
  }
}
=======
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
