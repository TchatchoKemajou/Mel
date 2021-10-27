import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/pages/editprofil.dart';
import 'package:flutter_app/pages/guideuser.dart';
import 'package:flutter_app/services/compteservice.dart';

import '../constantes.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String userId = FirebaseAuth.instance.currentUser.uid;
  Compte user;

  Future<void> getcurrentuse() async{
    // User user = await sauth.user;
    final result = await CompteService().getCurrentCompte(userId);
    setState(() {
      user = result;
    });
  }
  @override
  Widget build(BuildContext context) {
    getcurrentuse();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Paramètres",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'SamBold',
              letterSpacing: 1.0,
              fontSize: 18
          ),
        ),
        elevation: 2.0,
        foregroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return EditProfil(user: user,);
                }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: fisrtcolor,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10,),
                      user != null
                          ? Text(
                        user.compteName,
                        style: TextStyle(
                          // color: Colors.white,
                            fontFamily: 'SamBold',
                            fontWeight: FontWeight.w800,
                            fontSize: 18
                        ),
                      )
                          : Text(""),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Profil",
                        style: TextStyle(
                          fontFamily: 'SamRegular',
                          color: Colors.black
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: secondcolor,
                      ),
                    ],
                  )
                ],
              ),
            ),
            getdivider(),
            SizedBox(height: 10,),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gerer mon adresse",
                        style: TextStyle(
                          //color: Colors.white,
                          fontFamily: 'SamRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: secondcolor,
                      )
                    ],
                  ),
                ),
                getdivider(),
                // Padding(
                //   padding: const EdgeInsets.only(top: 15, bottom: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         "Mes préférences",
                //         style: TextStyle(
                //           //color: Colors.white,
                //           fontFamily: 'SamRegular',
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //       Icon(
                //         Icons.keyboard_arrow_right,
                //         color: secondcolor,
                //       )
                //     ],
                //   ),
                // ),
                // getdivider(),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Langue",
                        style: TextStyle(
                          //color: Colors.white,
                          fontFamily: 'SamRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Français",
                            style: TextStyle(
                                fontFamily: 'SamRegular',
                                color: Colors.black
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: secondcolor,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                getdivider(),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Politique de rembourssement",
                        style: TextStyle(
                          //color: Colors.white,
                          fontFamily: 'SamRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: secondcolor,
                      )
                    ],
                  ),
                ),
                getdivider(),
                SwitchListTile(
                  activeColor: fisrtcolor,
                  contentPadding: EdgeInsets.all(0),
                  value: true,
                  title: Text(
                    "Notifications du systéme",
                    style: TextStyle(
                       // fontWeight: FontWeight.w500,
                        fontFamily: 'SamRegular',
                      fontSize: 14,
                    ),
                  ),
                  onChanged: (val) {},
                ),
                getdivider(),
                SwitchListTile(
                  activeColor: fisrtcolor,
                  contentPadding: EdgeInsets.all(0),
                  value: true,
                  title: Text(
                    "Notifications d'abonnement",
                    style: TextStyle(
                        //fontWeight: FontWeight.w500,
                        fontFamily: 'SamRegular',
                      fontSize: 14
                    ),
                  ),
                  onChanged: (val) {},
                ),
                getdivider(),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nettoyer le cache",
                        style: TextStyle(
                          //color: Colors.white,
                          fontFamily: 'SamRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: secondcolor,
                      )
                    ],
                  ),
                ),
                getdivider(),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mise à jour",
                        style: TextStyle(
                          //color: Colors.white,
                          fontFamily: 'SamRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "it's up to date",
                            style: TextStyle(
                                fontFamily: 'SamRegular',
                                color: Colors.grey
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: secondcolor,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                getdivider(),
                InkWell(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                      return GuideUser();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Guide de l'utilisateur",
                          style: TextStyle(
                            //color: Colors.white,
                            fontFamily: 'SamRegular',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: secondcolor,
                        )
                      ],
                    ),
                  ),
                ),
                getdivider(),
                InkWell(
                  onTap: (){
                    _openDialog(apropos());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "A propos de Mel",
                          style: TextStyle(
                            //color: Colors.white,
                            fontFamily: 'SamRegular',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: secondcolor,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  getdivider(){
    return Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }

  apropos(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Mel",
            style: TextStyle(
                color: fisrtcolor,
                fontFamily: 'SamBold',
                fontWeight: FontWeight.w500,
                fontSize: 40
            ),
          ),
         // SizedBox(height: 10,),
          Text(
            "L'application MEL vous aide à vendre et acheter, des produits de second main ou neuf sur l'ensemble du territoire camerounais."
                " vous aurez accès à une large sélection de produits exceptionnels tout en alliant la facilité d'utilisation de notre application et la fiabilité de son contenu. "
                "De plus certains articles autorisent les négociations. les articles sont réceptionnés dans le point de relais le plus proche de votre position. Téléchargez MEL et profiter d'une expérience de shopping en direct",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'SamBold',
                fontSize: 14
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  void _openDialog(Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          // title: Text(title),
          content: content,
          // actions: [
          //   FlatButton(
          //     child: Text(
          //       'Annuler',
          //       style: TextStyle(
          //           fontSize: 15,
          //           fontFamily: 'PopBold',
          //           color: Colors.red
          //       ),
          //     ),
          //     onPressed: Navigator.of(context).pop,
          //   ),
          //   FlatButton(
          //       child: Text(
          //         'Confirmer',
          //         style: TextStyle(
          //           fontSize: 15,
          //           fontFamily: 'PopBold',
          //         ),
          //       ),
          //       onPressed: (){
          //         Navigator.of(context).pop();
          //         Navigator.of(context).pop();
          //         Navigator.of(context).push(
          //           MaterialPageRoute(builder: (_) => OtpScreen(phoneasVerified: numero,)),
          //         );
          //       }
          //   ),
          // ],
        );
      },
    );
  }
}
