import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/payment_service.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  late PaymentService _paymentService;
  bool _isLoading = false;

  // ⚠️ REPLACE WITH YOUR TEST KEY ID FROM RAZORPAY
  static const String RAZORPAY_KEY = 'rzp_test_YOUR_KEY_HERE';

  @override
  void initState() {
    super.initState();
    _paymentService = PaymentService(
      onPaymentSuccess: _handlePaymentSuccess,
      onPaymentError: _handlePaymentError,
    );
  }

  Future<void> _buyPremium() async {
    setState(() => _isLoading = true);

    _paymentService.initiatePayment(
      keyId: RAZORPAY_KEY,
      amountInPaise: 4900, // ₹49
      productName: 'Remove Ads Forever',
      userEmail: 'demo@example.com',
      userPhone: '+919999999999',
    );
  }

  void _handlePaymentSuccess(bool success) {
    if (!mounted) return;

    setState(() => _isLoading = false);

    // ✅ Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Premium activated successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // ✅ Wait 1 second then close the screen
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Get.back(result: true); // ← Use GetX to pop, not Navigator
      }
    });
  }

  void _handlePaymentError(String error) {
    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Payment failed: $error'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Membership')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade400, Colors.orange.shade500],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Icon(Icons.star, size: 80, color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'Go Premium',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Benefits
            const Text(
              'Premium Features:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildBenefit('🚫 No Ads'),
            _buildBenefit('🖼️ 4K Wallpapers'),
            _buildBenefit('⚡ Fast Downloads'),
            _buildBenefit('♾️ Lifetime Access'),
            const SizedBox(height: 30),

            // Price
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                children: [
                  Text(
                    '₹49',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text('One-time payment (Test Mode)'),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Buy Button
            ElevatedButton(
              onPressed: _isLoading ? null : _buyPremium,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
                  : const Text(
                'Buy Premium Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
