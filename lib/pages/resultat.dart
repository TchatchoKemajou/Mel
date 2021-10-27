import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/models/produit.dart';
import 'package:flutter_app/provider/produit_provider.dart';
import 'package:flutter_app/services/compteservice.dart';
import 'package:flutter_colored_progress_indicators/flutter_colored_progress_indicators.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'article_detail.dart';

class ResultPage extends StatefulWidget {
  final String collection;
  final String categorie;

  ResultPage({this.collection, this.categorie});
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String userId = FirebaseAuth.instance.currentUser.uid;
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
    super.initState();
  }

  Future<void> _refreshState() async {
    await Future.delayed(Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    final produitprovider =  Provider.of<ProduitProvider>(context);
    //final articleProvider = Provider.of<ArticleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.categorie == null ? "All" : widget.categorie,
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'SamRegular'
          ),
        ) ,
        elevation: 0.0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ColoredRefreshIndicator(
          child: StreamBuilder<List<Produit>>(
              stream: widget.collection == null ? produitprovider.articlesresultat(widget.categorie) : widget.categorie == null ? produitprovider.articlescolllection(widget.collection) : produitprovider.articlesCatalogue(widget.categorie, widget.collection),
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
      ),
    );
  }
}
