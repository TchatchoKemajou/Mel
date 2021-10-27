import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/provider/compteprovider.dart';
import 'package:flutter_app/services/authservice.dart';
import 'package:flutter_app/utilitaire.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../constantes.dart';


class RegisterPage extends StatefulWidget {

  // final User user;
  // RegisterPage({this.user});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email, password, location;
  AuthService auth = AuthService();
  Utilitaire utilitaire = Utilitaire();
  final key = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final quartierController = TextEditingController();
  final carrefourController =TextEditingController();
  Map<String, dynamic> adress = Map();
  List<String> regions = [];
  List<String> villes = [];

  @override
  void dispose() {
    // TODO: implement dispose
    mailController.dispose();
    passwordController.dispose();
    quartierController.dispose();
    carrefourController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    //final userProvider = Provider.of<UserProvider>(context, listen: false);
    final compteProvider = Provider.of<CompteProvider>(context, listen: false);
    regions = ["Littoral", "Centre"];
    villes = ["Douala", "Yaoundé"];
    adress["region"] = "Littoral";
    adress["ville"] = "Douala";
    adress["quartier"] = "";
    adress["rue"] = "";
    compteProvider.changeCompteAddress = adress;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                Carousel(
                  boxFit: BoxFit.cover,
                  borderRadius: false,
                  // radius: Radius.circular(10),
                  autoplay: true,
                  animationCurve: Curves.fastOutSlowIn,
                  animationDuration: Duration(milliseconds: 1000),
                  dotSize: 0.0,
                  dotIncreasedColor: Color(0xFFFF335C),
                  dotBgColor: Colors.transparent,
                  dotPosition: DotPosition.bottomRight,
                  dotVerticalPadding: 10.0,
                  showIndicator: true,
                  indicatorBgPadding: 7.0,
                  images: [
                    AssetImage("assets/images/pub1.jpg",),
                    AssetImage("assets/images/pub2.jpg"),
                    AssetImage("assets/images/pub3.jpg"),
                  ],
                ),
                formulaire(),
              ],
            )
        )
    );
  }
  //
  // content(){
  //   return Padding(
  //     padding: EdgeInsets.only(top: 0, bottom: 10, left: 15, right: 15),
  //     child: formulaire(),
  //   );
  // }

  formulaire() {
  //  final userProvider = Provider.of<UserProvider>(context);
    final compteProvider = Provider.of<CompteProvider>(context);
   // final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);
    return Container(
      // height: 300.0,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Center(child: Text(
              "Inscription",
              style: TextStyle(
                color: secondcolor,
                fontFamily: 'SamBold',
                fontWeight: FontWeight.w800,
                fontSize: 18,
                decoration: TextDecoration.underline,
                // fontSize: 12
              ),
            ),),
            SizedBox(height: 15.0,),
            Form(
              key: key,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nom d'utilisateur",
                        style: TextStyle(
                          color: secondcolor,
                          fontFamily: 'SamBold',
                          fontWeight: FontWeight.w500,
                          // fontSize: 12
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.only(left:10.0,),
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: mailController,
                          onChanged: (e) => compteProvider.changeCompteName = e,
                          validator: (e) => e.trim().isEmpty ? " nom obligatoire":null,
                          autocorrect: true,
                          style: TextStyle(
                            // fontFamily: 'rowregular'
                          ),
                          decoration: InputDecoration(
                            hintText: "Ex: toto",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0,),
                       Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mot de passe",
                        style: TextStyle(
                          color: secondcolor,
                          fontFamily: 'SamBold',
                          fontWeight: FontWeight.w500,
                          // fontSize: 12
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.only(left:10.0),
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          // keyboardType: TextInputType.,
                          obscureText: true,
                          // obscuringCharacter: "*",
                          controller: passwordController,
                          onChanged: (e) => compteProvider.changeComptePassword = e,
                          validator: (e) => e.trim().isEmpty ? " Mot de passe obligatoire": e.length < 6 ? "Le mot de passe doit etre supérieur à 6 caractères":null,
                          //autocorrect: true,
                          style: TextStyle(
                            // fontFamily: 'rowregular'
                          ),
                          decoration: InputDecoration(
                            hintText: "Ex: ckdcucu",
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    // width: MediaQuery.of(context).size.width * 0.7,
                      padding: EdgeInsets.only(left:10.0, right: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(10.0),
                        // border: Border.all(color: Colors.grey,)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Region",
                            style: TextStyle(
                              color: secondcolor,
                              fontFamily: 'SamBold',
                              fontWeight: FontWeight.w500,
                              // fontSize: 12
                            ),
                          ),
                          DropdownButton<String>(
                            value: compteProvider.compteAddress["region"],
                            icon: Icon(
                              Icons.arrow_drop_down,
                            ),
                            iconSize: 24,
                            //elevation: 16,
                            underline: Container(
                              height: 1,
                              color: Colors.white54,
                            ),
                            style: TextStyle(
                                color: Colors.black
                            ),
                            onChanged: (String e) {
                              setState(() {
                                adress.update("region", (value) => e);
                                compteProvider.changeCompteAddress = adress;
                              });
                            },
                            items: regions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ],
                      )
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    // width: MediaQuery.of(context).size.width * 0.7,
                      padding: EdgeInsets.only(left:10.0, right: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(10.0),
                        // border: Border.all(color: Colors.grey,)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Ville",
                            style: TextStyle(
                              color: secondcolor,
                              fontFamily: 'SamBold',
                              fontWeight: FontWeight.w500,
                              // fontSize: 12
                            ),
                          ),
                          DropdownButton<String>(
                            value: compteProvider.compteAddress["ville"],
                            icon: Icon(
                              Icons.arrow_drop_down,
                            ),
                            iconSize: 24,
                            //elevation: 16,
                            underline: Container(
                              height: 1,
                              color: Colors.white54,
                            ),
                            style: TextStyle(
                                color: Colors.black
                            ),
                            onChanged: (String e) {
                              setState(() {
                                adress.update("ville", (value) => e);
                                compteProvider.changeCompteAddress = adress;
                                location = e;
                              });
                            },
                            items: villes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ],
                      )
                  ),
                  SizedBox(height: 5.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quartier",
                        style: TextStyle(
                          color: secondcolor,
                          fontFamily: 'SamBold',
                          fontWeight: FontWeight.w500,
                          // fontSize: 12
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.only(left:10.0),
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: quartierController,
                          onChanged: (e) => {
                            setState(() {
                              adress.update("quartier", (value) => e);
                              compteProvider.changeCompteAddress = adress;
                            })
                          },
                          validator: (e) => e.trim().isEmpty ? " votre quartier est obligatoire":null,
                          //autocorrect: true,
                          style: TextStyle(
                            // fontFamily: 'rowregular'
                          ),
                          decoration: InputDecoration(
                            hintText: "Ex: ckdcucu",
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "carrefour",
                        style: TextStyle(
                          color: secondcolor,
                          fontFamily: 'SamBold',
                          fontWeight: FontWeight.w500,
                          // fontSize: 12
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.only(left:10.0),
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: carrefourController,
                          onChanged: (e) => {
                            setState(() {
                              adress.update("rue", (value) => e);
                              compteProvider.changeCompteAddress = adress;
                            })
                          },
                          validator: (e) => e.trim().isEmpty ? " la rue est  obligatoire":null,
                          //autocorrect: true,
                          style: TextStyle(
                            // fontFamily: 'rowregular'
                          ),
                          decoration: InputDecoration(
                            hintText: "Ex: ckdcucu",
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0,),
            ElevatedButton(
              onPressed: () async {
                if(key.currentState.validate()){
                  compteProvider.changeCompteEmail = compteProvider.compteName.trim().toLowerCase() + "@gmail.com";
                  // compteProvider.changeCompteName = userProvider.userName;
                  // compteProvider.changeCompteEmail = userProvider.userEmail;
                  bool register = await auth.Signup(compteProvider.compteEmail, compteProvider.comptePassword);
                  if(register != null){
                    String uid = FirebaseAuth.instance.currentUser.uid;
                    // userProvider.saveUser(uid);
                    compteProvider.saveCompte(uid);
                    await utilitaire.setLocation(location);
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                      return new Home();
                    }));
                  }
                }
              },
              child: Text(
                "S'inscrire",
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => fisrtcolor),
                  padding: MaterialStateProperty.all(EdgeInsets.only(left: 80, right: 80)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        // side: BorderSide(color: Colors.red)
                      )
                  )
              ),
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ou avec",
                ),
                SizedBox(width: 10.0,),
                ClipOval(
                  child: Material(
                    color: Colors.white, // button color
                    child: InkWell(
                      //  splashColor: Colors.red, // inkwell color
                      child: SvgPicture.asset(
                        "assets/svg/facebook.svg",
                        width: 20,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                SizedBox(width: 10.0,),
                InkWell(
                  onTap: (){
                    // final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                    // provider.login();
                    // if(provider.isSigningIn == true){
                    //   String uid = FirebaseAuth.instance.currentUser.uid;
                    //   // userProvider.saveUser(uid);
                    //   compteProvider.changeCompteName = FirebaseAuth.instance.currentUser.displayName;
                    //   compteProvider.changeCompteEmail = FirebaseAuth.instance.currentUser.email;
                    //   compteProvider.saveCompte(uid);
                    //   Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    //     return new Home();
                    //   }));
                    // }
                  },
                  child: ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: SvgPicture.asset(
                        "assets/svg/google.svg",
                        width: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "avez vous déja un compte ?",
                  style: TextStyle(
                    // color: Colors.black,
                      fontFamily: 'SamLight',
                      fontWeight: FontWeight.w500,
                      fontSize: 12
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                      return new LoginPage();
                    }));
                  },
                  child: Text(
                    "se connecter",
                    style: TextStyle(
                        color: secondcolor,
                        fontFamily: 'SamBold',
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}