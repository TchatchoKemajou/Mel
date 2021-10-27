import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/provider/compteprovider.dart';
import 'package:flutter_app/services/compteservice.dart';
import 'package:provider/provider.dart';

class MesAbonnements extends StatefulWidget {
 // const MesAbonnements({Key? key}) : super(key: key);

  @override
  _MesAbonnementsState createState() => _MesAbonnementsState();
}

class _MesAbonnementsState extends State<MesAbonnements> {
  String userId = FirebaseAuth.instance.currentUser.uid;
  Compte user, userconnect;


  Future<void> getcurrentuse(String id) async{
    // User user = await sauth.user;
    final result = await CompteService().getCurrentCompte(id);
    setState(() {
      user = result;
    });
  }

  Future<void> getcurrentuser() async{
    // User user = await sauth.user;
    final result = await CompteService().getCurrentCompte(userId);
    setState(() {
      userconnect = result;
    });
  }
  @override
  Widget build(BuildContext context) {
    final compteProvider = Provider.of<CompteProvider>(context);
    final compteProvider2 = Provider.of<CompteProvider>(context);
    getcurrentuser();
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Compte>>(
          stream: compteProvider.mesabonnements(userId),
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
                            getcurrentuse(snapshot.data[index].compteId);
                            if(user.compteAbonnes.contains(userId)){
                              setState(() {
                                user.compteAbonnes.remove(userId);
                                userconnect.compteAbonnement.remove(user.compteId);
                                compteProvider.loadAll(user);
                                compteProvider2.loadAll(userconnect);
                              });
                              // Toast.show( user.compteName + "ajouté", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                            }else{
                              setState(() {
                                user.compteAbonnes.add(userId);
                                userconnect.compteAbonnement.add(user.compteId);
                                compteProvider.loadAll(user);
                                compteProvider2.loadAll(userconnect);
                              });
                            }
                            compteProvider.saveCompte(compteProvider.compteId);
                            compteProvider2.saveCompte(compteProvider2.compteId);
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
                            child: Icon(Icons.notifications,color: Colors.black54)
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
}
