<<<<<<< HEAD
class FamilyModel {
  final String? id;
  final String? name;
  final List<Member>? members;
  final List<dynamic>? parentFamilyId;
  final String? location;
  final int? generation;
  final bool? status;
  final bool? isPrivate;

  final List<dynamic>? media;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  FamilyModel({
    this.id,
    this.name,
    this.members,
    this.parentFamilyId,
    this.location,
    this.generation,
    this.status,
    this.isPrivate,
    this.media,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['_id'],
      name: json['name'],
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => Member.fromJson(e))
          .toList(),
      parentFamilyId: json['parentFamilyId'],
      location: json['location'],
      generation: json['generation'],
      status: json['status'],
      isPrivate: json['isPrivate'],
      media: json['media'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'members': members?.map((e) => e.toJson()).toList(),
      'parentFamilyId': parentFamilyId,
      'location': location,
      'generation': generation,
      'status': status,
      'isPrivate': isPrivate,
      'media': media,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class Member {
  final String? id;
  final String? role;
  final DateTime? joinDate;
  final String? personId;
  final String? fullName;

  Member({
    this.id,
    this.role,
    this.joinDate,
    this.personId,
    this.fullName,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['_id'],
      role: json['role'],
      joinDate:
          json['joinDate'] != null ? DateTime.parse(json['joinDate']) : null,
      personId: json['person']?['_id'],
      fullName: json['person']?['fullName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'role': role,
      'joinDate': joinDate?.toIso8601String(),
      'person': {
        '_id': personId,
        'fullName': fullName,
      },
    };
  }
}
=======
class FamilyModel {
  final String? id;
  final String? name;
  final List<Member>? members;
  final List<dynamic>? parentFamilyId;
  final String? location;
  final int? generation;
  final bool? status;
  final bool? isPrivate;

  final List<dynamic>? media;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  FamilyModel({
    this.id,
    this.name,
    this.members,
    this.parentFamilyId,
    this.location,
    this.generation,
    this.status,
    this.isPrivate,
    this.media,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['_id'],
      name: json['name'],
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => Member.fromJson(e))
          .toList(),
      parentFamilyId: json['parentFamilyId'],
      location: json['location'],
      generation: json['generation'],
      status: json['status'],
      isPrivate: json['isPrivate'],
      media: json['media'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'members': members?.map((e) => e.toJson()).toList(),
      'parentFamilyId': parentFamilyId,
      'location': location,
      'generation': generation,
      'status': status,
      'isPrivate': isPrivate,
      'media': media,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class Member {
  final String? id;
  final String? role;
  final DateTime? joinDate;
  final String? personId;
  final String? fullName;

  Member({
    this.id,
    this.role,
    this.joinDate,
    this.personId,
    this.fullName,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['_id'],
      role: json['role'],
      joinDate:
          json['joinDate'] != null ? DateTime.parse(json['joinDate']) : null,
      personId: json['person']?['_id'],
      fullName: json['person']?['fullName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'role': role,
      'joinDate': joinDate?.toIso8601String(),
      'person': {
        '_id': personId,
        'fullName': fullName,
      },
    };
  }
}
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
