import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/location_service.dart';
import '../../features/auth/services/api_service.dart';

/// 1️⃣ LOCATION PROVIDER
/// Fetches user location (disabled on Web)
final locationProvider = FutureProvider<String>((ref) async {
  // ❗ Web does NOT support native GPS properly
  if (kIsWeb) {
    return "Location not supported on Web";
  }

  final locationService = LocationService();

  try {
    Position? pos = await locationService.determinePosition();

    if (pos == null) {
      return "Location unavailable";
    }

    return await locationService.getAddressFromLatLng(pos);
  } catch (e) {
    return "Location permission denied";
  }
});

/// 2️⃣ USER BALANCE PROVIDER
/// Manages Carbon & Fiat wallet
class UserBalanceNotifier extends StateNotifier<Map<String, dynamic>> {
  UserBalanceNotifier() : super({'carbon': 1250, 'fiat': 45000});

  void deductFiat(int amount) {
    state = {
      ...state,
      'fiat': (state['fiat'] as int) - amount,
    };
  }

  void addCarbon(int amount) {
    state = {
      ...state,
      'carbon': (state['carbon'] as int) + amount,
    };
  }
}

final userBalanceProvider =
    StateNotifierProvider<UserBalanceNotifier, Map<String, dynamic>>(
  (ref) => UserBalanceNotifier(),
);

/// 3️⃣ MARKET LISTINGS PROVIDER
/// Fetches nearby sellers from backend
final marketListingsProvider =
    FutureProvider.family<List<dynamic>, Map<String, double>>(
  (ref, coords) async {
    final apiService = ApiService();

    return await apiService.getNearbySellers(
      coords['lat']!,
      coords['long']!,
    );
  },
);
