import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const SuccessScreen({
    super.key,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Success'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 90,
                color: Colors.green,
              ),

              const SizedBox(height: 24),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 32),

              // ✅ Optional action button
              if (actionLabel != null && onActionPressed != null)
                ElevatedButton(
                  onPressed: onActionPressed,
                  child: Text(actionLabel!),
                ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
