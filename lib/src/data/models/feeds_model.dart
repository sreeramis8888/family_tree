class Feed {
  final String id;
  final String type;
  final String? media;
  final String? link;
  final String? content;
  final String status;
  final String authorId;
  final String? phoneNo;
  final String authorModel;
  final String? authorFullName; 
  final String? reason;
  final DateTime createdAt;
  final DateTime updatedAt;

  Feed({
    required this.id,
    required this.type,
    this.media,
    this.link,
    this.content,
    required this.status,
    required this.authorId,
    required this.authorModel,
    this.authorFullName,
    this.phoneNo,
    this.reason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    final author = json['author'];

    return Feed(
      id: json['_id'],
      type: json['type'],
      media: json['media'],
      link: json['link'],
      content: json['content'],
      status: json['status'],
      authorId: author is Map ? author['_id'] : author,
      authorFullName:
          author is Map ? author['fullName'] : null, 
      phoneNo: author is Map ? author['phone'] : null, 
          

      authorModel: json['authorModel'],
      reason: json['reason'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class FeedWithPerson {
  final Feed feed;
  final String fullName;
  final String phone;

  FeedWithPerson({
    required this.feed,
    required this.fullName,
    required this.phone,
  });
}

