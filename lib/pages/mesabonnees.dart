import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/provider/compteprovider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MesAbonnees extends StatefulWidget {
  //const MesAbonnees({Key? key}) : super(key: key);

  @override
  _MesAbonneesState createState() => _MesAbonneesState();
}

class _MesAbonneesState extends State<MesAbonnees> {
  String userId = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    final compteProvider = Provider.of<CompteProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Compte>>(
          stream: compteProvider.mesabonnes(userId),
          builder: (context, snapshot){
            return snapshot.data == null || snapshot.connectionState == ConnectionState.none
                ? Center(widthFactor: 20, heightFactor: 20, child: CircularProgressIndicator())
                : ListView.builder(
                padding: EdgeInsets.only(top: 20.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          // backgroundImage: NetworkImage(snapshot.data[index].compteProfil,),
                          child: snapshot.data[index].compteProfil == null || snapshot.data[index].compteProfil == "" ? Center(child: Text(
                            snapshot.data[index].compteName.toUpperCase().substring(0, 1),
                            style: TextStyle(
                                fontSize: 24
                            ),
                          ),)  : SizedBox(),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data[index].compteName,
                              softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'Sambold'
                              ),
                            ),
                            Text(
                              snapshot.data[index].compteAbonnes.length.toString(),
                              softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'SamRegular'
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: (){

                          },
                          child: Container(
                            width: 120,
                            height: 30,
                            color: Colors.red,
                            child: Center(
                              child: Text(
                                "s'abonner en retour",
                                softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'SamBold',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: (){

                            },
                            child: Icon(FontAwesomeIcons.ellipsisV, color: Colors.black54,)
                        ),
                      ],
                    ),
                  );
                }
            );
          }
      ),
    );
  }
  dscsdcsd(){
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          // backgroundImage: NetworkImage(snapshot.data[index].compteProfil,),
          child: Icon(Icons.phone_android,),
        ),
        Column(
          children: [
            Text(
              "Mobile recharge",
              style: TextStyle(
                  fontFamily: 'Sambold'
              ),
            ),
            Text(
              "2 min ago",
              style: TextStyle(
                  fontFamily: 'SamRegular'
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
          },

          child: Container(
            width: 80,
            height: 20,
            child: Center(
              child: Text(
                "s'abonner en retour",
                softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'SamBold',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
              // padding: MaterialStateProperty.all(EdgeInsets.only(left: 10, right: 10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    // side: BorderSide(color: Colors.red)
                  )
              )
          ),
        ),
      ],
    );
  }
}
