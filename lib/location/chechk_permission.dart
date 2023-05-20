import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ihapp/widgets/custom_text.dart';
import 'package:app_settings/app_settings.dart';

class ChechkPermissions {
//Konum hizmetinin açık olup olmadığını kontrol et
  void showLocationService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: customText(
            context: context,
            text: 'Konum Servisiniz Kapalı',
            textStyle: Theme.of(context).textTheme.titleLarge,
          ),
          content: customText(
            context: context,
            text: 'Lütfen konum servisinizi açın',
            textStyle: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                AppSettings.openLocationSettings();
                Navigator.pop(context);
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  //Konum hizmetini kullanma izni sorgulama
  Future<LocationPermission> chechkLocationPermission(
      BuildContext context) async {
    LocationPermission permission;
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showLocationService(context);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
    }
    return permission;
  }
}
