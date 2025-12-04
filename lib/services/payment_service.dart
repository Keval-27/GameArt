import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  late Razorpay _razorpay;
  final Function(bool) onPaymentSuccess;
  final Function(String) onPaymentError;

  PaymentService({
    required this.onPaymentSuccess,
    required this.onPaymentError,
  }) {
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void initiatePayment({
    required String keyId,
    required int amountInPaise,
    required String productName,
    required String userEmail,
    required String userPhone,
  }) {
    var options = {
      'key': keyId,
      'amount': amountInPaise,
      'currency': 'INR',
      'name': 'GameArt Wallpapers',
      'description': productName,
      'prefill': {
        'contact': userPhone,
        'email': userEmail,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      onPaymentError('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('✅ Payment Success: ${response.paymentId}');
    // Handle null paymentId with fallback
    final paymentId = response.paymentId ?? 'premium_${DateTime.now().millisecondsSinceEpoch}';
    _savePremiumStatus(paymentId);
    onPaymentSuccess(true);
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    print('❌ Payment Error: ${response.message}');
    onPaymentError(response.message ?? 'Payment failed');
  }

  Future<void> _savePremiumStatus(String paymentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', true);
    await prefs.setString('premiumPaymentId', paymentId);
  }

  static Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isPremium') ?? false;
  }

  void dispose() {
    _razorpay.clear();
  }
}
