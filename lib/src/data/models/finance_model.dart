import 'dart:convert';

class MemberInfo {
  final String id;
  final String fullName;
  final String phone;
  final double walletBalance;
  final String? email;

  MemberInfo({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.walletBalance,
    this.email,
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json) {
    return MemberInfo(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'fullName': fullName,
        'phone': phone,
        'walletBalance': walletBalance,
        'email': email,
      };
}

class FinancialAssistance {
  final MemberInfo memberId;
  final String membershipStatus;
  final OnDeath? onDeath;

  FinancialAssistance({
    required this.memberId,
    required this.membershipStatus,
    this.onDeath,
  });

  factory FinancialAssistance.fromJson(Map<String, dynamic>? json) {
    if (json == null) return FinancialAssistance(
      memberId: MemberInfo(id: '', fullName: '', phone: '', walletBalance: 0),
      membershipStatus: '',
      onDeath: null,
    );
    return FinancialAssistance(
      memberId: json['memberId'] != null ? MemberInfo.fromJson(json['memberId']) : MemberInfo(id: '', fullName: '', phone: '', walletBalance: 0),
      membershipStatus: json['membershipStatus'] ?? '',
      onDeath: json['onDeath'] != null ? OnDeath.fromJson(json['onDeath']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId.toJson(),
        'membershipStatus': membershipStatus,
        'onDeath': onDeath?.toJson(),
      };
}

class OnDeath {
  final String? beneficiaryName;
  final String? beneficiaryPhone;
  final String? beneficiaryAddress;
  final DateTime? transferDate;
  final String? transferStatus;
  final double? amount;

  OnDeath({
    this.beneficiaryName,
    this.beneficiaryPhone,
    this.beneficiaryAddress,
    this.transferDate,
    this.transferStatus,
    this.amount,
  });

  factory OnDeath.fromJson(Map<String, dynamic>? json) {
    if (json == null) return OnDeath();
    return OnDeath(
      beneficiaryName: json['beneficiaryName'],
      beneficiaryPhone: json['beneficiaryPhone'],
      beneficiaryAddress: json['beneficiaryAddress'],
      transferDate: json['transferDate'] != null ? DateTime.tryParse(json['transferDate']) : null,
      transferStatus: json['transferStatus'],
      amount: json['amount'] != null ? (json['amount'] is int ? (json['amount'] as int).toDouble() : json['amount'] as double) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'beneficiaryName': beneficiaryName,
        'beneficiaryPhone': beneficiaryPhone,
        'beneficiaryAddress': beneficiaryAddress,
        'transferDate': transferDate?.toIso8601String(),
        'transferStatus': transferStatus,
        'amount': amount,
      };
}

class MinimumBalance {
  final double minimumAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MinimumBalance({
    required this.minimumAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory MinimumBalance.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MinimumBalance(minimumAmount: 0);
    return MinimumBalance(
      minimumAmount: json['minimumAmount'] != null ? (json['minimumAmount'] is int ? (json['minimumAmount'] as int).toDouble() : json['minimumAmount'] as double) : 0,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'minimumAmount': minimumAmount,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class ProgramMember {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final double walletBalance;
  final String status;
  final String? transferStatus;

  ProgramMember({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    required this.walletBalance,
    required this.status,
    this.transferStatus,
  });

  factory ProgramMember.fromJson(Map<String, dynamic> json) {
    return ProgramMember(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      transferStatus: json['transferStatus'],
    );
  }
} 