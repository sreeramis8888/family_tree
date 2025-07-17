class UserModel {
  final String? id;
  final String? fullName;
  final String? gender;
  final DateTime? birthDate;
  final DateTime? deathDate;
  final String? occupation;
  final String? biography;
  final List<Media>? media;
  final List<String>? familyId;

  final String? email;
  final String? phone;
  final String? secondaryPhone;
  final List<Link>? social;
  final String? address;
  final List<Link>? website;

  final double? walletBalance;
  final DateTime? lastRecharge;
  final String? walletStatus;
  final double? lastRechargeAmount;
  final double? totalContribution;
  final DateTime? lastRenewed;
  final DateTime? nextRenewal;
  final int? reminderThreshold;
  final double? receivedContributions;
  final double? fixedWalletAmount;
  final bool? needsRechargeReminder;

  final bool? isAlive;
  final String? status;
  final bool? isPrivate;
  final String? image;
  final String? location;
  final bool? isRegistered;
  final bool? isFamilyAdmin;

  UserModel({
    this.id,
    this.fullName,
    this.gender,
    this.birthDate,
    this.deathDate,
    this.occupation,
    this.biography,
    this.media,
    this.familyId,
    this.email,
    this.phone,
    this.secondaryPhone,
    this.social,
    this.address,
    this.website,
    this.walletBalance,
    this.lastRecharge,
    this.walletStatus,
    this.lastRechargeAmount,
    this.totalContribution,
    this.lastRenewed,
    this.nextRenewal,
    this.reminderThreshold,
    this.receivedContributions,
    this.fixedWalletAmount,
    this.needsRechargeReminder,
    this.isAlive,
    this.status,
    this.isPrivate,
    this.image,
    this.location,
    this.isRegistered,
    this.isFamilyAdmin,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? gender,
    DateTime? birthDate,
    DateTime? deathDate,
    String? occupation,
    String? biography,
    List<Media>? media,
    List<String>? familyId,
    String? email,
    String? phone,
    String? secondaryPhone,
    List<Link>? social,
    String? address,
    List<Link>? website,
    double? walletBalance,
    DateTime? lastRecharge,
    String? walletStatus,
    double? lastRechargeAmount,
    double? totalContribution,
    DateTime? lastRenewed,
    DateTime? nextRenewal,
    int? reminderThreshold,
    double? receivedContributions,
    double? fixedWalletAmount,
    bool? needsRechargeReminder,
    bool? isFinanceProgramMember,
    bool? isAlive,
    String? status,
    bool? isPrivate,
    String? image,
    String? location,
    bool? isRegistered,
    bool? isisFamilyAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      deathDate: deathDate ?? this.deathDate,
      occupation: occupation ?? this.occupation,
      biography: biography ?? this.biography,
      media: media ?? this.media,
      familyId: familyId ?? this.familyId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      social: social ?? this.social,
      address: address ?? this.address,
      website: website ?? this.website,
      walletBalance: walletBalance ?? this.walletBalance,
      lastRecharge: lastRecharge ?? this.lastRecharge,
      walletStatus: walletStatus ?? this.walletStatus,
      lastRechargeAmount: lastRechargeAmount ?? this.lastRechargeAmount,
      totalContribution: totalContribution ?? this.totalContribution,
      lastRenewed: lastRenewed ?? this.lastRenewed,
      nextRenewal: nextRenewal ?? this.nextRenewal,
      reminderThreshold: reminderThreshold ?? this.reminderThreshold,
      receivedContributions:
          receivedContributions ?? this.receivedContributions,
      fixedWalletAmount: fixedWalletAmount ?? this.fixedWalletAmount,
      needsRechargeReminder:
          needsRechargeReminder ?? this.needsRechargeReminder,
      isAlive: isAlive ?? this.isAlive,
      status: status ?? this.status,
      isPrivate: isPrivate ?? this.isPrivate,
      image: image ?? this.image,
      location: location ?? this.location,
      isRegistered: isRegistered ?? this.isRegistered,
      isFamilyAdmin: isFamilyAdmin?? this.isFamilyAdmin
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['fullName'],
      gender: json['gender'],
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'])
          : null,
      deathDate: json['deathDate'] != null
          ? DateTime.tryParse(json['deathDate'])
          : null,
      occupation: json['occupation'],
      biography: json['biography'],
      media: (json['media'] as List?)?.map((e) => Media.fromJson(e)).toList(),
      familyId: (json['familyId'] as List?)?.map((e) => e.toString()).toList(),
      email: json['email'],
      phone: json['phone'],
      secondaryPhone: json['secondaryPhone'],
      social: (json['social'] as List?)?.map((e) => Link.fromJson(e)).toList(),
      address: json['address'],
      website:
          (json['website'] as List?)?.map((e) => Link.fromJson(e)).toList(),
      walletBalance: (json['walletBalance'] as num?)?.toDouble(),
      lastRecharge: json['lastRecharge'] != null
          ? DateTime.tryParse(json['lastRecharge'])
          : null,
      walletStatus: json['walletStatus'],
      lastRechargeAmount: (json['lastRechargeAmount'] as num?)?.toDouble(),
      totalContribution: (json['totalContribution'] as num?)?.toDouble(),
      lastRenewed: json['lastRenewed'] != null
          ? DateTime.tryParse(json['lastRenewed'])
          : null,
      nextRenewal: json['nextRenewal'] != null
          ? DateTime.tryParse(json['nextRenewal'])
          : null,
      reminderThreshold: json['reminderThreshold'],
      receivedContributions:
          (json['receivedContributions'] as num?)?.toDouble(),
      fixedWalletAmount: (json['fixedWalletAmount'] as num?)?.toDouble(),
      needsRechargeReminder: json['needsRechargeReminder'],
      isAlive: json['isAlive'],
      status: json['status'],
      isPrivate: json['isPrivate'],
      image: json['image'],
      location: json['location'],
      isRegistered: json['isRegistered'],
      isFamilyAdmin: json['isFamilyAdmin']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'deathDate': deathDate?.toIso8601String(),
      'occupation': occupation,
      'biography': biography,
      'media': media?.map((e) => e.toJson()).toList(),
      'familyId': familyId,
      'email': email,
      'phone': phone,
      'secondaryPhone': secondaryPhone,
      'social': social?.map((e) => e.toJson()).toList(),
      'address': address,
      'website': website,
      'walletBalance': walletBalance,
      'lastRecharge': lastRecharge?.toIso8601String(),
      'walletStatus': walletStatus,
      'lastRechargeAmount': lastRechargeAmount,
      'totalContribution': totalContribution,
      'lastRenewed': lastRenewed?.toIso8601String(),
      'nextRenewal': nextRenewal?.toIso8601String(),
      'reminderThreshold': reminderThreshold,
      'receivedContributions': receivedContributions,
      'fixedWalletAmount': fixedWalletAmount,
      'needsRechargeReminder': needsRechargeReminder,
      'isAlive': isAlive,
      'status': status,
      'isPrivate': isPrivate,
      'image': image,
      'location': location,
      'isRegistered': isRegistered,
      'isFamilyAdmin':isFamilyAdmin
    };
  }
}

class Media {
  final String? url;
  final String? caption;
  final Map<String, dynamic>? notes;
  final String? metadata;
  final DateTime? uploadDate;

  Media({
    this.url,
    this.caption,
    this.notes,
    this.metadata,
    this.uploadDate,
  });

  Media copyWith({
    String? url,
    String? caption,
    Map<String, dynamic>? notes,
    String? metadata,
    DateTime? uploadDate,
  }) {
    return Media(
      url: url ?? this.url,
      caption: caption ?? this.caption,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
      uploadDate: uploadDate ?? this.uploadDate,
    );
  }

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      url: json['url'],
      caption: json['caption'],
      notes: json['notes'] != null
          ? Map<String, dynamic>.from(json['notes'])
          : null,
      metadata: json['metadata'],
      uploadDate: json['uploadDate'] != null
          ? DateTime.tryParse(json['uploadDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'caption': caption,
        'notes': notes,
        'metadata': metadata,
        'uploadDate': uploadDate?.toIso8601String(),
      };
}
class Link {
  final String? name;
  final String? link;

  Link({this.name, this.link});

  Link copyWith({
    String? name,
    String? link,
  }) {
    return Link(
      name: name ?? this.name,
      link: link ?? this.link,
    );
  }

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      name: json['name'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'link': link,
      };
}
