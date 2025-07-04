class ReportModel {
  final String id;
  final String userId;
  final String reason;
  final String? details;
  final String status;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.userId,
    required this.reason,
    this.details,
    required this.status,
    required this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      reason: json['reason'] ?? '',
      details: json['details'],
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'reason': reason,
      'details': details,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
