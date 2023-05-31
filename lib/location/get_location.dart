import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../firebase/firestore.dart';
import 'chechk_permission.dart';

class GetLocation {
  final LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  Future<void> sendLocation(
      {required BuildContext context,
      required String userUid,
      required String seferName}) async {
    LocationPermission permission =
        await ChechkPermissions().chechkLocationPermission(context);
    DateTime dateTime = DateTime(2023);
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      StreamSubscription<Position> positionStream =
          Geolocator.getPositionStream(locationSettings: _locationSettings)
              .listen((Position? position) async {
        if (position != null) {
          String currentTime =
              DateFormat("dd-MM-yyyy__HH-mm-ss").format(DateTime.now());
          await FireStore().setUserLocationInfos(
            seferName: seferName,
            userUid: userUid,
            position: position,
            tarih: currentTime,
          );
        }
      });
    }
  }
}
