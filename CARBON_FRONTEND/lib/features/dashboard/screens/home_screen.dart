import 'package:carbon_credit_gem/features/wallet/screens/buy_credits_screen.dart';
import 'package:carbon_credit_gem/features/wallet/screens/sell_credits_screen.dart';
import 'package:carbon_credit_gem/features/auth/services/location_service.dart';
import 'package:carbon_credit_gem/features/auth/screens/profile_screen.dart';
import 'package:carbon_credit_gem/features/wallet/screens/transaction_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:animate_do/animate_do.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentAddress = "Locating..."; // Default text
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      Position? position = await _locationService.determinePosition();
      if (position != null) {
        String address = await _locationService.getAddressFromLatLng(position);
        setState(() {
          _currentAddress = address;
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Location Denied";
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        },
        child: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.person, color: Colors.black),
        ),
      ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hello, Trader", style: TextStyle(color: Colors.black, fontSize: 14)),
                
                // DYNAMIC LOCATION ROW
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.green),
                    const SizedBox(width: 2),
                    Text(_currentAddress, // <--- Using the variable here
                        style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. MAIN WALLET CARD
            _buildWalletCard(context),
            FadeInDown(
        duration: const Duration(milliseconds: 800),
        child: _buildWalletCard(context),
      ),
            

// 2. QUICK ACTIONS (Grid)
Padding(
  padding: const EdgeInsets.all(16.0),
  child: GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 4,
    children: [
      _buildActionBtn(context, Icons.add_shopping_cart, "Buy", Colors.blue, 
        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BuyCreditsScreen()))),
      
      _buildActionBtn(context, Icons.sell, "Sell", Colors.orange, 
        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SellCreditsScreen()))),

        _buildActionBtn(context, Icons.receipt_long, "History", Colors.teal, 
  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()))),
        
      _buildActionBtn(context, Icons.send, "Transfer", Colors.purple, () {}),
      _buildActionBtn(context, Icons.receipt_long, "History", Colors.teal, () {}),

      FadeInUp(delay: const Duration(milliseconds: 100), child: _buildActionBtn(context, Icons.add_shopping_cart, "Buy", Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BuyCreditsScreen())))),
            FadeInUp(delay: const Duration(milliseconds: 200), child: _buildActionBtn(context, Icons.sell, "Sell", Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SellCreditsScreen())))),
            FadeInUp(delay: const Duration(milliseconds: 300), child: _buildActionBtn(context, Icons.send, "Transfer", Colors.purple, () {})),
            FadeInUp(delay: const Duration(milliseconds: 400), child: _buildActionBtn(context, Icons.receipt_long, "History", Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionHistoryScreen())))),
    ],
  ),
),

            // 3. NEARBY TRADERS
            _buildSectionHeader("Nearby Sellers (50km)"),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildTraderCard("Solar Farm A", "500 Tons", "5km"),
                  _buildTraderCard("Green Corp", "120 Tons", "12km"),
                  _buildTraderCard("Wind Energy", "1k Tons", "22km"),
                ],
              ),
            ),

            FadeInRight(
        delay: const Duration(milliseconds: 500),
        child: Column(
          children: [
            _buildSectionHeader("Nearby Sellers (50km)"),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildTraderCard("Solar Farm A", "500 Tons", "5km"),
                  // ... other cards
                ],
              ),
            ),
          ],
        ),
      ),

            const SizedBox(height: 20),

            // 4. MARKET TRENDS / LISTINGS
            _buildSectionHeader("Recent Listings"),
            _buildListingItem("Reforestation Project", "₹800/ton", "Verified"),
            _buildListingItem("Biogas Plant Unit", "₹650/ton", "Pending"),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER METHODS ---

  Widget _buildWalletCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00C853), Color(0xFF009624)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Carbon Balance", style: TextStyle(color: Colors.white70)),
          SizedBox(height: 8),
          Text("1,250 Tons", 
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Fiat Wallet: ₹45,000", style: TextStyle(color: Colors.white)),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionBtn(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
  return InkWell(
    onTap: onTap, // This handles the click
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
      ],
    ),
  );
}


  Widget _buildTraderCard(String name, String volume, String distance) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 20, 
            backgroundColor: Colors.blueGrey, 
            child: Icon(Icons.store, color: Colors.white, size: 20)
          ),
          const SizedBox(height: 8),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, 
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Text(volume, style: const TextStyle(fontSize: 10, color: Colors.green)),
          Text(distance, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("See All", style: TextStyle(color: Color(0xFF00C853))),
        ],
      ),
    );
  }

  Widget _buildListingItem(String title, String price, String status) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.eco, color: Colors.green),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(status, 
                  style: TextStyle(fontSize: 12, 
                    color: status == "Verified" ? Colors.green : Colors.orange)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}