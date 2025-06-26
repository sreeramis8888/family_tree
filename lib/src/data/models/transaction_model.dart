import 'dart:convert';

class TransactionModel {
  final String id;
  final String transactionId;
  final String method;
  final String type;
  final double amount;
  final DateTime date;
  final List<dynamic> notes;
  final PersonSummary? person;

  TransactionModel({
    required this.id,
    required this.transactionId,
    required this.method,
    required this.type,
    required this.amount,
    required this.date,
    required this.notes,
    this.person,
  });

  // Factory constructor for creating a new TransactionModel object from a map
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] ?? '',
      transactionId: json['transactionId'] ?? '',
      method: json['method'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
      notes: json['notes'] ?? [],
      person: json['personId'] != null ? PersonSummary.fromJson(json['personId']) : null,
    );
  }

  // Method for converting a TransactionModel object to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'method': method,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'notes': notes,
      'person': person?.toJson(),
    };
  }
}

class PersonSummary {
  final String id;
  final String fullName;
  final String? email;
  final double walletBalance;

  PersonSummary({
    required this.id,
    required this.fullName,
    this.email,
    required this.walletBalance,
  });

  factory PersonSummary.fromJson(Map<String, dynamic> json) {
    return PersonSummary(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'],
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'walletBalance': walletBalance,
    };
  }
}
