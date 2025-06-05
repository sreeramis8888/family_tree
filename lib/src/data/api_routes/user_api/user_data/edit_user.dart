import 'dart:convert';
import 'dart:developer';
import 'package:familytree/src/data/models/product_model.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:http/http.dart' as http;
import 'package:familytree/src/data/globals.dart';

Future<String> editUser(Map<String, dynamic> profileData) async {
  final url = Uri.parse('$baseUrl/user/update');
  log('requesting url:$url');
  final response = await http.patch(
    url,
    headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(profileData),
  );

  if (response.statusCode == 200) {
    print('Profile updated successfully');
    print(json.decode(response.body)['message']);
    return json.decode(response.body)['message'];
  } else {
    print(json.decode(response.body)['message']);
    print('Failed to update profile. Status code: ${response.statusCode}');
    return json.decode(response.body)['message'];
  }
}

Future<String> changeNumber(String phone) async {
  final url = Uri.parse('$baseUrl/user/change-phone-number');
  log('requesting url:$url');
  final response = await http.patch(
    url,
    headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({"phone": phone}),
  );

  if (response.statusCode == 200) {
    print('Profile updated successfully');
    print(json.decode(response.body)['message']);
    return json.decode(response.body)['message'];
  } else {
    print(json.decode(response.body)['message']);

    print('Failed to update profile. Status code: ${response.statusCode}');
    return json.decode(response.body)['message'];
    // throw Exception('Failed to update profile');
  }
}

Future<Product?> uploadProduct({
  required String name,
  required String price,
  required String offerPrice,
  required String description,
  required String moq,
  required String productImage,
  required String productPriceType,
}) async {
  SnackbarService snackbarService = SnackbarService();
  final url = Uri.parse('$baseUrl/product/user');

  final body = {
    'name': name,
    'price': price,
    'offerPrice': offerPrice,
    'description': description,
    'seller': id,
    'moq': moq,
    'status': 'pending',
    'units': productPriceType,
    'image': productImage,
  };
  log(body.toString());
  try {
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final Product product = Product.fromJson(jsonResponse['data']);
      return product;
    } else {
      final jsonResponse = json.decode(response.body);
      snackbarService.showSnackBar(jsonResponse['message']);
      print('Failed to upload product: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error occurred: $e');
    snackbarService.showSnackBar('Something went wrong. Please try again.');
    return null;
  }
}

Future<void> deleteProduct(String productId) async {
  final url = Uri.parse('$baseUrl/product/user/$productId');
  print('requesting url:$url');
  final response = await http.delete(
    url,
    headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('product removed successfully');
  } else {
    final jsonResponse = json.decode(response.body);

    print(jsonResponse['message']);
    print('Failed to delete image: ${response.statusCode}');
  }
}

Future<void> postReview(
    String userId, String content, int rating, context) async {
  SnackbarService snackbarService = SnackbarService();
  final url = Uri.parse('$baseUrl/review');
  final headers = {
    'accept': 'application/json',
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final body = json.encode({
    'toUser': userId,
    'comment': content,
    'rating': rating,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Review posted successfully');
      snackbarService.showSnackBar('Review posted successfully');
    } else {
      print('Failed to post review: ${response.statusCode}');
      print('Response body: ${response.body}');
      snackbarService.showSnackBar('Failed to post review');
    }
  } catch (e) {
    print('Error: $e');
  }
}
