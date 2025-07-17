import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';
import 'package:familytree/src/data/globals.dart';

class TopupPaymentService {
  final double amount;
  final Function(String message) onError;
  final Function(String message) onSuccess;

  final Razorpay _razorpay = Razorpay();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String donorName = "";
  String donorEmail = "";
  String donorPhone = "";

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
      donorName = user.fullName ?? "User";
      donorEmail = user.email ?? "unknown@example.com";
      donorPhone = user.phone ?? "+911234567890";

      final options = {
        'key': 'rzp_test_lDODXN89x37kcK', // Replace with live key in production
        'amount': (amount * 100).toInt(),
        'currency': 'INR',
        'name': 'Wallet Top-Up',
        'description': 'Add money to wallet',
        'prefill': {
          'contact': donorPhone,
          'email': donorEmail,
        },
      };

      _razorpay.open(options);
    } catch (e) {
      onError("Failed to start Razorpay: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    onSuccess("Payment successful.");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onError("Payment failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    onError("External wallet selected: ${response.walletName}");
  }
}
