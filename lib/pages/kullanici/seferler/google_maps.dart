import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ihapp/pages/kullanici/seferler/video_player.dart';
import 'package:ihapp/widgets/custom_outlinedbuton.dart';

import '../../../consts/strings.dart';
import '../../../enums/enums.dart';
import '../../../firebase/firestore.dart';

class GoogleMaps extends StatefulWidget {
  final String seferName;
  const GoogleMaps({super.key, required this.seferName});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  late Timer izlemeTimer;
  bool isIzleme = false;
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
      CameraPosition(target: LatLng(0, 0), zoom: 14);
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
      if (_polylineCoordinates.isNotEmpty) {
        var lastLatLng = _polylineCoordinates.last;
        var newSegment = [lastLatLng, newLatLng];
        _polylineCoordinates.addAll(newSegment);
      } else {
        _polylineCoordinates.add(newLatLng);
      }
    });
  }

  void updateCameraPosition(LatLng newLatLng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(newLatLng),
    );
  }

  int currentIndex = 0;
  void startTracking() async {
    isIzleme = true;
    if (currentIndex != 0) {
      currentIndex = 0;
    } else {
      currentIndex = 0;
    }
    final List<Map<String, dynamic>> locationData = await FireStore()
        .getLocationInfoPast(userUid: userUid, seferName: widget.seferName);

    final List<LatLng> locationList = [];
    locationData.forEach((element) {
      final double lat = element['lat'];
      final double lon = element['lon'];
      final newLatLon = LatLng(lat, lon);
      locationList.add(newLatLon);
    });

    izlemeTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (currentIndex < locationList.length - 1) {
        LatLng currentLocation = locationList[currentIndex];
        LatLng nextLocation = locationList[currentIndex + 1];

        Polyline polyline = Polyline(
          polylineId: PolylineId('polyline$currentIndex'),
          color: Colors.green,
          width: 3,
          points: [currentLocation, nextLocation],
        );
        _polylines.add(polyline);
        _currentMarker = markerLoc(nextLocation);
        _mapController!
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: nextLocation,
          zoom: 16,
        )));

        currentIndex++;
        setState(() {});

        if (currentIndex == locationList.length - 1) {
          _mapController!
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: nextLocation,
            zoom: 16,
          )));
          izlemeTimer.cancel();
        }
      } else {
        izlemeTimer.cancel();
      }
    });
    setState(() {});
  }

  void stopTracking() {
    isIzleme = false;
    if (izlemeTimer.isActive) {
      izlemeTimer.cancel();
    }
    removePolylineId();
  }

  void removePolylineId() {
    for (var i = 0; i < currentIndex; i++) {
      String polylineId = 'polyline' + '$i';
      _polylines
          .removeWhere((polyline) => polyline.polylineId.value == polylineId);
    }
  }

  @override
  void initState() {
    izlemeTimer = Timer.periodic(Duration(seconds: 1), (timer) {});
    _addPolyline();
    super.initState();
  }

  @override
  void dispose() {
    _mapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: customOutlinedButton(
            borderColor: Colors.amberAccent,
            textColor: Colors.white,
            onPressed: () {
              if (isIzleme == false) {
                if (izlemeTimer.isActive) {
                  izlemeTimer.cancel();
                  startTracking();
                } else {
                  startTracking();
                }
                setState(() {});
              } else {
                stopTracking();
                setState(() {});
              }
            },
            title: isIzleme == true ? 'Durdur' : 'Baştan İzle',
            context: context),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _currentCameraPos,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              polylines: _polylines,
              markers: Set<Marker>.of([_currentMarker]),
            ),
          ),
          Expanded(child: VideoPlayerPage()),
        ],
      ),
    );
  }
}
