import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';
import 'package:familytree/src/data/globals.dart';

class TopupPaymentService {
  final int amount;
  final Function(String message) onError;
  final Function(String message) onSuccess;

  final Razorpay _razorpay = Razorpay();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String donorName = "";
  String donorEmail = "";
  String donorPhone = "";
  String donorID = "";

  TopupPaymentService({
    required this.amount,
    required this.onError,
    required this.onSuccess,
  });

  void init() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  Future<void> startPayment() async {
    try {
      final user = await UserService.fetchUserDetails(id);
      donorName = user.fullName ?? "";
      donorEmail = user.email ?? "";
      donorPhone = user.phone ?? "";
      donorID = user.id ?? "";

      await _createOrder();
    } catch (e) {
      onError("Failed to get user info.");
    }
  }

  Future<void> _createOrder() async {
    final url = Uri.parse('$baseUrl/payments/wallet/create-order');
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
          "amount": amount,
          "currency": "INR",
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final order = json['data']?['order'];
        if (order != null && order['id'] != null) {
          final int razorpayAmount = order['amount'];
          _openRazorpay(order['id'], razorpayAmount);
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

  void _openRazorpay(String orderId, int razorpayAmount) {
    final options = {
      'key': 'rzp_test_SV7cfi5qGS7db9',
      'amount': razorpayAmount,
      'currency': 'INR',
      'name': 'Wallet Top-Up',
      'description': 'Add money to wallet',
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
        onSuccess("Wallet recharge successful!");
      } else {
        onError("Payment verification failed.");
      }
    } catch (e) {
      onError("Could not verify the payment.");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onError("Payment failed:  [${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    onError("External wallet selected:  [${response.walletName}");
  }
}
