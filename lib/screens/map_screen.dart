import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();

  // Sample coordinates for the map center and markers (adjust with actual coordinates)
  static const LatLng _center = LatLng(24.7136, 46.6753); // Sample coordinates for Riyadh
  
  // Markers, polylines and other map elements
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Circle> _circles = {};
  
  @override
  void initState() {
    super.initState();
    _setMapElements();
  }
  
  void _setMapElements() {
    // Add blue marker for start point
    _markers.add(
      Marker(
        markerId: const MarkerId('start'),
        position: const LatLng(24.7120, 46.6730),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    
    // Add red marker for end point
    _markers.add(
      Marker(
        markerId: const MarkerId('end'),
        position: const LatLng(24.7150, 46.6780),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // Add bus icon marker
    _markers.add(
      Marker(
        markerId: const MarkerId('bus'),
        position: const LatLng(24.7135, 46.6765),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    );
    
    // Add polyline for route
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.red,
        width: 5,
        points: const [
          LatLng(24.7120, 46.6730),
          LatLng(24.7125, 46.6740),
          LatLng(24.7130, 46.6750),
          LatLng(24.7135, 46.6760),
          LatLng(24.7140, 46.6770),
          LatLng(24.7150, 46.6780),
        ],
        patterns: [PatternItem.dot],
      ),
    );
    
    // Add blue circle around starting point
    _circles.add(
      Circle(
        circleId: const CircleId('start_area'),
        center: const LatLng(24.7120, 46.6730),
        radius: 100,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: const CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            markers: _markers,
            polylines: _polylines,
            circles: _circles,
            myLocationEnabled: true,
            mapType: MapType.normal,
          ),
          
          // Search Bar
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Bathroom',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          
          // Route Info Card
          Positioned(
            bottom: 90,
            left: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_walk, size: 20),
                  const SizedBox(width: 5),
                  const Text('10 min', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 15,
                    width: 1,
                    color: Colors.grey,
                  ),
                  const Text('290 m'),
                ],
              ),
            ),
          ),

          // Location Buttons
          Positioned(
            left: 30,
            top: 250,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'A1',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: 170,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Mohammed',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            left: 120,
            top: 150,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Hall D',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}