import 'dart:convert';

class FinancialAssistance {
  final String memberId;
  final String membershipStatus;
  final OnDeath? onDeath;

  FinancialAssistance({
    required this.memberId,
    required this.membershipStatus,
    this.onDeath,
  });

  factory FinancialAssistance.fromJson(Map<String, dynamic>? json) {
    if (json == null) return FinancialAssistance(memberId: '', membershipStatus: '', onDeath: null);
    return FinancialAssistance(
      memberId: json['memberId'] ?? '',
      membershipStatus: json['membershipStatus'] ?? '',
      onDeath: json['onDeath'] != null ? OnDeath.fromJson(json['onDeath']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
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