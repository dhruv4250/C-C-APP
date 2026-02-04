import 'package:flutter/material.dart';
import 'package:carbon_credit_gem/features/auth/services/api_service.dart';
import 'pin_setup_screen.dart'; // We will create this next

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _verifyOtp() async {
    setState(() => _isLoading = true);

    // Call Backend
    final result = await _apiService.verifyOtp(widget.phoneNumber, _otpController.text.trim());

    setState(() => _isLoading = false);

    if (result != null) {
      if (!mounted) return;
      // Navigate to PIN Screen
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => PinScreen(
          userId: result['user_id'], 
          isNewUser: result['isNewUser']
        ))
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid OTP. Try 1234.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verification"), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter OTP sent to +91 ${widget.phoneNumber}", 
              style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              maxLength: 4,
              decoration: InputDecoration(
                hintText: "- - - -",
                counterText: "",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                child: const Text("Verify OTP"),
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: Text("Use '1234' for testing", style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}