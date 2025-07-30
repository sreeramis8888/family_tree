class DonatedMember {
  final String member;
  final int amount;
  final String? donorName;

  DonatedMember({
    required this.member,
    required this.amount,
    this.donorName,
  });

  factory DonatedMember.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DonatedMember(member: '', amount: 0);
    }
    return DonatedMember(
      member: json['member'] as String? ?? '',
      amount: json['amount'] as int? ?? 0,
      donorName: json['donorName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'member': member,
      'amount': amount,
      if (donorName != null) 'donorName': donorName,
    };
  }
}

class CampaignModel {
  final String id;
  final String title;
  final int targetAmount;
  final DateTime deadline;
  final String tagType;
  final String organizedBy;
  final String description;
  final String status;
  final DateTime createdAt;
  final int donatedAmount;
  final List<DonatedMember> donatedMembers;

  CampaignModel({
    required this.id,
    required this.description,
    required this.title,
    required this.targetAmount,
    required this.deadline,
    required this.tagType,
    required this.organizedBy,
    required this.status,
    required this.createdAt,
    required this.donatedAmount,
    required this.donatedMembers,
  });

  factory CampaignModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CampaignModel(description: '',
        id: '',
        title: '',
        targetAmount: 0,
        deadline: DateTime.now(),
        tagType: '',
        organizedBy: '',
        status: '',
        createdAt: DateTime.now(),
        donatedAmount: 0,
        donatedMembers: [],
      );
    }

    return CampaignModel( description:json['description'] as String? ?? '', 
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      targetAmount: json['targetAmount'] as int? ?? 0,
      deadline: _parseDate(json['deadline']),
      tagType: json['tagType'] as String? ?? '',
      organizedBy: json['organizedBy'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: _parseDate(json['createdAt']),
      donatedAmount: json['currentAmount'] as int? ?? 0,
      donatedMembers: (json['donatedMembers'] as List<dynamic>?)
              ?.map((e) => DonatedMember.fromJson(e as Map<String, dynamic>?))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'targetAmount': targetAmount,
      'deadline': deadline.toIso8601String(),
      'tagType': tagType,
      'organizedBy': organizedBy,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'donatedAmount': donatedAmount,
      'donatedMembers': donatedMembers.map((e) => e.toJson()).toList(),
    };
  }

  static DateTime _parseDate(dynamic date) {
    if (date is String) {
      return DateTime.tryParse(date) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
