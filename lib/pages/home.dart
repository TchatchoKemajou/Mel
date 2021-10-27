import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/composants/drawerscreen.dart';
import 'package:flutter_app/composants/homescreen.dart';
import 'package:flutter_app/pages/add_article.dart';
import 'package:flutter_app/pages/panier.dart';
import 'package:flutter_app/pages/profil.dart';
import 'package:flutter_app/pages/wishlist.dart';
import 'package:flutter_app/services/authservice.dart';
import 'package:flutter_app/services/linkservice.dart';

import '../constantes.dart';

class Home extends StatefulWidget{
  @override
  _Home createState() => _Home();

}
class _Home extends State<Home>{
  Timer time;
  int _selectedIndex = 0;
  User user;
  AuthService auth = AuthService();
  final linkservice = DynamicLinkService();
  String userId = FirebaseAuth.instance.currentUser.uid;
  int current = 0;
  List<Widget> page;

  Future<void> getUser() async{
    final userresult = await auth.user;
    setState(() {
      user = userresult;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    page =[
      Homescreen(),
      WishList(),
      Panier(),
      Profil(id: userId),
      AddArticle()
    ];
    time = Timer(Duration(seconds: 2), () {
      linkservice.retrieveDynamicLink(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: page[current],
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: [
          Icons.search,
          Icons.favorite,
          Icons.shopping_cart,
          Icons.person,
        ],
        //leftCornerRadius: 20,
        elevation: 10.0,
        backgroundColor: Colors.white,
        activeColor: fisrtcolor,
        inactiveColor: Colors.grey,
        splashColor: Colors.blueGrey,
        activeIndex: current,
        gapLocation: GapLocation.end,
        notchSmoothness: NotchSmoothness.sharpEdge,
        onTap: (index) => setState(() => current = index),
        //other params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(current == 4){
            // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
            //   return AddArticle();
            // }));
          }else{
            setState(() {
              current = 4;
            });
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: fisrtcolor,
      ),
    );
  }
}