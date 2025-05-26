import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _thailandLocation = const LatLng(13.736717, 100.523186); // Bangkok, Thailand

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // appBar: AppBar(title: const Text('Thailand Map'),
      // backgroundColor: Colors.orange,
      // ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _thailandLocation,
          zoom: 12, // Adjust zoom level
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId('thailand'),
            position: _thailandLocation,
            infoWindow: const InfoWindow(title: "Bangkok, Thailand"),
          ),
        },
      ),
    );
  }
}
