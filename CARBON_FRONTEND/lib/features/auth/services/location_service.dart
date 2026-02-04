import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  
  // 1. Check permissions and get current position
  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    } 

    // When we reach here, permissions are granted
    return await Geolocator.getCurrentPosition();
  }

  // 2. Convert Coordinates (Lat, Long) to Readable Address (City, District)
  Future<String> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, 
        position.longitude
      );
      
      Placemark place = placemarks[0];
      // Returns format: "Rajkot, Gujarat"
      return "${place.locality}, ${place.administrativeArea}"; 
    } catch (e) {
      return "Unknown Location";
    }
  }
  
  
}

