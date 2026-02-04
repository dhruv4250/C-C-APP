import 'package:flutter/material.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  // Form State
  String _selectedDocType = "Aadhaar Card";
  bool _isFileUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete KYC")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar
            Row(
              children: [
                _buildStep(1, "Basic", true),
                _buildLine(),
                _buildStep(2, "Docs", true), // Active
                _buildLine(),
                _buildStep(3, "Review", false),
              ],
            ),
            const SizedBox(height: 30),

            const Text("Identity Verification", 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("Government regulations require us to verify your identity before trading.",
                style: TextStyle(color: Colors.grey)),
            
            const SizedBox(height: 30),

            // 1. Document Type Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedDocType,
              decoration: _inputDeco("Document Type"),
              items: ["Aadhaar Card", "PAN Card", "GST Certificate", "Business License"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedDocType = val!),
            ),
            const SizedBox(height: 20),

            // 2. ID Number Input
            TextFormField(
              decoration: _inputDeco("ID / Certificate Number"),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 20),

            // 3. Document Upload Box
            const Text("Upload Photo of Document", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            
            GestureDetector(
              onTap: () {
                // Mock File Picker Logic
                setState(() => _isFileUploaded = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("File selected successfully!"))
                );
              },
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _isFileUploaded ? Colors.green.shade50 : Colors.grey.shade50,
                  border: Border.all(
                    color: _isFileUploaded ? Colors.green : Colors.grey.shade400,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isFileUploaded ? Icons.check_circle : Icons.camera_alt,
                      size: 40,
                      color: _isFileUploaded ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isFileUploaded ? "Document Attached" : "Tap to Upload Front Side",
                      style: TextStyle(
                        color: _isFileUploaded ? Colors.green : Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isFileUploaded 
                  ? () => _showSuccessDialog(context) 
                  : null, // Disabled until file uploaded
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: const Text("Submit for Verification"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildStep(int num, String label, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive ? Colors.blue : Colors.grey[300],
          child: Text("$num", style: const TextStyle(fontSize: 12, color: Colors.white)),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: isActive ? Colors.black : Colors.grey))
      ],
    );
  }

  Widget _buildLine() {
    return Expanded(child: Container(height: 2, color: Colors.grey[300], margin: const EdgeInsets.only(bottom: 15)));
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Column(
          children: [
            Icon(Icons.hourglass_top, size: 50, color: Colors.orange),
            SizedBox(height: 10),
            Text("Verification In Progress"),
          ],
        ),
        content: const Text(
          "We have received your documents. Verification typically takes 24-48 hours. You will be notified once approved.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close Dialog
              Navigator.pop(context); // Go back to Profile
            },
            child: const Text("Got it"),
          )
        ],
      ),
    );
  }
}