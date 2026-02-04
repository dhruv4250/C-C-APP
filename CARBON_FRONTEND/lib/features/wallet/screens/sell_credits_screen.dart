import 'package:flutter/material.dart';

class SellCreditsScreen extends StatefulWidget {
  const SellCreditsScreen({super.key});

  @override
  State<SellCreditsScreen> createState() => _SellCreditsScreenState();
}

class _SellCreditsScreenState extends State<SellCreditsScreen> {
  String? _selectedType;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List New Credits"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Asset Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // 1. Credit Type
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Credit Type"),
              items: ["Solar Energy", "Wind Power", "Reforestation", "Biogas", "Hydro"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedType = val),
            ),
            const SizedBox(height: 16),
            
            // 2. Tonnage
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("Total Tonnage Available"),
            ),
            const SizedBox(height: 16),
            
            // 3. Price
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("Price Per Ton (₹)"),
            ),
            
            const SizedBox(height: 30),
            const Text("Verification Documents", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("Upload audit certificate (PDF/JPG) to prove ownership.", 
              style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 16),
            
            // 4. File Upload Area
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text("Tap to browse files", style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                   // Logic: Show success dialog and go back
                   showDialog(context: context, builder: (_) => AlertDialog(
                     title: const Text("Submitted for Review"),
                     content: const Text("Our team will verify your documents within 24-48 hours. Once approved, your credits will be live."),
                     actions: [
                       TextButton(
                         onPressed: () { 
                           Navigator.pop(context); // Close dialog
                           Navigator.pop(context); // Go back to home
                         },
                         child: const Text("OK"),
                       )
                     ],
                   ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Submit for Verification"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}