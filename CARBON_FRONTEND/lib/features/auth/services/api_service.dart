import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  /// ⚠️ IMPORTANT
  /// For Flutter Web → ALWAYS use 127.0.0.1
  /// NOT localhost, NOT 0.0.0.0
  static const String baseUrl = "http://127.0.0.1:3000/api";

  // =======================
  // AUTHENTICATION APIs
  // =======================

  /// 1️⃣ Send OTP
  Future<bool> sendOtp(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Send OTP Error: $e");
      return false;
    }
  }

  /// 2️⃣ Verify OTP
  /// Returns:
  /// { user_id: String, isNewUser: bool }
  Future<Map<String, dynamic>?> verifyOtp(
      String phone, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phone,
          "otp": otp,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Verify OTP Error: $e");
      return null;
    }
  }

  /// 3️⃣ Login / Set PIN
  Future<bool> loginWithPin(String userId, String pin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login-pin'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "pin": pin,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("PIN Login Error: $e");
      return false;
    }
  }

  // =======================
  // MARKETPLACE APIs
  // =======================

  /// 4️⃣ Fetch Nearby Sellers
  Future<List<dynamic>> getNearbySellers(
      double lat, double lng) async {
    try {
      final url =
          "$baseUrl/market/nearby?lat=$lat&lng=$lng";

      print("API CALL → $url");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
            jsonDecode(response.body);

        /// Backend response:
        /// { success, count, data: [] }
        return List<dynamic>.from(jsonData['data']);
      } else {
        throw Exception("Failed to load sellers");
      }
    } catch (e) {
      print("Nearby Sellers Error: $e");
      rethrow;
    }
  }

  /// 5️⃣ Buy Credits
  Future<bool> buyCredits(
      String listingId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/market/buy"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "buyer_id": "u1", // mock user
          "listing_id": listingId,
          "quantity": quantity,
        }),
      );

      // 6. Get Transaction History
  Future<List<dynamic>> getHistory(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/market/history?user_id=$userId'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      }
      return [];
    } catch (e) {
      print("History Error: $e");
      return [];
    }
  }

      return response.statusCode == 200;
    } catch (e) {
      print("Buy Credits Error: $e");
      return false;
    }
  }

 Future<List<dynamic>> getHistory(String userId) async {
  return [];
}

}
