class FamilyModel {
  final String? id;
  final String? name;
  final List<FamilyMember>? members;
  final List<String>? parentFamilyId;
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
      id: json['_id'] as String?,
      name: json['name'] as String?,
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      parentFamilyId: (json['parentFamilyId'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      location: json['location'] as String?,
      generation: json['generation'] as int?,
      status: json['status'] as bool?,
      isPrivate: json['isPrivate'] as bool?,
      media: json['media'] as List<dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
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
class FamilyMember {
  final String? personId;
  final String? role;
  final DateTime? joinDate;
  final String? id;

  FamilyMember({
    this.personId,
    this.role,
    this.joinDate,
    this.id,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      personId: json['person']['_id'] as String,
     
      role: json['role'] as String?,
      joinDate: json['joinDate'] != null
          ? DateTime.tryParse(json['joinDate'])
          : null,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personId': personId,
      'role': role,
      'joinDate': joinDate?.toIso8601String(),
      '_id': id,
    };
  }
}
