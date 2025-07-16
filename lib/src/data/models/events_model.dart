<<<<<<< HEAD
class Speaker {
  final String? name;
  final String? designation;
  final String? role;
  final String? image;

  Speaker({
    this.name,
    this.designation,
    this.role,
    this.image,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      name: json['name'] as String?,
      designation: json['designation'] as String?,
      role: json['role'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'role': role,
      'image': image,
    };
  }
}
class Event {
  final String? id;
  final String? eventName;
  final String? description;
  final String? type;
  final String? image;
  final DateTime? eventStartDate;
  final String? platform;
  final String? link;
  final String? venue;
  final String? organiserName;

  final List<Speaker>? speakers;
  final String? status;
  final List<String>? rsvp;
  final List<String>? attended;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? limit;

  Event({
    this.id,
    this.eventName,
    this.description,
    this.type,
    this.image,
    this.eventStartDate,
    this.platform,
    this.link,
    this.venue,
    this.organiserName,

    this.speakers,
    this.status,
    this.rsvp,
    this.attended,
    this.createdAt,
    this.updatedAt,
    this.limit,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] as String?,
      eventName: json['event_name'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      image: json['image'] as String?,
      eventStartDate: json['event_start_date'] != null
          ? DateTime.tryParse(json['event_start_date'])
          : null,
      platform: json['platform'] as String?,
      link: json['link'] as String?,
      venue: json['venue'] as String?,
      organiserName: json['organiserName'] as String?,

      speakers: (json['speakers'] as List?)
          ?.map((e) => Speaker.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      rsvp: (json['rsvp'] as List?)?.map((e) => e.toString()).toList(),
      attended: (json['attended'] as List?)?.map((e) => e.toString()).toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      limit: json['limit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'event_name': eventName,
      'description': description,
      'type': type,
      'image': image,
      'event_start_date': eventStartDate?.toIso8601String(),
      'platform': platform,
      'link': link,
      'venue': venue,
      'organiserName': organiserName,

      'speakers': speakers?.map((e) => e.toJson()).toList() ?? [],
      'status': status,
      'rsvp': rsvp ?? [],
      'attended': attended ?? [],
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'limit': limit,
    };
  }
}
class EventWithPerson {
  final Event event;
  final String fullName;
  final String phone;

  EventWithPerson({
    required this.event,
    required this.fullName,
    required this.phone,
  });
}
=======
class Speaker {
  final String? name;
  final String? designation;
  final String? role;
  final String? image;

  Speaker({
    this.name,
    this.designation,
    this.role,
    this.image,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      name: json['name'] as String?,
      designation: json['designation'] as String?,
      role: json['role'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'role': role,
      'image': image,
    };
  }
}
class Event {
  final String? id;
  final String? eventName;
  final String? description;
  final String? type;
  final String? image;
  final DateTime? eventStartDate;
  final String? platform;
  final String? link;
  final String? venue;
  final String? organiserName;

  final List<Speaker>? speakers;
  final String? status;
  final List<String>? rsvp;
  final List<String>? attended;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? limit;

  Event({
    this.id,
    this.eventName,
    this.description,
    this.type,
    this.image,
    this.eventStartDate,
    this.platform,
    this.link,
    this.venue,
    this.organiserName,

    this.speakers,
    this.status,
    this.rsvp,
    this.attended,
    this.createdAt,
    this.updatedAt,
    this.limit,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] as String?,
      eventName: json['event_name'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      image: json['image'] as String?,
      eventStartDate: json['event_start_date'] != null
          ? DateTime.tryParse(json['event_start_date'])
          : null,
      platform: json['platform'] as String?,
      link: json['link'] as String?,
      venue: json['venue'] as String?,
      organiserName: json['organiserName'] as String?,

      speakers: (json['speakers'] as List?)
          ?.map((e) => Speaker.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      rsvp: (json['rsvp'] as List?)?.map((e) => e.toString()).toList(),
      attended: (json['attended'] as List?)?.map((e) => e.toString()).toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      limit: json['limit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'event_name': eventName,
      'description': description,
      'type': type,
      'image': image,
      'event_start_date': eventStartDate?.toIso8601String(),
      'platform': platform,
      'link': link,
      'venue': venue,
      'organiserName': organiserName,

      'speakers': speakers?.map((e) => e.toJson()).toList() ?? [],
      'status': status,
      'rsvp': rsvp ?? [],
      'attended': attended ?? [],
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'limit': limit,
    };
  }
}
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
