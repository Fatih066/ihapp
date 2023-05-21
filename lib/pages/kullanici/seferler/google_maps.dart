import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  Set<Polyline> _polylines = {};
  LatLng? lastPosition;
  Marker _currentMarker = Marker(
    markerId: MarkerId('currentLocation'),
    position:
        LatLng(0, 0), // Başlangıçta varsayılan bir konum kullanabilirsiniz.
    icon: BitmapDescriptor.defaultMarkerWithHue(20),
  );
  CameraPosition _currentCameraPos =
      CameraPosition(target: LatLng(0, 0), zoom: 25);
  Marker markerLoc(LatLng newLatLng) {
    Marker _currentLocationMarker = Marker(
      markerId: MarkerId('currentLocation'),
      position:
          newLatLng, // Başlangıçta varsayılan bir konum kullanabilirsiniz.
      icon: BitmapDescriptor.defaultMarkerWithHue(20),
    );
    return _currentLocationMarker;
  }

  CameraPosition cameraPos(LatLng newLatLng) {
    CameraPosition cameraPos = CameraPosition(target: newLatLng, zoom: 30);
    return cameraPos;
  }

  void _addPolyline() async {
    final List<Map<String, dynamic>> locationData = await FireStore()
        .getLocationInfoPast(userUid: userUid, seferName: widget.seferName);
    for (var data in locationData) {
      final double lat = data['lat'];
      final double lon = data['lon'];
      _polylineCoordinates.add(LatLng(lat, lon));
      _polylines.add(
        Polyline(
          polylineId: PolylineId(widget.seferName),
          color: Colors.red,
          width: 5,
          points: _polylineCoordinates,
        ),
      );
      updateCameraPosition(LatLng(lat, lon));
    }
    listenToLocationUpdates();
    setState(() {});
  }

  void listenToLocationUpdates() async {
    final locationStream = await FireStore()
        .getLocationGuncel(userUid: userUid, seferName: widget.seferName);

    locationStream.listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        //Güncel konum verisi mevcut ise
        var coordinates = snapshot.data();
        var latitude = coordinates!['lat'];
        var longitude = coordinates['lon'];
        var newLatLng = LatLng(latitude, longitude);
        _currentMarker = markerLoc(newLatLng);
        _currentCameraPos = cameraPos(newLatLng);
        updatePolyline(newLatLng);
        updateCameraPosition(newLatLng);
      }
    });
  }

  void updatePolyline(LatLng newLatLng) {
    setState(() {
      // _polylineCoordinates.add(newLatLng);

      if (_polylineCoordinates.isNotEmpty) {
        var lastLatLng = _polylineCoordinates.last;
        var newSegment = [lastLatLng, newLatLng];
        _polylineCoordinates.addAll(newSegment);
      } else {
        _polylineCoordinates.add(newLatLng);
      }
      // if (_polylineCoordinates.isNotEmpty) {
      //   _polylineCoordinates.add(newLatLng);
      //   _polylines.add(
      //     Polyline(
      //       polylineId: PolylineId('güncel'),
      //       color: Colors.green,
      //       width: 3,
      //       points: _polylineCoordinates,
      //     ),
      //   );
      // } else {}
    });
  }

  void updateCameraPosition(LatLng newLatLng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(newLatLng),
    );
  }

  @override
  void initState() {
    _addPolyline();

    super.initState();
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
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined)),
      ),
      body: GoogleMap(
        initialCameraPosition: _currentCameraPos,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        polylines: _polylines,
        markers: Set<Marker>.of([_currentMarker]),
      ),
    );
  }
}
