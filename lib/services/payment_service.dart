import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

typedef PaymentSuccessCallback = void Function(bool success);
typedef PaymentErrorCallback = void Function(String error);

class PaymentService {
  late Razorpay _razorpay;
  final PaymentSuccessCallback onPaymentSuccess;
  final PaymentErrorCallback onPaymentError;

  PaymentService({
    required this.onPaymentSuccess,
    required this.onPaymentError,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> initiatePayment({
    required String keyId,
    required int amountInPaise,
    required String productName,
    required String userEmail,
    required String userPhone,
  }) async {
    try {
      var options = {
        'key': keyId,
        'amount': amountInPaise, // Amount in paise (₹49 = 4900 paise)
        'name': 'GameArt Premium',
        'description': productName,
        'retry': {'enabled': true, 'max_count': 1},
        'prefill': {
          'contact': userPhone,
          'email': userEmail,
        },
        'external': {
          'wallets': ['paytm'],
        },
      };

      _razorpay.open(options);
    } catch (e) {
      print('Payment Error: $e');
      onPaymentError(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('✅ Payment Success: ${response.paymentId}');
    onPaymentSuccess(true);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('❌ Payment Error: ${response.message}');
    onPaymentError(response.message ?? 'Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('📱 External Wallet: ${response.walletName}');
    onPaymentError('Payment cancelled');
  }

  void dispose() {
    _razorpay.clear();
  }
}
