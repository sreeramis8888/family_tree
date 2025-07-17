import 'dart:convert';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';
import 'package:familytree/src/data/models/campaign_model.dart';
import 'package:familytree/src/data/globals.dart';

class CampaignPaymentService {
  final CampaignModel campaign;
  final double amount;
  final Function(String message) onError;
  final Function(String message) onSuccess;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Razorpay _razorpay = Razorpay();

  String donorName = "";
  String donorEmail = "";
  String donorPhone = "";
  String donorID = "";

  CampaignPaymentService({
    required this.campaign,
    required this.amount,
    required this.onError,
    required this.onSuccess,
  });

  Razorpay get razorpay => _razorpay;

  void initRazorpayListeners() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  Future<void> startPaymentProcess() async {
    try {
      final user = await UserService.fetchUserDetails(id);
      donorName = user.fullName ?? "Donor";
      donorEmail = user.email ?? "unknown@example.com";
      donorPhone = user.phone ?? "+911234567890";
      donorID = user.id ?? "";

      await _createOrder();
    } catch (e) {
      onError("Failed to get user info.");
    }
  }

  Future<void> _createOrder() async {
    final url = Uri.parse('$baseUrl/payments/campaign/create-order');

    try {
      final token = await _storage.read(key: 'authToken');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "personId": donorID,
          "campaignId": campaign.id,
          "amount": amount,
          "donorName": donorName,
          "donorEmail": donorEmail,
          "donorPhone": donorPhone,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final order = json['data']?['order'];
        if (order != null && order['id'] != null) {
          _openRazorpay(order['id']);
        } else {
          onError("Invalid Razorpay order data.");
        }
      } else {
        onError("Failed to create Razorpay order.");
      }
    } catch (e) {
      onError("Something went wrong during order creation.");
    }
  }

  void _openRazorpay(String orderId) {
    final options = {
      'key': 'rzp_test_lDODXN89x37kcK',
      'amount': (amount * 100).toInt(),
      'currency': 'INR',
      'name': campaign.title,
      'description': 'Campaign Donation',
      'order_id': orderId,
      'prefill': {
        'contact': donorPhone,
        'email': donorEmail,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      onError("Could not open Razorpay.");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final verifyUrl = Uri.parse("$baseUrl/payments/verify");

    try {
      final token = await _storage.read(key: 'authToken');

      final verifyResponse = await http.post(
        verifyUrl,
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "razorpay_payment_id": response.paymentId,
          "razorpay_order_id": response.orderId,
          "razorpay_signature": response.signature,
        }),
      );

      if (verifyResponse.statusCode == 200) {
        onSuccess("Donation successful. Thank you!");
      } else {
        onError("Payment verification failed.");
      }
    } catch (e) {
      onError("Could not verify the payment.");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onError("Payment failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    onError("External wallet selected: ${response.walletName}");
  }
}
