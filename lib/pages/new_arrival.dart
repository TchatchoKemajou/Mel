import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/models/produit.dart';
import 'package:flutter_app/provider/produit_provider.dart';
import 'package:flutter_app/services/compteservice.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../constantes.dart';
import '../utilitaire.dart';
import 'article_detail.dart';

class NewArrival extends StatefulWidget {
  @override
  _NewArrivalState createState() => _NewArrivalState();
}

class _NewArrivalState extends State<NewArrival> {

  String userId = FirebaseAuth.instance.currentUser.uid;
  var subscription;
  bool internet;
  String place;
  Utilitaire utilitaire = Utilitaire();
  Compte user;
  Future<void> getcurrentuse() async{
    // User user = await sauth.user;
    final result = await CompteService().getCurrentCompte(userId);
    setState(() {
      user = result;
    });
  }

  checkconnectivity() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    subscription = Connectivity().onConnectivityChanged.listen((connectivityResult) async {
      // Got a new connectivity status!
      if (connectivityResult == ConnectivityResult.none) {
        // I am connected to a mobile network.
        Toast.show("echec de connexion", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        if (await DataConnectionChecker().hasConnection) {
          // Wifi detected & internet connection confirmed.
          setState(() {
            internet = true;
          });
        } else {
          // Wifi detected but no internet connection found.
          setState(() {
            internet = false;
          });
        }
        Toast.show("connexion wifi", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }else if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a wifi network.
        if (await DataConnectionChecker().hasConnection) {
          // Mobile data detected & internet connection confirmed.
          setState(() {
            internet = true;
          });
        } else {
          // Mobile data detected but no internet connection found.
          setState(() {
            internet = false;
          });
        }
        Toast.show("connexion mobile", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
    });
  }

  Text start(int rating){
    String stars = '';
    for(int i = 0; i < rating; i++){
      stars += '★';
    }
    return Text(
      stars,
      style: TextStyle(
        fontFamily: 'MontRegular',
        color: Colors.deepOrange,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isInternet();
    checkconnectivity();
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  getPlace() async{
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      if(localStorage.containsKey('place')){
        place = await utilitaire.getLocation();
      }else place = "";
  }

  @override
  Widget build(BuildContext context) {
    final produitprovider =  Provider.of<ProduitProvider>(context);
    getPlace();
   // final articleProvider = Provider.of<ArticleProvider>(context);
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text("New Arrival"),
        flexibleSpace: Container(
          width: double.infinity,
          // height: 80,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/header1.png'),
                  fit: BoxFit.fill
              )
          ),
        ),
      ),
      body: OfflineBuilder(
          child: SizedBox(),
          connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child){
            final bool connected = connectivity != ConnectivityResult.none;
            return   StreamBuilder<List<Produit>>(
                stream: produitprovider.articles(userId, place),
                builder: (context, snapshot) {
                  return CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: <Widget> [
                      connected
                          ? snapshot.connectionState == ConnectionState.none || snapshot.data == null
                          ? SliverPadding(padding: EdgeInsets.all(10.0))
                          : SliverPadding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                          sliver: SliverStaggeredGrid.countBuilder(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            staggeredTileBuilder: (int index) => StaggeredTile.count(1, index.isEven ? 1.5 : 1.5),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return snapshot.hasData
                                  ? InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ArticleDetail(article: snapshot.data[index])));
                                },
                                child: Card(
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data[index].productImage[0],
                                          placeholder: (context, url) => Image(
                                            image: AssetImage('assets/images/cadeau.png'),
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          width: 250,
                                          height: 180,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        snapshot.data[index].productPrice.toString(),
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
                                                          color: Colors.black,
                                                          fontFamily: 'SamBold',
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    snapshot.data[index].productReference,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: 'SamRegular',
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  start(4),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            child: IconButton(
                                              icon: snapshot.data[index].productFavories.contains(userId) ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border, color: Colors.black54,),
                                              iconSize: 24.0,
                                              color: Colors.black,
                                              onPressed: () {
                                                if(snapshot.data[index].productFavories.contains(userId)){
                                                  setState(() {
                                                    snapshot.data[index].productFavories.remove(userId);
                                                    produitprovider.loadall(snapshot.data[index]);
                                                  });
                                                }else {
                                                  setState(() {
                                                    snapshot.data[index].productFavories.add(userId);
                                                    produitprovider.loadall(snapshot.data[index]);
                                                  });
                                                }
                                                produitprovider.saveArticle();
                                                Toast.show("Whishlist ajouté", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                              },
                                            ),
                                            right: 0,
                                            bottom: -15,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  : null;
                            },
                          )
                      )
                          : SliverPadding(padding: EdgeInsets.only(bottom: 500.0))
                    ],
                  );
                }
            );
          }
      ),
    );
  }
}
