import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:connectivity/connectivity.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/models/produit.dart';
import 'package:flutter_app/pages/article_detail.dart';
import 'package:flutter_app/pages/collection_page.dart';
import 'package:flutter_app/pages/message.dart';
import 'package:flutter_app/pages/nearbycity.dart';
import 'package:flutter_app/pages/new_arrival.dart';
import 'package:flutter_app/pages/resultat.dart';
import 'package:flutter_app/pages/seach_page.dart';
import 'package:flutter_app/pages/vente_flash.dart';
import 'package:flutter_app/pages/wishlist.dart';
import 'package:flutter_app/provider/locationservice.dart';
import 'package:flutter_app/provider/produit_provider.dart';
import 'package:flutter_app/services/authservice.dart';
import 'package:flutter_app/services/compteservice.dart';
import 'package:flutter_colored_progress_indicators/flutter_colored_progress_indicators.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:toast/toast.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import '../constantes.dart';

class Homescreen extends StatefulWidget{
  @override
  _Homescreen createState() => _Homescreen();

}
class _Homescreen extends State<Homescreen>{
  AuthService sauth = AuthService();
  FirebaseAuth auth = FirebaseAuth.instance;
  Compte user;
  String userId = FirebaseAuth.instance.currentUser.uid;
  Stream<List<Produit>> produits;
  String location;
  Placemark placemark;
  String place;

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  double border = 0;
  String title = '';
  String flashDuration = "23:15:46";
  var subscription;
  bool internet;

  // timer
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);

  void startTimer(){
    Timer(dur, keeprunning);
  }

  Text stars(int rating){
    String stars = '';
    for(int i = 0; i < rating; i++){
      stars += '★';
    }
    return Text(
      stars,
      style: TextStyle(
        fontFamily: 'MontRegular',
        color: Colors.yellow,
      ),
    );
  }

  void keeprunning(){
    if(swatch.isRunning){
      startTimer();
    }
    setState(() {
      flashDuration = swatch.elapsed.inHours.toString().padLeft(2, "0") + " : " +
          (swatch.elapsed.inMinutes%60).toString().padLeft(2, "0") + " : " +
          (swatch.elapsed.inSeconds%60).toString().padLeft(2, "0");
    });
  }
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
  @override
  void initState() {
    _refreshState();
    getcurrentuse();
    swatch.start();
    startTimer();
    // TODO: implement initState
    super.initState();
  }

  static const colorizeColors = [
    Colors.black,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 18.0,
    fontFamily: 'SamBold',
  );
  @override
  dispose() {
    swatch.stop();
    super.dispose();
    subscription.cancel();
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
    if(await DataConnectionChecker().hasConnection){
      setState(() {
        produits = produitprovider.articles(userId, user == null ? "" : location);
      });
    }else Toast.show("Vous êtes hors connexion", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    /// await Future.delayed(Duration(seconds: 5));
  }


  @override
  Widget build(BuildContext context) {
    final produitprovider =  Provider.of<ProduitProvider>(context);
    produits = produitprovider.articles(userId, user == null ? "" : location);
    // TODO: implement build
    return DraggableHome(
      title: Text(
        "Mel shopping",
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'SamBold'
        ),
      ),
      headerExpandedHeight: 0.40,
      backgroundColor: Colors.white,
      body: [
        SizedBox(height: 20,),
        Wrap(
          runSpacing: 25.0,
          children: [
            getRecently(),
            getflashsale(),
            categorieButton(),
          ],
        )
      ],
      curvedBodyRadius: 0,
      headerWidget: publicte(),
    );
  }

  soldeEnCours(){
    return Row(
      children: [
        Text(
          "1h 3m 2s",
          style: TextStyle(
            color: color1,
            fontFamily: 'SamBold',
            fontSize: 12,
          ),
        )
      ],
    );
  }

  soldeTerminer() {
    return Row(
      children: [
        Icon(
          Icons.timer_off,
          color: color3,
          size: 14,
        ),
        Text(
          "Terminer",
          style: TextStyle(
            color: color3,
            fontFamily: 'SamBold',
            fontSize: 12,
          ),
        )
      ],
    );
  }

  adaezda(){
    final produitprovider =  Provider.of<ProduitProvider>(context);
    produits = produitprovider.articles(userId, user == null ? "" : location);
    final locationservice = Provider.of<LocationService>(context);
    locationservice.getCurrentAdress();
    if(locationservice.place != null){
      setState(() {
        place = locationservice.place.locality;
      });
      //Toast.show(place, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
    return OfflineBuilder(
      connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child){
        final bool connected = connectivity != ConnectivityResult.none;
        return ColoredRefreshIndicator(
          onRefresh: () => _refreshState(),
          child: AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)..scale(scaleFactor),
              duration: Duration(milliseconds: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(border)
              ),
              child: StreamBuilder<List<Produit>>(
                  stream: produits,
                  builder: (context, snapshot) {
                    return CustomScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      slivers: <Widget> [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          // leading: appbar(),
                          leadingWidth: MediaQuery.of(context).size.width * 0.15,
                          backgroundColor:Colors.white,
                          title: topbar(),
                          //titleSpacing: -5,
                          centerTitle: true,
                          snap: true,
                          floating: true,
                          pinned: true,
                          expandedHeight: 150.0,
                          flexibleSpace: FlexibleSpaceBar(
                            background: publicte(),
                            centerTitle: true,
                          ),
                        ),
                        SliverFixedExtentList(
                          delegate: SliverChildListDelegate([
                            getoption(),
                          ]),
                          itemExtent: 775.0,
                        ),
                        connected && internet==true
                            ? snapshot.connectionState == ConnectionState.none || snapshot.data == null
                            ? SliverPadding(padding: EdgeInsets.all(10.0))
                            : SliverPadding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                            sliver: SliverStaggeredGrid.countBuilder(
                              crossAxisCount: 2,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 10,
                              staggeredTileBuilder: (int index) => StaggeredTile.count(1, index.isEven ? 1.5 : 1.5),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return
                                  InkWell(
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
                                            height: 180,
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.data[index].productImage[0],
                                              placeholder: (context, url) => Image(
                                                image: AssetImage('assets/images/cadeau.png'),
                                              ),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                              width: 250,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Container(
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8, top: 5),
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
                                                  bottom: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                              },
                            )
                        )
                            : SliverPadding(padding: EdgeInsets.only(bottom: 500.0))
                      ],
                    );
                  }
              )
          ),
        );
      },
      child: SizedBox(),
    );
  }

  categorieButton(){
    return InkWell(
      onTap: (){
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
          return CollectionPage();
        }));
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 35.0),
          padding: EdgeInsets.only(bottom:15.0, top: 15.0),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(.0),
              border: Border.all(color: fisrtcolor,)
          ),
          child: Center(
            child: Text(
              "Rechercher par catégories",
              style: TextStyle(
                  color: fisrtcolor,
                  fontFamily: 'SamBold'
              ),
            ),
          ),
        ),
      ),
    );
  }

  headerCenter(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Mel shopping",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Monotype',
                fontSize: 35,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 30.0,),
          InkWell(
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                return SearchPage();
              }));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.only(left:10.0, top: 8.0, bottom: 8.0),
              //margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                //border: Border.all(color: Colors.grey,)
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black,),
                  SizedBox(width: 50,),
                  Text(
                      "Rechercher",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'SamBold',
                          fontSize: 15
                      )
                  )
                ],
              ),
            ),
          )
        ]
    );
  }

  direct(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        "Achat direct",
        style: TextStyle(
            color: color1,
            fontFamily: 'SamBold',
            fontSize: 12
        ),
      ),
    );
  }

  infoDirect(){
    return Text(
      "il y'a une semaine",
      style: TextStyle(
          fontFamily: 'SamBold',
          fontSize: 11
      ),
    );
  }

  infoNegociable(){
    return Text(
      "0 enchère",
      style: TextStyle(
          fontFamily: 'SamBold',
          fontSize: 11
      ),
    );
  }

  negociable(){
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
      child: Text(
        "Négociable",
        style: TextStyle(
            color: fisrtcolor,
            fontFamily: 'SamBold',
            fontSize: 12
        ),
      ),
    );
  }

  publicte() {
    return Container(
      // height: 150.0,
      width: double.infinity,
      child: Stack(
        children: [
          Carousel(
            boxFit: BoxFit.cover,
            autoplay: true,
            animationCurve: Curves.fastOutSlowIn,
            animationDuration: Duration(milliseconds: 1000),
            dotSize: 6.0,
            dotIncreasedColor: fisrtcolor,
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
          Align(
              alignment: Alignment.center,
              child: headerCenter()
          )
        ],
      ),
    );
  }

  getRecently(){
    final produitprovider =  Provider.of<ProduitProvider>(context);
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nouveautés",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'SamBold',
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return NewArrival();
                  }));
                },
                child: Text(
                  "Voir plus",
                  style: TextStyle(
                    color: fisrtcolor,
                    fontSize: 16,
                    fontFamily: 'SamBold',
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Container(
            height: 280,
            child: StreamBuilder<List<Produit>>(
                stream: produits,
                builder: (context, snapshot) {
                  return snapshot.data != null
                      ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        return snapshot.hasData
                            ? InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ArticleDetail(article: snapshot.data[index])));
                          },
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              // side: BorderSide(color: Colors.red)
                            ),
                            elevation: 5.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 150,
                                  width: 180,
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data[index].productImage[0],
                                    placeholder: (context, url) => Image(
                                      image: AssetImage('assets/images/cadeau.png'),
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    width: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  width: 180,
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8, top: 5),
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
                                                SizedBox(height: 5,),
                                                Text(
                                                  snapshot.data[index].productReference,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: 'SamBold',
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                snapshot.data[index].productNegociable ? infoNegociable() : infoDirect()
                                              ],
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
                                            right: 5,
                                            top: 15,
                                            // bottom: 10,
                                          ),
                                        ],
                                      ),
                                      snapshot.data[index].productNegociable ? negociable() : direct()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : null;
                      }
                  )
                      :Container();
                }
            ),
          )
        ],
      ),
    );
  }

  getflashsale(){
    final produitprovider =  Provider.of<ProduitProvider>(context);
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                child:  AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Ventes flash',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      'Ventes flash',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      'Ventes flash',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      'Ventes flash',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      'Ventes flash',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      'Ventes flash',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      'Ventes flash',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ],
                  pause: Duration(seconds: 5),
                  isRepeatingAnimation: true,
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return VenteFlash();
                  }));
                },
                child: Text(
                  "Voir plus",
                  style: TextStyle(
                    color: fisrtcolor,
                    fontSize: 16,
                    fontFamily: 'SamBold',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Container(
            height: 250,
            child: StreamBuilder<List<Produit>>(
                stream: produits,
                builder: (context, snapshot) {
                  return snapshot.data != null
                      ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        return snapshot.hasData
                            ? InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ArticleDetail(article: snapshot.data[index])));
                          },
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              // side: BorderSide(color: Colors.red)
                            ),
                            elevation: 5.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 180,
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data[index].productImage[0],
                                        placeholder: (context, url) => Image(
                                          image: AssetImage('assets/images/cadeau.png'),
                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                        width: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: 5,
                                      top: 10,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Center(
                                            child: Text(
                                              "-30",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'SamRegular'
                                              ),
                                            )
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  width: 180,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, top: 5),
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
                                            SizedBox(height: 5,),
                                            Text(
                                              snapshot.data[index].productReference,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'SamBold',
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            snapshot.data[index].productNegociable ? soldeEnCours() : soldeTerminer(),
                                          ],
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
                                        right: 5,
                                        top: 15,
                                        // bottom: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : null;
                      }
                  )
                      :Container();
                }
            ),
          )
        ],
      ),
    );
  }



  topbar(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        appbar(),
        buttontitle(),
        Stack(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20.0)
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.notifications, color: Colors.black54,),
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                      return MessagePage();
                    }));
                  },
                  // color: thirdcolor,
                ),
              ),
            ),
            Positioned(
              right: .0,
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4.0)
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
  getcatalogue(){
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10.0),
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                image: DecorationImage(
                  image: AssetImage('assets/images/pub3.jpg'),
                  fit: BoxFit.cover,
                )
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 8,
                  top: 5.0,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'SamBold',
                        letterSpacing: 0.8
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText('Les meilleurs offres'),
                        WavyAnimatedText('Les meilleurs offres'),
                        WavyAnimatedText('Les meilleurs offres'),
                        WavyAnimatedText('Les meilleurs offres'),
                        WavyAnimatedText('Les meilleurs offres'),
                        WavyAnimatedText('Les meilleurs offres'),
                      ],
                      pause: Duration(seconds: 5),
                      isRepeatingAnimation: true,
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 25.0,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'SamBold',
                        letterSpacing: 0.8
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText('à Yaoundé'),
                        WavyAnimatedText('à Yaoundé'),
                        WavyAnimatedText('à Yaoundé'),
                        WavyAnimatedText('à Yaoundé'),
                        WavyAnimatedText('à Yaoundé'),
                        WavyAnimatedText('à Yaoundé'),
                      ],
                      pause: Duration(seconds: 5),
                      isRepeatingAnimation: true,
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 8.0,
                  top: 50.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                        return NearByCity(city: user == null ? "" : location == "Douala" ? "Yaounde" : "Douala",);
                      }));
                    },
                    child: Text(
                      "Visitez >>",
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SamBold',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.8
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5,),
          Text(
            "Mel catalogue",
            style: TextStyle(
              color: secondcolor,
              fontSize: 18,
              fontFamily: 'SamBold',
              //letterSpacing: 1.0
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                return ResultPage(collection: "Femmes", categorie: "Vêtements",);
              }));
            },
            child: Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: color5,
                  borderRadius: BorderRadius.circular(5.0)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Vêtements \n femmes",
                    style: TextStyle(
                        color: Colors.brown[400],
                        fontSize: 16,
                        fontFamily: 'SamBold'
                    ),
                  ),
                  Container(
                    height: 60,
                    child: Image.asset("assets/images/vetfem.png", fit: BoxFit.cover,),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return ResultPage(collection: "Autres", categorie: "Téléphones");
                  }));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  // padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.brown[50],
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            " Téléphone \n & accessoires",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'SamBold'
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        child: Image.asset("assets/images/phone.png", fit: BoxFit.cover,),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return ResultPage(collection: "Autres", categorie: "Téléphones");
                  }));
                },
                child: Container(
                  // padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.indigo[50],
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            " Ordinateurs",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'SamBold'
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        child: Image.asset("assets/images/computer.png", fit: BoxFit.cover,),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              InkWell(
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return ResultPage(collection: "Autres", categorie: "Sacs");
                  }));
                },
                child: Container(
                  // padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.brown[50],
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "  sacs        ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'SamBold'
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 80,
                        child: Image.asset("assets/images/bac.png", fit: BoxFit.cover,),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return ResultPage(collection: "Autres", categorie: "Electro-Menager");
                  }));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  // padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            " Appareils \n électroniques",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'SamBold'
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        child: Image.asset("assets/images/electronique.png", fit: BoxFit.cover,),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return ResultPage(collection: "Autres", categorie: "Cosmétiques");
                  }));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  // padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            " Produits \n cosmétiques",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'SamBold'
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        child: Image.asset("assets/images/cosmetique.png", fit: BoxFit.cover,),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return ResultPage(collection: "Vêtements", categorie: "Hommes");
                  }));
                },
                child: Container(
                  // padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            " Vêtements \n hommes",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'SamBold'
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        child: Image.asset("assets/images/vethom.png", fit: BoxFit.cover,),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return ResultPage(collection: "Femmes", categorie: "Chaussures");
                  }));
                },
                child: Container(
                  // padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "   Chaussures \n   femmes",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'SamBold'
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        child: Image.asset("assets/images/chaufem.png", fit: BoxFit.cover,),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return ResultPage(collection: "Hommes", categorie: "Chaussures");
                  }));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  // padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            " Chaussures \n  hommes",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'SamBold'
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        child: Image.asset("assets/images/chauhom.png", fit: BoxFit.cover,),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Text(
            "Les offres les plus recentes",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'SamBold',
              //letterSpacing: 0.8
            ),
          ),
        ],
      ),
    );
  }
  buttontitle(){
    return ElevatedButton.icon(
      onPressed: (){
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
          return SearchPage();
        }));
      },
      icon: Icon(Icons.search,),
      label: Text(
          "Search"
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white54),
          padding: MaterialStateProperty.all(EdgeInsets.only(left: 40, right: 40)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                // side: BorderSide(color: Colors.red)
              )
          )
      ),
    );
  }
  searchbar(){
    return Material(
      // elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      child: TextField(
        autocorrect: true,
        style: TextStyle(
          // fontFamily: 'rowregular'
        ),
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: IconButton(
            onPressed: (){},
            icon: Icon(Icons.search, color:  Colors.black,),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                // showfilter(context);
              });
            },
            icon: Icon(Icons.tune, color: secondcolor,),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
  getoption(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: color1,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.new_releases,
                        ),
                        iconSize: 20.0,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                            return NewArrival();
                          }));
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 3,),
                  Text(
                    "New Arrival",
                    style: TextStyle(
                      fontFamily: 'SamBold',
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: color2,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.flash_on,
                        ),
                        iconSize: 20.0,
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ),
                  SizedBox(height: 3,),
                  Text(
                    "Soldes",
                    style: TextStyle(
                      fontFamily: 'SamBold',
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: color3,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                        ),
                        iconSize: 20.0,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                            return WishList();
                          }));
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 3,),
                  Text(
                    "Wishlist",
                    style: TextStyle(
                      fontFamily: 'SamBold',
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: color4,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.monetization_on,
                        ),
                        iconSize: 20.0,
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ),
                  SizedBox(height: 3,),
                  Text(
                    "Bargains",
                    style: TextStyle(
                      fontFamily: 'SamBold',
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 15,),
        getflashsale(),
        getcatalogue(),
      ],
    );
  }
  appbar(){
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: Center(
        child: isDrawerOpen
            ? IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black54,),
            onPressed: (){
              //u = auth.currentUser;
              setState(() {
                //  title = ImageService().testtext();
                // print(u.email);
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                border = 0;
                isDrawerOpen = false;
              });
            }
        )
            : IconButton(
            icon: Icon(Icons.menu, color: Colors.black54,),
            onPressed: (){
              setState(() {
                xOffset = 230;
                yOffset = 150;
                scaleFactor = 0.6;
                // border = 40;
                isDrawerOpen = true;
              });
            }
        ),
      ),
    );
  }
}