import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carbon_credit_gem/features/auth/services/api_service.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _historyFuture;

  @override
  void initState() {
    super.initState();
    // Hardcoded 'u1' for prototype. In real app, use the logged-in user's ID
    _historyFuture = _apiService.getHistory('u1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Wallet History"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No transactions yet."));
          }

          final transactions = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return _buildTransactionCard(tx);
            },
          );
        },
      ),
    );
  }

  Widget _buildTransactionCard(dynamic tx) {
    bool isCredit = tx['type'] == 'SELL'; // If I sold, money comes in (Green)
    
    // Parse Date
    DateTime date = DateTime.parse(tx['date']);
    String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isCredit ? Colors.green.shade50 : Colors.blue.shade50,
          child: Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: isCredit ? Colors.green : Colors.blue,
          ),
        ),
        title: Text(tx['seller_name'] ?? "Unknown", 
          style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text("Offset: ${tx['amount_tons']} Tons CO2", 
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${isCredit ? '+' : '-'} ₹${tx['price_total']}",
              style: TextStyle(
                color: isCredit ? Colors.green : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (tx['type'] == 'BUY')
              GestureDetector(
                onTap: () => _showCertificate(tx),
                child: const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text("View Certificate", 
                    style: TextStyle(color: Colors.blue, fontSize: 10, decoration: TextDecoration.underline)),
                ),
              )
          ],
        ),
      ),
    );
  }

  void _showCertificate(dynamic tx) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, size: 60, color: Colors.green),
              const SizedBox(height: 16),
              const Text("Certificate of Ownership", 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(height: 30),
              _certRow("Transaction ID", tx['id'].toString().substring(0, 8)),
              _certRow("Owner", "Demo Trader"),
              _certRow("Source", tx['seller_name']),
              _certRow("Volume", "${tx['amount_tons']} Tons"),
              const SizedBox(height: 20),
              const Text("This digital record certifies that the carbon credits described above have been legally transferred.",
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _certRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  
  
}