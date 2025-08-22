class ChatUser {
  final String? id;
  final String? fullName;
  final String? image;
  final String? status;

  ChatUser({
    this.id,
    this.fullName,
    this.image,
    this.status,
  });

  factory ChatUser.fromJson(dynamic json) {
    if (json == null) return ChatUser();
    if (json is String) {
      return ChatUser(id: json);
    }
    return ChatUser(
      id: json['_id']?.toString(),
      fullName: json['fullName']?.toString(),
      image: json['image']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (fullName != null) 'fullName': fullName,
      if (image != null) 'image': image,
      if (status != null) 'status': status,
    };
  }
}
