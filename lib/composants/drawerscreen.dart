//import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constantes.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/pages/collection_page.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/pages/message.dart';
import 'package:flutter_app/pages/panier.dart';
import 'package:flutter_app/pages/profil.dart';
import 'package:flutter_app/pages/settings.dart';
import 'package:flutter_app/services/authservice.dart';
import 'package:flutter_app/services/compteservice.dart';



class Drawerscreen extends StatefulWidget{
  @override
  _Drawerscreen createState() => _Drawerscreen();

}
class _Drawerscreen extends State<Drawerscreen>{
  AuthService sauth = AuthService();
  FirebaseAuth auth = FirebaseAuth.instance;
  // UserService userService = UserService();
  String userId = FirebaseAuth.instance.currentUser.uid;
  Compte userm;


  @override
  void initState() {
    getcurrentuse();
    super.initState();
  }

  Future<void> getcurrentuse() async{
    // User user = await sauth.user;
    final result = await CompteService().getCurrentCompte(userId);
    setState(() {
      userm = result;
    });
  }

  wvdsvdvs(){
    return CircleAvatar(
      radius: 40,
      child: userm != null ?
      CachedNetworkImage(
        imageUrl: userm.compteProfil == null ? "" : userm.compteProfil,
        placeholder: (context, url) => Text(
            userm.compteName.toUpperCase().substring(0, 1)
        ),
        errorWidget: (context, url, error) => Center(
          child: Text(
            userm.compteName.toUpperCase().substring(0, 1),
            style: TextStyle(
                fontSize: 24
            ),
          ),
        ),
        fit: BoxFit.cover,
      )
          :SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //  final userprovider = Provider.of<UserProvider>(context);
    return Container(
      color: fisrtcolor,
      padding: EdgeInsets.only(top: 40, left: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // if(userm != null)
          ListTile(
            contentPadding: EdgeInsets.only(left: 0.0),
            leading: CircleAvatar(
              radius: 40,
              backgroundImage: userm != null ? NetworkImage(userm.compteProfil,) : null,
              child: userm != null ? userm.compteProfil == null || userm.compteProfil == "" ? Center(child: Text(
                userm.compteName.toUpperCase().substring(0, 1),
                style: TextStyle(
                    fontSize: 24
                ),
              ),) : SizedBox() : SizedBox(),
            ),
            title: userm != null
                ? Text(
              userm.compteName,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'SamBold',
                  fontWeight: FontWeight.w500,
                  fontSize: 20
              ),
            )
                : Text(""),
            subtitle: Text(
              "en ligne",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'SamLight',
                  fontSize: 12
                //  fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  // Respond to button press
                  // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  //   return Home();
                  // }));
                },
                icon: Icon(Icons.home, size: 20),
                label: Text(
                  "Acceuil",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SamBold',
                      fontWeight: FontWeight.w800,
                      fontSize: 17
                  ),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return CollectionPage();
                  }));
                },
                icon: Icon(Icons.category, size: 20),
                label: Text(
                  "Catégories",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SamBold',
                      fontWeight: FontWeight.w800,
                      fontSize: 17
                  ),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return Panier();
                  }));
                },
                icon: Icon(Icons.shopping_cart, size: 20),
                label: Text(
                  "Panier",
                  //textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SamBold',
                      fontWeight: FontWeight.w800,
                      fontSize: 17
                  ),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return MessagePage();
                  }));
                },
                icon: Icon(Icons.notifications, size: 20),
                label: Text(
                  "Notification",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SamBold',
                      fontWeight: FontWeight.w800,
                      fontSize: 17
                  ),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Respond to button press
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return new Profil(id: userId,);
                  }));
                },
                icon: Icon(Icons.person, size: 20),
                label: Text(
                  "Mon MEL",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SamBold',
                      fontWeight: FontWeight.w800,
                      fontSize: 17
                  ),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return SettingsPage();
                  }));
                },
                icon: Icon(Icons.settings, size: 18),
                label: Text(
                  "Paramètre",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SamBold',
                    fontWeight: FontWeight.w800,
                    fontSize: 15
                  ),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                ),
              ),
              Container(width: 2,       decoration: BoxDecoration(
                color: Colors.white,
                //  borderRadius: BorderRadius.circular(border)
              ),),
              TextButton.icon(
                onPressed: () {
                  // Respond to button press
                  sauth.Signout();
                  Navigator.of(context).pop();
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return  LoginPage();
                  }));

                },
                icon: Icon(Icons.logout, size: 18),
                label: Text(
                  "Deconnexion",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SamBold',
                    fontWeight: FontWeight.w800,
                    fontSize: 15
                  ),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}