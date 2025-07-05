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
