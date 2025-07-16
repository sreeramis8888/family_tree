import 'dart:convert';
import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/models/campaign_model.dart';

class CampaignPaymentPage extends StatefulWidget {
  final CampaignModel campaign;
  final double amount;

  const CampaignPaymentPage({
    super.key,
    required this.campaign,
    required this.amount,
  });

  @override
  State<CampaignPaymentPage> createState() => _CampaignPaymentPageState();
}

class _CampaignPaymentPageState extends State<CampaignPaymentPage> {
  late Razorpay _razorpay;
  final storage = const FlutterSecureStorage();
  String donorName = "";
  String donorEmail = "";
  String donorPhone = "";
  String donorID = "";

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Wait until context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserDetailsAndCreateOrder();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _loadUserDetailsAndCreateOrder() async {
    try {
      final user = await UserService.fetchUserDetails(id);
      donorName = user.fullName ?? "Donor";
      donorEmail = user.email ?? "unknown@example.com";
      donorPhone = user.phone ?? "+911234567890";
      donorID = user.id ?? "";

      await _createOrder();
    } catch (e) {
      debugPrint("❌ Failed to fetch user details: $e");
      _showSnackBar("Failed to get user info. Please try again.");
      Navigator.pop(context);
    }
  }

  Future<void> _createOrder() async {
    final url = Uri.parse('$baseUrl/payments/campaign/create-order');

    try {
      final token = await storage.read(key: 'authToken');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "personId": donorID,
          "campaignId": widget.campaign.id,
          "amount": widget.amount,
          "donorName": donorName,
          "donorEmail": donorEmail,
          "donorPhone": donorPhone,
        }),
      );

      debugPrint("📦 RESPONSE STATUS: ${response.statusCode}");
      debugPrint("📦 RESPONSE BODY:\n${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final order = json['data']?['order'];
        if (order != null && order['id'] != null) {
          _openRazorpay(order['id'], widget.amount);
        } else {
          _showSnackBar("Invalid Razorpay order data received.");
        }
      } else {
        _showSnackBar("Failed to create Razorpay order.");
      }
    } catch (e) {
      debugPrint("❌ Order creation error: $e");
      _showSnackBar("Something went wrong. Please try again.");
    }
  }

  void _openRazorpay(String orderId, double amount) {
    final options = {
      'key': 'rzp_test_lDODXN89x37kcK',
      'amount': (amount * 100).toInt(),
      'currency': 'INR',
      'name': widget.campaign.title,
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
      debugPrint('⚠️ Razorpay open error: $e');
      _showSnackBar("Could not open payment gateway.");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final verifyUrl = Uri.parse("$baseUrl/payments/verify");

    try {
      final token = await storage.read(key: 'authToken');

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

      debugPrint("✅ VERIFICATION STATUS: ${verifyResponse.statusCode}");
      debugPrint("✅ VERIFICATION BODY:\n${verifyResponse.body}");

      if (verifyResponse.statusCode == 200) {
        _showSnackBar("🎉 Donation successful. Thank you!");
        Navigator.pop(context);
      } else {
        _showSnackBar("Payment verification failed.");
      }
    } catch (e) {
      debugPrint("❌ Verification error: $e");
      _showSnackBar("Could not verify the payment.");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("❌ Payment Error: ${response.code} - ${response.message}");
    _showSnackBar("Payment failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("💳 External Wallet: ${response.walletName}");
    _showSnackBar("External wallet selected: ${response.walletName}");
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Processing Donation")),
      body: const Center(child: LoadingAnimation()),
    );
  }
}
