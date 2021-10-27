import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constantes.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/pages/mesabonnees.dart';
import 'package:flutter_app/pages/mesabonnements.dart';
import 'package:flutter_app/services/compteservice.dart';

class Abonnement extends StatefulWidget {
 // const Abonnement({Key? key}) : super(key: key);

  @override
  _AbonnementState createState() => _AbonnementState();
}

class _AbonnementState extends State<Abonnement> with SingleTickerProviderStateMixin{
  TabController _tabController;
  String userId = FirebaseAuth.instance.currentUser.uid;
  Compte  userconnect;


  Future<void> getcurrentuser() async{
    // User user = await sauth.user;
    final result = await CompteService().getCurrentCompte(userId);
    setState(() {
      userconnect = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getcurrentuser();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          userconnect == null ? "" : userconnect.compteName,
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'SamBold'
          ),
        ) ,
        elevation: 0.0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          tabs: [
            Tab(
              child: Text(
                "Abonnements",
                style: TextStyle(
                    fontFamily: 'SamBold'
                ),
              ),
            ),
            Tab(
              child: Text(
                "Abonnés",
                style: TextStyle(
                    fontFamily: 'SamBold'
                ),
              ),
            ),
            Tab(
              child: Text(
                "Populaire",
                style: TextStyle(
                    fontFamily: 'SamBold'
                ),
              ),
            )
          ],
          controller: _tabController,
          indicatorColor: secondcolor,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () {
                // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                //   return EditProfil(user: user,);
                // }));
              },
              child: Icon(
                Icons.person_add_alt_1_outlined,
                color: Colors.black,
                size: 24,
              ),
            ),
          )
        ],
      ),
      body: TabBarView(
        children: [
          MesAbonnements(),
          MesAbonnees(),
          Center(child: Text("Contacts Tab Bar View")),
        ],
        controller: _tabController,
      ),
    );
  }
}
