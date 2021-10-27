import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/produit.dart';
import 'package:flutter_app/provider/produit_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'article_detail.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    final produitprovider =  Provider.of<ProduitProvider>(context);
    //final articleProvider = Provider.of<ArticleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("WishList"),
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
      body: StreamBuilder<List<Produit>>(
          stream: produitprovider.wishlist,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.none
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
                            child: Container(
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
                                    ],
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
