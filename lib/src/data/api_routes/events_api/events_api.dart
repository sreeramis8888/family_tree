<<<<<<< HEAD
import 'dart:convert';
import 'dart:developer';
import 'package:familytree/src/data/api_routes/requirements_api/requirements_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/models/attendance_user_model.dart';
import 'package:familytree/src/data/models/events_model.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:http/http.dart' as http;
import 'package:familytree/src/data/globals.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'events_api.g.dart';

@riverpod
Future<EventWithPerson> fetchEventWithPerson(String eventId) async {
  final eventResponse = await http.get(
    Uri.parse('$baseUrl/events/$eventId'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (eventResponse.statusCode != 200) {
    throw Exception('Failed to load event');
  }

  final decoded = jsonDecode(eventResponse.body);
  final data = decoded['data'];

  final event = Event.fromJson(data); // your custom model parser

  // Now get the person data using `createdBy` ID
  final String createdById = data['createdBy'] is String
      ? data['createdBy']
      : data['createdBy']['_id'];

  final personResponse = await http.get(
    Uri.parse('$baseUrl/people/$createdById'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (personResponse.statusCode != 200) {
    throw Exception('Failed to load creator info');
  }

  final personJson = jsonDecode(personResponse.body)['data'];

  return EventWithPerson(
    event: event,
    fullName: personJson['fullName'] ?? personJson['name'] ?? 'N/A',
    phone: personJson['phone'] ?? 'N/A',
  );
}

Future<void> updateEventStatus({
  required String eventId,
  required String status, // approved, rejected, pending
}) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/events/approve/$eventId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'isApproved': status}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update event status: ${response.body}');
  }
}

@riverpod
Future<List<Map<String, dynamic>>> filteredEvents(
  FilteredEventsRef ref,
  List<String> memberIds,
) async {
  try {
    final url = Uri.parse('$baseUrl/events/family/all');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch events: ${response.body}');
    }

    final data = jsonDecode(response.body)['data'] as List;

    final filtered = data
        .where((event) {
          final creatorModel = event['creatorModel'];

          // Handle both String and Map forms of `createdBy`
          final createdBy = event['createdBy'] is String
              ? event['createdBy']
              : event['createdBy']?['_id'];

          final isEventType =
              event['type'] == 'Online' || event['type'] == 'Offline';

          final isValid = creatorModel == 'Person' &&
              createdBy != null &&
              memberIds.contains(createdBy) &&
              isEventType;

          return isValid;
        })
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return filtered;
  } catch (e) {
    throw Exception('Error fetching filtered events: $e');
  }
}

@riverpod
Future<List<Map<String, dynamic>>> filteredFeeds(
    FilteredFeedsRef ref, List<String> memberIds) async {
  try {
    final url = Uri.parse('$baseUrl/feeds/family/all');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch feeds: ${response.body}');
    }

    final data = jsonDecode(response.body)['data'] as List;
    final filtered = data
        .where((feed) =>
            feed['authorModel'] == 'Person' &&
            memberIds.contains(feed['author']['_id']))
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return filtered;
  } catch (e) {
    throw Exception('Error fetching filtered feeds: $e');
  }
}

@riverpod
Future<List<Event>> fetchEvents(Ref ref) async {
  final url = Uri.parse('$baseUrl/events');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    log(response.body);
    List<Event> events = [];

    for (var item in data) {
      events.add(Event.fromJson(item));
    }
    print(events);
    return events;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

Future<Event> fetchEventById(id) async {
  final url = Uri.parse('$baseUrl/events/single/$id');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final dynamic data = json.decode(response.body)['data'];
    print(data['products']);

    return Event.fromJson(data);
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

@riverpod
Future<AttendanceUserListModel> fetchEventAttendance(
    FetchEventAttendanceRef ref,
    {required String eventId}) async {
  final url = Uri.parse('$baseUrl/events/attend/$eventId');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final dynamic data = json.decode(response.body)['data'];
    return AttendanceUserListModel.fromJson(data);
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

@riverpod
Future<List<Event>> fetchMyEvents(FetchMyEventsRef ref) async {
  final url = Uri.parse('$baseUrl/events/registered-events');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    print(response.body);
    List<Event> events = [];

    for (var item in data) {
      events.add(Event.fromJson(item));
    }
    log(events.toString());
    return events;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

Future<void> markEventAsRSVP(String eventId) async {
  final String url = '$baseUrl/events/$eventId';

  try {
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Success

      print('RSVP marked successfully');
    } else {
      // Handle error
      final dynamic data = json.decode(response.body)['message'];
      print('Failed to mark RSVP: ${data}');
    }
  } catch (e) {
    // Handle exceptions
    print('An error occurred: $e');
  }
}

Future<AttendanceUserModel?> markAttendanceEvent({
  required String eventId,
  required String userId,
}) async {
  SnackbarService snackbarService = SnackbarService();
  final String url = '$baseUrl/events/attend/$eventId';
  final Map<String, String> headers = {
    'accept': 'application/json',
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
  final Map<String, String> body = {
    'userId': userId,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final dynamic data = json.decode(response.body)['data'];

    print(data);
    return AttendanceUserModel.fromJson(data);
  } else {
    print(json.decode(response.body)['message']);
    snackbarService.showSnackBar(json.decode(response.body)['message']);
    return null;
    throw Exception(json.decode(response.body)['message']);
  }
}

Future<Event?> postEventByUser({
  required String userId,
  required String eventName,
  required String description,
  required String eventStartDate,
  required String eventEndDate,
  required String posterVisibilityStartDate,
  required String posterVisibilityEndDate,
  required String platform,
  required String link,
  required String venue,
  required String organiserName,
  required int limit,
  required List<Map<String, dynamic>> speakers,
  required String eventMode,
  required String type,
  required String image,
}) async {
  final url = Uri.parse('$baseUrl/events/byUser');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'user_id': userId,
        'event_name': eventName,
        'description': description,
        'event_start_date': eventStartDate,
        'event_end_date': eventEndDate,
        'poster_visibility_start_date': posterVisibilityStartDate,
        'poster_visibility_end_date': posterVisibilityEndDate,
        'platform': platform,
        'link': link,
        'venue': venue,
        'organiser_name': organiserName,
        'limit': limit,
        'speakers': speakers,
        'type': eventMode,
        'eventMode': type,
        'createdBy': id,
        'image': image,
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Event.fromJson(data);
    } else {
      print(json.decode(response.body)['message']);
      throw Exception(json.decode(response.body)['message']);
    }
  } catch (e) {
    print('An error occurred: $e');
    return null;
  }
}
=======
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/models/attendance_user_model.dart';
import 'package:familytree/src/data/models/events_model.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:http/http.dart' as http;
import 'package:familytree/src/data/globals.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'events_api.g.dart';

@riverpod
Future<List<Event>> fetchEvents(Ref ref) async {
  final url = Uri.parse('$baseUrl/events');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    log(response.body);
    List<Event> events = [];

    for (var item in data) {
      events.add(Event.fromJson(item));
    }
    print(events);
    return events;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

Future<Event> fetchEventById(id) async {
  final url = Uri.parse('$baseUrl/events/single/$id');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final dynamic data = json.decode(response.body)['data'];
    print(data['products']);

    return Event.fromJson(data);
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

@riverpod
Future<AttendanceUserListModel> fetchEventAttendance(
    FetchEventAttendanceRef ref,
    {required String eventId}) async {
  final url = Uri.parse('$baseUrl/events/attend/$eventId');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final dynamic data = json.decode(response.body)['data'];
    return AttendanceUserListModel.fromJson(data);
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

@riverpod
Future<List<Event>> fetchMyEvents(FetchMyEventsRef ref) async {
  final url = Uri.parse('$baseUrl/events/registered-events');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    print(response.body);
    List<Event> events = [];

    for (var item in data) {
      events.add(Event.fromJson(item));
    }
    log(events.toString());
    return events;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

Future<void> markEventAsRSVP(String eventId) async {
  final String url = '$baseUrl/events/$eventId';

  try {
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Success

      print('RSVP marked successfully');
    } else {
      // Handle error
      final dynamic data = json.decode(response.body)['message'];
      print('Failed to mark RSVP: ${data}');
    }
  } catch (e) {
    // Handle exceptions
    print('An error occurred: $e');
  }
}

Future<AttendanceUserModel?> markAttendanceEvent({
  required String eventId,
  required String userId,
}) async {
  SnackbarService snackbarService = SnackbarService();
  final String url = '$baseUrl/events/attend/$eventId';
  final Map<String, String> headers = {
    'accept': 'application/json',
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
  final Map<String, String> body = {
    'userId': userId,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final dynamic data = json.decode(response.body)['data'];

    print(data);
    return AttendanceUserModel.fromJson(data);
  } else {
    print(json.decode(response.body)['message']);
    snackbarService.showSnackBar(json.decode(response.body)['message']);
    return null;
    throw Exception(json.decode(response.body)['message']);
  }
}

Future<Event?> postEventByUser({
  required String userId,
  required String eventName,
  required String description,
  required String eventStartDate,
  required String eventEndDate,
  required String posterVisibilityStartDate,
  required String posterVisibilityEndDate,
  required String platform,
  required String link,
  required String venue,
  required String organiserName,
  required int limit,
  required List<Map<String, dynamic>> speakers,
  required String eventMode,
  required String type,
  required String image,
}) async {
  final url = Uri.parse('$baseUrl/events/byUser');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'user_id': userId,
        'event_name': eventName,
        'description': description,
        'event_start_date': eventStartDate,
        'event_end_date': eventEndDate,
        'poster_visibility_start_date': posterVisibilityStartDate,
        'poster_visibility_end_date': posterVisibilityEndDate,
        'platform': platform,
        'link': link,
        'venue': venue,
        'organiser_name': organiserName,
        'limit': limit,
        'speakers': speakers,
        'type': eventMode,
        'eventMode': type,
        'createdBy': id,
        'image': image,
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Event.fromJson(data);
    } else {
      print(json.decode(response.body)['message']);
      throw Exception(json.decode(response.body)['message']);
    }
  } catch (e) {
    print('An error occurred: $e');
    return null;
  }
}
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
