class TransactionModel {
  final String id;
  final String type;
  final String dateTime;
  final int amountPaid;
  final String status;
  final String? reasonForRejection;
  final String? description;

  TransactionModel({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.amountPaid,
    required this.status,
    this.reasonForRejection,
    this.description,
  });

  // Factory constructor for creating a new TransactionModel object from a map
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      dateTime: json['dateTime'] as String,
      amountPaid: json['amountPaid'] as int,
      status: json['status'] as String,
      reasonForRejection: json['reasonForRejection'] as String?,
      description: json['description'] as String?,
    );
  }

  // Method for converting a TransactionModel object to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'dateTime': dateTime,
      'amountPaid': amountPaid,
      'status': status,
      'reasonForRejection': reasonForRejection,
      'description': description,
    };
  }
}
