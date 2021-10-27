import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/models/produit.dart';
import 'package:flutter_app/provider/produit_provider.dart';
import 'package:flutter_app/services/compteservice.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../constantes.dart';
import '../utilitaire.dart';
import 'article_detail.dart';

class VenteFlash extends StatefulWidget {
  @override
  _VenteFlashState createState() => _VenteFlashState();
}

class _VenteFlashState extends State<VenteFlash> {
  CustomTimerController flashController;
  String userId = FirebaseAuth.instance.currentUser.uid;
  String place;
  Utilitaire utilitaire = Utilitaire();

  getPlace() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if(localStorage.containsKey('place')){
      place = await utilitaire.getLocation();
    }else place = "";
  }

  Compte user;
  Future<void> getcurrentuse() async{
    // User user = await sauth.user;
    final result = await CompteService().getCurrentCompte(userId);
    setState(() {
      user = result;
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
    //flashController.state(1);
   // flashController.reset();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    //flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getcurrentuse();
    final produitprovider =  Provider.of<ProduitProvider>(context);
    //final articleProvider = Provider.of<ArticleProvider>(context);
    getPlace();
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        bottom: PreferredSize(
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/header2.png'),
                    fit: BoxFit.fill
                )
            ),
            child: Container(
              padding: EdgeInsets.only(left: 20.0),
              //color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "cette vente se termine dans:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Monotype',
                    ),
                  ),
                   CustomTimer(
                    from: Duration(hours: 2),
                    to: Duration(hours: 0),
                    controller: flashController,
                    onBuildAction: CustomTimerAction.auto_start,
                    builder: (CustomTimerRemainingTime remaining) {
                      return Text(
                        "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                        style: TextStyle(
                            fontSize: 30.0,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(50),
        ),
        title: Text(
            "Vente Flash",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'SamBold',
            letterSpacing: 1.0
          ),
        ),
        flexibleSpace: Container(
          width: double.infinity,
          // height: 80,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/header2.png'),
                  fit: BoxFit.cover
              )
          ),
        ),
      ),
      body: StreamBuilder<List<Produit>>(
          stream: produitprovider.articles(FirebaseAuth.instance.currentUser.uid, place),
          builder: (context, snapshot) {
            return CustomScrollView(
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
                                Stack(
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
                                    Container(
                                      padding: EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))
                                      ),
                                      child: Center(child: Text(
                                        "- 60%",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'SamBold',
                                        ),
                                      ),),
                                    )
                                  ],
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
    );
  }
}
