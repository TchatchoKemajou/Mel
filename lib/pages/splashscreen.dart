import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constantes.dart';
import 'package:flutter_app/pages/failledpage.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/register.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilitaire.dart';

class Splashcreen extends StatefulWidget{
  // final place;
  // Splashcreen({this.place});
  @override
  _Splashcreen createState() => _Splashcreen();

}
class _Splashcreen extends State<Splashcreen>{
  FirebaseAuth auth = FirebaseAuth.instance;
  String place;
  Utilitaire utilitaire = Utilitaire();

  // verifiedLocation() async{
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   String loc = await utilitaire.getLocation();
  //   //print(tok);
  //   if(localStorage.containsKey('place')){
  //     place = loc;
  //   }else place = " ";
  // }
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    Timer(animduration, (){
      Navigator.of(context).pop();
      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
        return auth.currentUser == null ? RegisterPage() : Home();
      }));
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:  AssetImage(
                'assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Mel",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SamBold',
                      fontWeight: FontWeight.w500,
                      fontSize: 80
                  ),
                ),
                Container(
                  width: 180,
                  height: 2,
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 5),
                ),
                Text(
                  "Powered by CODEX SARL",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SamBold',
                      fontWeight: FontWeight.w500,
                      fontSize: 12
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
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

      Placemark _place = placemarks[0];
      setState(() {
        place = _place.locality;
      });

      // currentposition = position;
      // currentAddress = "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      print(e);
    }
  }
}