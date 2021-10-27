import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constantes.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/models/produit.dart';
import 'package:flutter_app/provider/compteprovider.dart';
import 'package:flutter_app/provider/produit_provider.dart';
import 'package:flutter_app/services/compteservice.dart';
import 'package:provider/provider.dart';

class Panier extends StatefulWidget {
  @override
  _PanierState createState() => _PanierState();
}

class _PanierState extends State<Panier> {

  String userId = FirebaseAuth.instance.currentUser.uid;
  int subtotal, total;
  int taxes = 0;
  Compte user, userConnecter;
  String username;

  Future<void> getcurrentuser(String id) async{
    final result = await CompteService().getCurrentCompte(userId);
    setState(() {
      user = result;
    });
  }
  Future<void> getUserConnecter() async{
    // User user = await sauth.user;
    final result = await CompteService().getCurrentCompte(userId);
    setState(() {
      userConnecter = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserConnecter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final produitprovider =  Provider.of<ProduitProvider>(context);
    //final articleProvider = Provider.of<ArticleProvider>(context);
    final compteProvider = Provider.of<CompteProvider>(context);
    compteProvider.loadAll(userConnecter);
    subtotal = userConnecter != null ? userConnecter.compteFacture : 0;
    total = subtotal + taxes;
    return Scaffold(
      // backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              "Panier",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'SamBold',
                  letterSpacing: 1.0,
                  fontSize: 18
              ),
            ),
            Icon(Icons.shopping_cart, color: secondcolor, size: 18,),
          ],
        ) ,
        elevation: 0.0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      bottomSheet: apercufacture(),
      body: StreamBuilder<List<Produit>>(
          stream: produitprovider.panier,
          builder: (context, snapshot) {
            return snapshot.data == null
                ? Center(child: Text("Aucun article dans le panier"),)
                : ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  // for(int i=0; i<snapshot.data.length; i++){
                  //
                  // }
                  getcurrentuser(snapshot.data[index].productSeller);
                  return  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    width: double.infinity,
                    height: 100,
                    child: Stack(
                      children: [
                        Card(
                          margin: EdgeInsets.only(left: 10, right: 10.0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: snapshot.data[index].productImage[0],
                                placeholder: (context, url) => Image(
                                  image: AssetImage('assets/images/cadeau.png'),
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data[index].productReference,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'SamBold'
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "couleur: noir",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'SamRegular'
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        Row(
                                          children: [
                                            Text(
                                              snapshot.data[index].productListNegocian.contains(userId) ? snapshot.data[index].productMinimalPrice.toString() :snapshot.data[index].productSellerPrice.toString(),
                                              style: TextStyle(
                                                color: fisrtcolor,
                                                fontFamily: 'SamBold',
                                                letterSpacing: 1.0,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Text(
                                              "FCFA",
                                              style: TextStyle(
                                                // color: Colors.black,
                                                fontFamily: 'SamRegular',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // Icon(
                                        //   Icons.location_on,
                                        //   color: Colors.grey,
                                        // ),
                                        // SizedBox(width: 30.0,),
                                        user != null
                                            ? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                          "par:",
                                          style: TextStyle(
                                                // color: Colors.grey,
                                                  fontFamily: 'SamBold',
                                                  fontSize: 14,
                                                  color: secondcolor
                                          ),
                                        ),
                                                SizedBox(width: 10.0,),
                                                Text(
                                                    user.compteName,
                                                  style: TextStyle(
                                                      fontFamily: 'SamBold',
                                                      fontSize: 14,
                                                      color: secondcolor
                                                  ),
                                                )
                                              ],
                                            )
                                            :Text(""),
                                         //SizedBox(width: 30.0,),
                                        Icon(
                                            Icons.keyboard_arrow_right,
                                            color: secondcolor
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: 5.0,
                          top: 0.0,
                          child: IconButton(
                            icon: Icon(Icons.delete_forever_outlined, color: Colors.red,),
                            onPressed: () {
                              int price = snapshot.data[index].productListNegocian.contains(userId) ? snapshot.data[index].productMinimalPrice :snapshot.data[index].productSellerPrice;
                              compteProvider.changeCompteFacture = userConnecter.compteFacture -  price;
                              produitprovider.loadall(snapshot.data[index]);
                              produitprovider.productPanier.remove(userId);
                              compteProvider.saveCompte(userId);
                              produitprovider.saveArticle();
                            },
                            // color: thirdcolor,
                          ),
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


  apercufacture(){
    //final notifyme = Provider.of<NotificationService>(context);
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'SamBold',
                  letterSpacing: 1.5,
                ),
              ),

              Row(
                children: [
                  Text(
                    subtotal.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SamBold',
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "FCFA",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'SamRegular',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Taxes",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'SamBold',
                  letterSpacing: 1.5,
                ),
              ),

              Row(
                children: [
                  Text(
                    taxes.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SamBold',
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "FCFA",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'SamRegular',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'SamBold',
                  letterSpacing: 1.5,
                ),
              ),

              Row(
                children: [
                  Text(
                    total.toString(),
                    style: TextStyle(
                      color: fisrtcolor,
                      fontFamily: 'SamBold',
                      letterSpacing: 1.0,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "FCFA",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'SamRegular',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // notifyme.instantNofitication();
            },
            child: Text(
              "Valider",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'SamBold',
                  letterSpacing: 1.5
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => secondcolor),
                padding: MaterialStateProperty.all(EdgeInsets.only(left: 80, right: 80)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      // side: BorderSide(color: Colors.red)
                    )
                )
            ),
          ),
        ],
      ),
    );
  }
}
