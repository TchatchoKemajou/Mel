import 'package:flutter/material.dart';
import 'package:flutter_app/pages/splashscreen.dart';
import 'package:flutter_app/provider/locationservice.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

import '../constantes.dart';

class FailedPage extends StatefulWidget {

  @override
  _FailedPageState createState() => _FailedPageState();
}

class _FailedPageState extends State<FailedPage> {
  Placemark placemark;
  String place;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final locationservice = Provider.of<LocationService>(context, listen: false);
    // locationservice.getCurrentAdress();
    // if (locationservice.place != null) {
    //   setState(() {
    //     place = locationservice.place.locality;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {

    final locationservice = Provider.of<LocationService>(context);
    locationservice.getCurrentAdress();
    if (locationservice.place != null) {
      setState(() {
        place = locationservice.place.locality;
      });
    }
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //SizedBox(height: 50.0,),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Zone géographique non prise charge !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: secondcolor,
                      fontFamily: 'Sambold',
                      decoration: TextDecoration.none,
                      fontSize: 14,
                      letterSpacing: 1.0
                  ),
                ),
              ),
              Image.asset(
                "assets/images/area.png",
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.3,
              ),
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 20,),
                margin: EdgeInsets.all(20),
                child: Text(
                  "Mel est désolé du désagrément, nous ne prénons pas en charge votre zone géographique. Nous espérons resoudre le problème dans les prochaines mises à jours merci !!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SamItalic',
                      decoration: TextDecoration.none,
                      fontSize: 16,
                      letterSpacing: 1.5
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                        return Splashcreen();
                      }));
                },
                child: Text(
                  "Essayez à nouveau",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sambold',
                      decoration: TextDecoration.none,
                      fontSize: 16,
                      letterSpacing: 1.0
                  ),

                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((
                        states) => fisrtcolor),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.only(left: 80, right: 80)),
                    // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //     RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //       // side: BorderSide(color: Colors.red)
                    //     )
                    // )
                ),
              )
            ],
          ),
        ),
      );
    }
  }

