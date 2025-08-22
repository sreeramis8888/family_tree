import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
class TransactionModel {
  final String id;
  final String? transactionId;
  final String method;
  final String type;
  final double amount;
  final DateTime date;
  final List<dynamic> notes;


  TransactionModel({
    required this.id,
    this.transactionId,
    required this.method,
    required this.type,
    required this.amount,
    required this.date,
    required this.notes,

  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final personData = json['personId'];
    return TransactionModel(
      id: json['_id'] ?? '',
      transactionId: json['transactionId'],
      method: json['method'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
      notes: json['notes'] ?? [],
       );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'transactionId': transactionId,
      'method': method,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'notes': notes,
      
    };
  }
}
