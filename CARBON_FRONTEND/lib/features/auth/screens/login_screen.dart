import 'package:flutter/material.dart';
import 'package:carbon_credit_gem/features/auth/services/api_service.dart';
import 'otp_screen.dart'; // We will create this next

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _handleLogin() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Phone Number")));
      return;
    }

    setState(() => _isLoading = true);

    // Call Backend
    bool success = await _apiService.sendOtp(phone);

    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      // Navigate to OTP Screen
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => OtpScreen(phoneNumber: phone))
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to send OTP. Is Server running?")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.eco, size: 60, color: Color(0xFF00C853)),
              const SizedBox(height: 20),
              
              Text("Welcome to\nCarbon Wallet",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      )),
              const SizedBox(height: 10),
              const Text("Enter your mobile number to start trading verified credits.",
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              
              const SizedBox(height: 40),
              
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  prefixText: "+91 ",
                  labelText: "Mobile Number",
                  counterText: "", // Hides the 0/10 counter
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Get OTP", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  
}

