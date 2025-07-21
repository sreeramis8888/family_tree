import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'relationship_api.g.dart';

class RelationshipApi {
  static Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
    'accept': '*/*',
  };

  static Future<bool> createRelationship({
    required String person1,
    required String person2,
    required String type,
  }) async {
    final url = Uri.parse('$baseUrl/relationships');
    final body = {
      'person1': person1,
      'person2': person2,
      'type': type,
    };
    try {
      final response = await http.post(
        url,
        headers: _headers(),
        body: jsonEncode(body),
      );
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 201) {
        SnackbarService().showSnackBar(jsonResponse['message'] ?? 'Relationship created successfully');
        return true;
      } else {
        SnackbarService().showSnackBar(jsonResponse['message'] ?? 'Failed to create relationship');
        return false;
      }
    } catch (e) {
      SnackbarService().showSnackBar('Error creating relationship: ${e.toString()}');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchRelationships({required String personId}) async {
    final url = Uri.parse('$baseUrl/relationships?personId=$personId');
    try {
      final response = await http.get(url, headers: _headers());
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final relationships = jsonResponse['data']['relationships'] as List<dynamic>;
        return relationships.cast<Map<String, dynamic>>();
      } else {
        SnackbarService().showSnackBar(jsonResponse['message'] ?? 'Failed to fetch relationships');
        return [];
      }
    } catch (e) {
      SnackbarService().showSnackBar('Error fetching relationships: ${e.toString()}');
      return [];
    }
  }

  static Future<bool> deleteRelationship({required String relationshipId}) async {
    final url = Uri.parse('$baseUrl/relationships/$relationshipId');
    try {
      final response = await http.delete(url, headers: _headers());
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        SnackbarService().showSnackBar(jsonResponse['message'] ?? 'Relationship deleted successfully');
        return true;
      } else {
        SnackbarService().showSnackBar(jsonResponse['message'] ?? 'Failed to delete relationship');
        return false;
      }
    } catch (e) {
      SnackbarService().showSnackBar('Error deleting relationship: ${e.toString()}');
      return false;
    }
  }
}

@riverpod
Future<List<Map<String, dynamic>>> fetchRelationships(FetchRelationshipsRef ref, String personId) =>
    RelationshipApi.fetchRelationships(personId: personId); 