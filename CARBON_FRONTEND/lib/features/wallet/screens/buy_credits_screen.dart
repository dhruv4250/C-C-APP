import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../features/auth/services/api_service.dart';
import '../../../core/widgets/success_screen.dart';
import '../../../features/auth/screens/success_screen.dart';


// Change to ConsumerWidget (Stateless is fine now!)
class BuyCreditsScreen extends ConsumerStatefulWidget {
  const BuyCreditsScreen({super.key});

  @override
  ConsumerState<BuyCreditsScreen> createState() =>
      _BuyCreditsScreenState();
}
class _BuyCreditsScreenState
    extends ConsumerState<BuyCreditsScreen> {
final ApiService _apiService = ApiService();
late Future<List<dynamic>> _listingsFuture;
@override
void initState() {
  super.initState();
  _listingsFuture = _apiService.getNearbySellers(
    22.3039,
    70.8022,
  );
}


 @override
Widget build(BuildContext context) {
// Add WidgetRef ref
    // 1. Fetch data using provider (Hardcoded Rajkot coords for now)
    final listingsAsync = ref.watch(marketListingsProvider({'lat': 22.3039, 'long': 70.8022}));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text("Buy Credits"), backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
      body: Column(
        children: [
          // Filter Bar... (Keep existing code)

          // 2. Use Riverpod to handle the list
          Expanded(
            child: listingsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (listings) {
                if (listings.isEmpty) return const Center(child: Text("No sellers nearby."));
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: listings.length,
                  itemBuilder: (context, index) => _buildListingCard(context, listings[index], ref),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Update _buildListingCard to accept 'ref'
  Widget _buildListingCard(BuildContext context, dynamic item, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    // Simple check for icon type
                    item['type'].toString().contains('Solar')
                        ? Icons.wb_sunny
                        : Icons.forest,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['seller_name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${item['type']} • ${item['distance_km']} km away",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${item['price']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      "/ ton",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available: ${item['available']} tons",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _showPurchaseSheet(context, item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Buy Now"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // THE CHECKOUT SHEET (Updated with API Call)
  void _showPurchaseSheet(BuildContext context, dynamic item) {
    int quantity = 1;
    bool isProcessing = false; // To show loading spinner on button

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            double total = (quantity * (item['price'] as num)).toDouble();

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Purchase from ${item['seller_name']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Quantity (Tons)"),
                      Text(
                        "$quantity",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: quantity.toDouble(),
                    min: 1,
                    max: (item['available'] as int).toDouble(),
                    activeColor: const Color(0xFF00C853),
                    onChanged: (val) =>
                        setSheetState(() => quantity = val.round()),
                  ),

                  const SizedBox(height: 20),

                  // Total Price
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Payable"),
                        Text(
                          "₹${total.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CONFIRM BUTTON WITH API CALL
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),

                      onPressed: isProcessing
                          ? null
                          : () async {
                              setSheetState(() => isProcessing = true);

                              bool success = await _apiService.buyCredits(
                                item['id'],
                                quantity,
                              );

                              setSheetState(() => isProcessing = false);
                              Navigator.pop(sheetContext); // close bottom sheet

                              if (success) {
                                // Refresh listings
                                setState(() {
                                  _listingsFuture = _apiService
                                      .getNearbySellers(22.3039, 70.8022);
                                });

                                // Navigate to success screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SuccessScreen(
                                      message:
                                          "You have successfully purchased $quantity tons of carbon credits from ${item['seller_name']}.",
                                      actionLabel: "View Certificate",
                                      onActionPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Trade Failed. Insufficient Balance?",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },

                      child: isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Confirm & Pay"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
