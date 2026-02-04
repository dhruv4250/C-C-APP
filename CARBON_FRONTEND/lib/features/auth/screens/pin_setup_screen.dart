import 'package:flutter/material.dart';
import 'package:carbon_credit_gem/features/auth/services/api_service.dart';
import '../../dashboard/screens/home_screen.dart';

class PinScreen extends StatefulWidget {
  final String userId;
  final bool isNewUser;
  
  const PinScreen({super.key, required this.userId, required this.isNewUser});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _submitPin() async {
    setState(() => _isLoading = true);

    // Call Backend
    bool success = await _apiService.loginWithPin(widget.userId, _pinController.text.trim());

    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      // Login Complete! Go to Dashboard
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (_) => const HomeScreen()), 
        (route) => false // Remove back history
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect PIN.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 50, color: Colors.blue),
              const SizedBox(height: 20),
              
              Text(widget.isNewUser ? "Create App PIN" : "Enter App PIN",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              
              const SizedBox(height: 10),
              Text(widget.isNewUser 
                ? "Set a 4-digit PIN to secure your wallet." 
                : "Enter your 4-digit PIN to login.",
                textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
              
              const SizedBox(height: 30),
              
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 8),
                maxLength: 4,
                decoration: InputDecoration(
                  counterText: "",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitPin,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), foregroundColor: Colors.white),
                  child: Text(widget.isNewUser ? "Set PIN" : "Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}