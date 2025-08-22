import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/src/framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:familytree/src/data/models/request_model.dart';
import 'package:familytree/src/data/globals.dart';

part 'request_api.g.dart';

@riverpod
Future<RequestWithPerson> fetchRequestWithPersonAndRelationships(
  Ref ref,
  String requestId,
) async {
  final requestRes = await http.get(
    Uri.parse('$baseUrl/requests/$requestId'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (requestRes.statusCode != 200) {
    throw Exception('Failed to load request');
  }

  final decoded = jsonDecode(requestRes.body);
  final data = decoded['data'];

  final baseRequest = RequestModel.fromJson(data);

  // Handle createdPersonId details
  final createdPerson = data['createdPersonId'];
  final fullName = createdPerson?['fullName'] ?? 'N/A';
  final phone = createdPerson?['phone'] ?? 'N/A';

  // Enrich relationships by fetching each person
  List<Relationship> enrichedRelationships = [];

  for (final rel in baseRequest.relationships) {
    String? relName;
    String? relPhone;

    final personRes = await http.get(
      Uri.parse('$baseUrl/people/${rel.personId}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (personRes.statusCode == 200) {
      final personData = jsonDecode(personRes.body)['data'];
      relName = personData['fullName'] ?? personData['name'];
      relPhone = personData['phone'];
    }

    enrichedRelationships.add(Relationship(
      personId: rel.personId,
      type: rel.type,
      id: rel.id,
      relatedPersonName: relName,
      relatedPersonPhone: relPhone,
    ));
  }

  // Create final enriched RequestModel
  final enrichedRequest = RequestModel(
    id: baseRequest.id,
    fullName: baseRequest.fullName,
    status: baseRequest.status,
    familyId: baseRequest.familyId,
    email: baseRequest.email,
    phone: baseRequest.phone,
    createdPersonId: baseRequest.createdPersonId,
    relationships: enrichedRelationships,
  );

  return RequestWithPerson(
    request: enrichedRequest,
    fullName: fullName,
    phone: phone,
  );
}

@riverpod
Future<List<RequestModel>> fetchAllMembershipRequests(
  FetchAllMembershipRequestsRef ref,
) async {
  List<String> statuses = ['pending', 'approved', 'rejected'];
  List<RequestModel> allRequests = [];

  for (final status in statuses) {
    final uri = Uri.parse('$baseUrl/requests/family/all?status=$status');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> requests = data['data'];

      final parsed = requests
          .map((json) => RequestModel.fromJson(json as Map<String, dynamic>))
          .toList();

      allRequests.addAll(parsed);
    } else {
      throw Exception('Failed to fetch $status: ${response.statusCode}');
    }
  }

  return allRequests;
}

Future<void> updateRequestStatus({
  required String requestId,
  required String status, // "approved" or "rejected"
  String? reviewNotes,
}) async {
  final uri = Uri.parse('$baseUrl/requests/$requestId/review');

  try {
    final response = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'status': status,
        'reviewNotes': reviewNotes ?? '',
      }),
    );

    if (response.statusCode == 200) {
      debugPrint(' Request $requestId successfully updated to $status');
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['data']?['error']?.toString() ?? "";

      
      if (errorMessage.contains('E11000') && errorMessage.contains('phone')) {
        throw Exception(
            'Phone number already exists. This request may be a duplicate.');
      }

      throw Exception('Failed to update request status: ${response.body}');
    }
  } catch (e) {
    debugPrint('❗ Error updating request: $e');
    rethrow;
  }
}
