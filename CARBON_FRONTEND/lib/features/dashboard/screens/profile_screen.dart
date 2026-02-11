import 'package:flutter/material.dart';
import '../../auth/screens/kyc_verification_screen.dart';
 // Ensure this file exists in the same folder

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock User Status (Change this to true later to see the "Verified" view)
    bool isKycVerified = false; 

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("My Profile"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // 1. PROFILE HEADER
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                      if (isKycVerified)
                        const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.check_circle, color: Colors.blue, size: 28),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Trader Account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("+91 98765 43210", style: TextStyle(color: Colors.grey)),
                  
                  const SizedBox(height: 10),
                  
                  // Verification Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isKycVerified ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isKycVerified ? Colors.green : Colors.orange,
                      ),
                    ),
                    child: Text(
                      isKycVerified ? "Verified Merchant" : "KYC Pending",
                      style: TextStyle(
                        color: isKycVerified ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. ACTION REQUIRED CARD (If not verified)
            if (!isKycVerified)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Verification Required", 
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                          Text("Complete KYC to start selling credits.", 
                              style: TextStyle(fontSize: 12, color: Colors.brown)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => const KycVerificationScreen())
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text("Verify"),
                    )
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // 3. SETTINGS MENU
            _buildSettingsItem(Icons.history, "Transaction History", null),
            _buildSettingsItem(Icons.account_balance_wallet, "Bank Accounts", null),
            _buildSettingsItem(Icons.security, "Security & PIN", null),
            _buildSettingsItem(Icons.help_outline, "Help & Support", null),
            _buildSettingsItem(Icons.logout, "Logout", Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, Color? color) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1), // Separator effect
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.grey[700]),
        title: Text(title, style: TextStyle(color: color ?? Colors.black87)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}