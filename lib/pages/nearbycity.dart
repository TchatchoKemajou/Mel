import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/models/produit.dart';
import 'package:flutter_app/provider/produit_provider.dart';
import 'package:flutter_app/services/authservice.dart';
import 'package:flutter_app/services/compteservice.dart';
import 'package:flutter_colored_progress_indicators/flutter_colored_progress_indicators.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:toast/toast.dart';

import 'article_detail.dart';

class NearByCity extends StatefulWidget {
  final String city;
  NearByCity({this.city});

  @override
  _NearByCityState createState() => _NearByCityState();
}

class _NearByCityState extends State<NearByCity> {

  AuthService sauth = AuthService();
  FirebaseAuth auth = FirebaseAuth.instance;
  Compte user;
  String userId = FirebaseAuth.instance.currentUser.uid;
  Stream<List<Produit>> produits;
  String location;

  var subscription;
  bool internet;
  Future<void> getcurrentuse() async{
    // User user = await sauth.user;
    final result = await CompteService().getCurrentCompte(userId);
    setState(() {
      user = result;
      location = user.compteAddress["ville"];
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


  isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network, make sure there is actually a net connection.
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
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a WIFI network, make sure there is actually a net connection.
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
    } else {
      // Neither mobile data or WIFI detected, not internet connection found.
      setState(() {
        internet = false;
      });
    }
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

  Future<void> _refreshState() async {
    final produitprovider =  Provider.of<ProduitProvider>(context, listen: false);
    setState(() {
      produits = produitprovider.articles(auth.currentUser.uid, user == null ? "" : location);
    });
    await Future.delayed(Duration(seconds: 5));
  }
  @override
  Widget build(BuildContext context) {
    final produitprovider =  Provider.of<ProduitProvider>(context);
    produits = produitprovider.articles(auth.currentUser.uid, user == null ? "" : location);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.city == null ? "All" : widget.city,
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
      ),
      body: OfflineBuilder(
        connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child){
          final bool connected = connectivity != ConnectivityResult.none;
          return ColoredRefreshIndicator(
              child: StreamBuilder<List<Produit>>(
                  stream: produits,
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? Center(child: Text("Aucun article dans votre liste"),)
                        : CustomScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      slivers: <Widget> [
                        snapshot.data != null
                            ? SliverPadding(
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
                                                          snapshot.data[index].productSellerPrice.toString(),
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
                            : SliverPadding(padding: EdgeInsets.all(10.0))
                      ],
                    );
                  }
              ),
              onRefresh: _refreshState
          );
        },
        child: SizedBox(),
      ),
    );
  }
}
