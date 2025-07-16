class RequestModel {
  final String id;
  final String fullName;
  final String status;
  final List<String>? familyId;
  final String? email;
  final String? phone;
final String? gender;

  final String? createdPersonId;
  final List<Relationship> relationships;

  RequestModel({
    required this.id,
    required this.fullName,
    required this.status,
    this.familyId,
    this.email,
    this.phone,
    this.gender,
    this.createdPersonId,
    required this.relationships,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    final rawFamilyId = json['familyId'];
    List<String>? parsedFamilyId;

    if (rawFamilyId is List) {
      parsedFamilyId = rawFamilyId
          .map((item) {
            if (item is String) return item;
            if (item is Map && item['_id'] != null)
              return item['_id'].toString();
            return '';
          })
          .where((id) => id.isNotEmpty)
          .toList();
    }

    // Handle relationships parsing
    final rawRelationships = json['relationships'] as List<dynamic>? ?? [];
    final parsedRelationships =
        rawRelationships.map((rel) => Relationship.fromJson(rel)).toList();

    // Handle createdPersonId whether it's a string or object
    String? parsedCreatedPersonId;
    final createdPerson = json['createdPersonId'];
    if (createdPerson is String) {
      parsedCreatedPersonId = createdPerson;
    } else if (createdPerson is Map && createdPerson['_id'] != null) {
      parsedCreatedPersonId = createdPerson['_id'].toString();
    }

    return RequestModel(
      id: json['_id'],
      fullName: json['fullName'] ?? 'N/A',
      status: json['status'] ?? 'pending',
      familyId: parsedFamilyId,
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],

      createdPersonId: parsedCreatedPersonId,
      relationships: parsedRelationships,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'status': status,
      'familyId': familyId,
      'email': email,
      'phone': phone,
      'createdPersonId': createdPersonId,
      'relationships': relationships.map((r) => r.toJson()).toList(),
    };
  }
}

class Relationship {
  final String personId;
  final String type;
  final String id;
  final String? relatedPersonName;
  final String? relatedPersonPhone;

  Relationship({
    required this.personId,
    required this.type,
    required this.id,
    this.relatedPersonName,
    this.relatedPersonPhone,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(
      personId: json['personId'],
      type: json['type'],
      id: json['_id'],
      relatedPersonName: json['relatedPersonName'],
      relatedPersonPhone: json['relatedPersonPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personId': personId,
      'type': type,
      '_id': id,
      if (relatedPersonName != null) 'relatedPersonName': relatedPersonName,
      if (relatedPersonPhone != null) 'relatedPersonPhone': relatedPersonPhone,
    };
  }
}
class RequestWithPerson {
  final RequestModel request;
  final String fullName;
  final String phone;

  RequestWithPerson({
    required this.request,
    required this.fullName,
    required this.phone,
  });
}
