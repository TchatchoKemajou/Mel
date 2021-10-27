import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService with ChangeNotifier{

 // DialogService _dialogService = locator<DialogService>();
  Placemark _place;


  Placemark get place => _place;

  Future<Position> getCurrentAdress() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
    //  Toast.show("Please enable Your Location Service", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
      //  Toast.show("Location permissions are denied", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
    }

    if (permission == LocationPermission.deniedForever) {
     // Toast.show("Location permissions are permanently denied, we cannot request permissions.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      _place = placemarks[0];
      notifyListeners();

       // currentposition = position;
       // currentAddress = "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      print(e);
    }
  }

  // Future searchLocation(val) async {
  //   try {
  //     List<Placemark> placemark = await Geolocator().placemarkFromAddress(val);
  //     var location;
  //     if (placemark.isNotEmpty) {
  //       location = placemark[0].position;
  //     }
  //     return location;
  //   } catch (e) {
  //     _dialogService.showDialog(
  //         title: 'Something Wrong', description: e.toString());
  //   }
  // }

}