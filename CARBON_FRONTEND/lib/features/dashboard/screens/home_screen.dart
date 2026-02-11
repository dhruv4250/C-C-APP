import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:animate_do/animate_do.dart';
import '../../../core/providers/app_providers.dart';
import '../../wallet/screens/buy_credits_screen.dart';
import '../../wallet/screens/sell_credits_screen.dart';
import '../../wallet/screens/transaction_history_screen.dart';
import '../../dashboard/screens/profile_screen.dart';
import 'map_view_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0; 

  @override
  Widget build(BuildContext context) {
    // Access Data
    final locationAsync = ref.watch(locationProvider);
    final balance = ref.watch(userBalanceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Very soft mint background
      
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Background Decorative Elements (Clouds)
            
            Positioned(
              top: -50, right: -50,
              child: Opacity(opacity: 0.5, child: Image.network("https://cdn-icons-png.flaticon.com/512/414/414825.png", height: 200)),
            ),
            
            // MAIN CONTENT SCROLLABLE
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100), // Bottom padding for nav bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // --- 1. TOP HEADER (Name & Location) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Hello, Trader 👋", 
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Color(0xFF43A047)),
                              const SizedBox(width: 4),
                              locationAsync.when(
                                data: (address) => Text(address.split(',')[0], // City only
                                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
                                loading: () => const Text("Locating...", style: TextStyle(fontSize: 14, color: Colors.grey)),
                                error: (_, __) => const Text("Unknown Location", style: TextStyle(fontSize: 14, color: Colors.grey)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.green, width: 2)),
                          child: const CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11"), // Mock Profile Pic
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 25),

                  // --- 2. HERO CARD (The "Tree" Card) ---
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      width: double.infinity,
                      height: 260,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)], // Premium Green Gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF2E7D32).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))
                        ]
                      ),
                      child: Stack(
                        children: [
                          // 3D Tree Image (Network Image)
                          // 3D Tree Image (Asset Image)
                          // Animated 3D Tree (GIF)
                          Positioned(
                            bottom: 0,
                            right: -20,
                            child: Image.asset(
                              "images/tree7.gif", // <--- Points to your GIF
                              height: 180,               // Adjust size if needed
                              fit: BoxFit.cover,
                              gaplessPlayback: true,     // Prevents flickering when the GIF loops
                            ),
                          ),
                          // Clouds inside card
                          Positioned(
                            top: 20, left: 150,
                            child: Opacity(opacity: 0.2, child: Icon(Icons.cloud, size: 60, color: Colors.white)),
                          ),

                          // Text Content
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Balance Label
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                                  child: const Text("Total Carbon Credit", style: TextStyle(color: Colors.white, fontSize: 12)),
                                ),
                                const SizedBox(height: 10),
                                // Big Balance Number
                                Text("${balance['carbon']}", 
                                  style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: -1)),
                                const Text("Tons CO2 Offset", style: TextStyle(color: Colors.white70, fontSize: 14)),
                                
                                const Spacer(),
                                
                                // Wallet Balance Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.account_balance_wallet, color: Color.fromARGB(204, 115, 220, 120), size: 18),
                                      const SizedBox(width: 8),
                                      Text("₹ ${balance['fiat']}", 
                                        style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- 3. GRAPH & STATS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Your Carbon Impact", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                      Container(
                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                         child: const Text("This Month", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 180,
                    padding: const EdgeInsets.only(right: 20, top: 20, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 5))]
                    ),
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [FlSpot(0, 2), FlSpot(1, 1.5), FlSpot(2, 3), FlSpot(3, 2.8), FlSpot(4, 4.5), FlSpot(5, 4)],
                            isCurved: true,
                            color: const Color(0xFF43A047),
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: true, color: const Color(0xFF43A047).withOpacity(0.1)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- 4. QUICK ACTIONS ---
                  const Text("Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: _buildActionButton("Buy Credits", Icons.add_shopping_cart, const Color(0xFFE8F5E9), const Color(0xFF2E7D32), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BuyCreditsScreen())))),
                      const SizedBox(width: 15),
                      Expanded(child: _buildActionButton("Sell Credits", Icons.sell, const Color(0xFFFFF3E0), Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SellCreditsScreen())))),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- 5. NEARBY SELLERS (Restored) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Nearby Sellers (50km)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                      TextButton(onPressed: (){}, child: const Text("See All", style: TextStyle(color: Color(0xFF43A047))))
                    ],
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      children: [
                        _buildSellerCard("Solar Farm A", "500 Tons", "5km", Icons.wb_sunny, Colors.orange),
                        _buildSellerCard("Green Corp", "120 Tons", "12km", Icons.eco, Colors.green),
                        _buildSellerCard("Wind Energy", "1k Tons", "22km", Icons.air, Colors.blue),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --- 6. RECENT LISTINGS (Restored) ---
                   const Text("Recent Listings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                   const SizedBox(height: 15),
                   _buildListingItem("Reforestation Project", "₹800/ton", true),
                   _buildListingItem("Biogas Plant Unit", "₹650/ton", false),
                ],
              ),
            ),

            // --- FLOATING NAV BAR ---
            Positioned(
              bottom: 20, left: 20, right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, 10))]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavItem(0, Icons.home_rounded),
                    _buildNavItem(1, Icons.map_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapViewScreen()))),
                    _buildNavItem(2, Icons.receipt_long_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()))),
                    _buildNavItem(3, Icons.person_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()))),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildActionButton(String label, IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            CircleAvatar(radius: 25, backgroundColor: bgColor, child: Icon(icon, color: iconColor)),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
          ],
        ),
      ),
    );
  }

  Widget _buildSellerCard(String name, String volume, String distance, IconData icon, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 15, bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 5, spreadRadius: 1)]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), radius: 20, child: Icon(icon, color: color, size: 20)),
          const Spacer(),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1),
          const SizedBox(height: 4),
          Text(volume, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
          Text(distance, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildListingItem(String title, String price, bool isVerified) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.forest, color: Color(0xFF2E7D32)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    if(isVerified) const Icon(Icons.verified, size: 16, color: Colors.blue)
                  ],
                ),
                Text(isVerified ? "Verified" : "Pending", 
                  style: TextStyle(color: isVerified ? Colors.green : Colors.orange, fontSize: 12)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, {VoidCallback? onTap}) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: onTap ?? () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isSelected ? const Color(0xFF2E7D32) : Colors.grey, size: 28),
      ),
    );
  }
}