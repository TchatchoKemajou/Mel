import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/register.dart';
import 'package:flutter_app/services/authservice.dart';
import 'package:flutter_svg/svg.dart';

import '../constantes.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;
  AuthService auth = AuthService();
  final keyl = GlobalKey<FormState>();
  bool register;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("assets/images/pub1.jpg",
            //     ),
            //     fit: BoxFit.cover,
            //   )
            // ),
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
                    AssetImage(
                      "assets/images/pub1.jpg",
                    ),
                    AssetImage("assets/images/pub2.jpg"),
                    AssetImage("assets/images/pub1.jpg"),
                  ],
                ),
                content()
              ],
            )
        )
    );
  }

  content(){
    return Padding(
      padding: EdgeInsets.only(top: 0, bottom: 10, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          carousel(),
          formulaire(),
        ],
      ),
    );
  }

  carousel() {
    return Container(
      height: 180.0,
      width: double.infinity,
      child: Stack(
        children: [
          Carousel(
            boxFit: BoxFit.cover,
            borderRadius: true,
            radius: Radius.circular(10),
            autoplay: true,
            animationCurve: Curves.fastOutSlowIn,
            animationDuration: Duration(milliseconds: 1000),
            dotSize: 6.0,
            dotIncreasedColor: Color(0xFFFF335C),
            dotBgColor: Colors.transparent,
            dotPosition: DotPosition.bottomRight,
            dotVerticalPadding: 10.0,
            showIndicator: true,
            indicatorBgPadding: 7.0,
            images: [
              AssetImage(
                "assets/images/pub1.jpg",
              ),
              AssetImage("assets/images/pub2.jpg"),
              AssetImage("assets/images/pub1.jpg"),
            ],
          ),
          Positioned(
              left: 10,
              bottom: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Connectez vous",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SamBold',
                        fontWeight: FontWeight.w500,
                        fontSize: 15
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Text(
                    "vister et profiter \n de la periode de promotion \n jusqu'à 50% de reduction",
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SamBold',
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                    ),
                  )
                ],
              )
          ),
          Positioned(
            right: 5.0,
            top: 5.0,
            child: Container(
              width: 25.0,
              height: 20.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: background,
              ),
              child: Center(
                  child: InkWell(
                    child: Text(
                      "Ad",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'SamBold',
                          fontWeight: FontWeight.w500,
                          fontSize: 12
                      ),
                    ),
                  )
              ),
            ),
          ),
          Positioned(
            top: 5.0,
            left: 5.0,
            child: Text(
              "offert par mel.com",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'SamBold',
                  fontWeight: FontWeight.w500,
                  fontSize: 12
              ),
            ),
          )
        ],
      ),
    );
  }

  formulaire() {
    return Container(
      // height: 300.0,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: keyl,
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
                          onChanged: (e) => email = e + "@gmail.com",
                          validator: (e) => e.isEmpty ? " Email obligatoire":null,
                          autocorrect: true,
                          style: TextStyle(
                            // fontFamily: 'rowregular'
                          ),
                          decoration: InputDecoration(
                            hintText: "Ex: empereur",
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
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (e) => password = e,
                          validator: (e) => e.isEmpty ? " Mot de passe obligatoire" :null,
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
                  register == false ? Text(
                    "nom ou mot de passe incorrect",
                  ) : SizedBox()
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            ElevatedButton(
              onPressed: () async {
                if(keyl.currentState.validate()){
                   register = await auth.Signin(email, password);
                  if(register){
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                      return new Home();
                    }));
                  }else{
                    setState(() {
                      register = false;
                    });
                  }
                }
              },
              child: Text(
                "Connexion",
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
                ClipOval(
                  child: Material(
                    color: Colors.white, // button color
                    child: InkWell(
                      //    splashColor: Colors.red, // inkwell color
                      child: SvgPicture.asset(
                        "assets/svg/google.svg",
                        width: 20,
                      ),
                      onTap: () {},
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
                  "vous n'avez pas de compte ?",
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
                      return new RegisterPage();
                    }));
                  },
                  child: Text(
                    "Inscription",
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