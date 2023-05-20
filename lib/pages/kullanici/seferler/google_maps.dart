import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../consts/strings.dart';
import '../../../firebase/firestore.dart';

class GoogleMaps extends StatefulWidget {
  final String seferName;
  const GoogleMaps({super.key, required this.seferName});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  GoogleMapController? _mapController;
  List<LatLng> _polylineCoordinates = [];

  void _addPolyline() async {
    final List<Map<String, dynamic>> locationData = await FireStore()
        .getLocationInfo(userUid: userUid, seferName: widget.seferName);
    for (var data in locationData) {
      final double lat = data['lat'];
      final double lon = data['lon'];
      _polylineCoordinates.add(LatLng(lat, lon));
    }
    setState(() {});
  }

  @override
  void dispose() {
    _mapController!
        .dispose(); // Harita kontrolcüsünü düzenli olarak kapatmak için dispose metodu kullanılır
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
        onMapCreated: (controller) {
          _mapController = controller;
          _addPolyline();
        },
        polylines: {
          Polyline(
            polylineId: PolylineId(widget.seferName),
            color: Colors.blue,
            width: 5,
            points: _polylineCoordinates,
          ),
        },
      ),
    );
  }
}
