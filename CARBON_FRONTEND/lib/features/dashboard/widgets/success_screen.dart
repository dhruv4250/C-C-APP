import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

class SuccessScreen extends StatefulWidget {
  final String message;
  final VoidCallback onActionPressed;
  final String actionLabel;

  const SuccessScreen({
    super.key, 
    required this.message, 
    required this.onActionPressed,
    this.actionLabel = "Done"
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // 1. Lottie Animation (The "Wow" Factor)
              // We use a network URL for the prototype. In production, download the JSON file.
              Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_t24tpvcu.json', // Green Checkmark
                repeat: false,
                height: 200,
                width: 200,
              ),

              const SizedBox(height: 40),

              // 2. Success Text (Fade In)
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: Text(
                  "Success!",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 600),
                child: Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

              const Spacer(),

              // 3. Action Button (Pop up)
              ElasticIn(
                delay: const Duration(milliseconds: 600),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: widget.onActionPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(widget.actionLabel, 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}