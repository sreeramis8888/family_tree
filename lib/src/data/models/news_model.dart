class News {
  final String? id;
  final String? category;
  final String? title;
  final String? content;
  final String? media;
  final String? status;
  final String? pdf;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  News({
    this.id,
    this.category,
    this.title,
    this.content,
    this.media,
    this.status,
    this.pdf,
    this.createdAt,
    this.updatedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['_id'] as String?,
      category: json['category'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      media: json['media'] as String?,
      status: json['status'] as String?,
      pdf: json['pdf'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category,
      'title': title,
      'content': content,
      'media': media,
      'status': status,
      'pdf': pdf,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  News copyWith({
    String? id,
    String? category,
    String? title,
    String? content,
    String? media,
    String? status,
    String? pdf,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return News(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      media: media ?? this.media,
      status: status ?? this.status,
      pdf: pdf ?? this.pdf,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
