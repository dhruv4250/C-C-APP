import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  // Initial center (e.g., Default to India center if GPS fails)
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(22.3039, 70.8022), // Rajkot Coordinates
    zoom: 11.0,
  );

  // Mock Sellers Data
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('seller1'),
      position: LatLng(22.3100, 70.8100),
      infoWindow: InfoWindow(title: 'Green Earth Solar', snippet: '500 Tons Available'),
    ),
    const Marker(
      markerId: MarkerId('seller2'),
      position: LatLng(22.2900, 70.7900),
      infoWindow: InfoWindow(title: 'Ravi Biogas', snippet: '120 Tons Available'),
    ),
  };

  // The 50km Radius Circle
  final Set<Circle> _circles = {
    Circle(
      circleId: const CircleId('radius'),
      center: const LatLng(22.3039, 70.8022),
      radius: 5000, // 5km radius for demo (meters)
      fillColor: Colors.green.withOpacity(0.2),
      strokeColor: Colors.green,
      strokeWidth: 1,
    )
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sellers Near You")),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kInitialPosition,
        markers: _markers,
        circles: _circles,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}