import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/models/produit.dart';
import 'package:flutter_app/pages/profil.dart';
import 'package:flutter_app/provider/compteprovider.dart';
import 'package:flutter_app/provider/produit_provider.dart';
import 'package:flutter_app/services/authservice.dart';
import 'package:flutter_app/services/compteService.dart';
import 'package:flutter_app/services/linkservice.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../constantes.dart';

class ArticleDetail extends StatefulWidget {
  final Produit article;

  ArticleDetail({this.article});

  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  final linkservice = DynamicLinkService();
  String link;
  AuthService sauth = AuthService();
  Compte user, userConnecter;
  String userId = FirebaseAuth.instance.currentUser.uid;
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

  Future<void> getUserSeller() async{
    // User user = await sauth.user;
    final result = await CompteService().getCurrentCompte(widget.article.productSeller);
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
    final produitprovider =  Provider.of<ProduitProvider>(context, listen: false); 
    if(widget.article != null){
      produitprovider.loadall(widget.article);
      getUserSeller();
    }else{
      produitprovider.loadall(null);
    }
    getUserConnecter();
    shareLink();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final produitprovider =  Provider.of<ProduitProvider>(context);
    //final articleProvider = Provider.of<ArticleProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Produit>>(
          stream: produitprovider.articlesSimilaire(widget.article.productCategorie, widget.article.productId),
          builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  // leading: appbar(),
                  leadingWidth: MediaQuery.of(context).size.width * 0.15,
                  backgroundColor:Colors.white,
                  title: topbaroption(),
                  //titleSpacing: -5,
                  centerTitle: true,
                  snap: true,
                  floating: true,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  flexibleSpace: FlexibleSpaceBar(
                    background: publicte(),
                    centerTitle: true,
                  ),
                ),
                SliverFixedExtentList(
                  delegate: SliverChildListDelegate([
                    displaydetails(),
                  ]),
                  itemExtent: 750.0,
                ),
                snapshot.data != null
                    ? SliverPadding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                    sliver: SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      staggeredTileBuilder: (int index) => StaggeredTile.count(1, index.isEven ? 1.4 : 1.4),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return snapshot.hasData
                            ? InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ArticleDetail(article: snapshot.data[index])));
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 5.0),
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
                                        width: 100,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Container(
                                    //  // margin: EdgeInsets.only(left: 10.0, top: 5.0),
                                    //   width: 20.0,
                                    //   height: 20.0,
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.0)),
                                    //     color: Colors.red,
                                    //   ),
                                    //   child: Center(
                                    //     child: Text(
                                    //       "- 60%",
                                    //       style: TextStyle(
                                    //         color: Colors.white,
                                    //         fontFamily: 'SamBold',
                                    //         fontSize: 12
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                Container(
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          snapshot.data[index].productPrice.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'SamBold',
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Text(
                                          "FCFA",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'SamBold',
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
                        )
                            : null;
                      },
                    )
                )
                    : SliverPadding(padding: EdgeInsets.all(10.0)),
              ],
            );
          }
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.article.productNegociable == true ? InkWell(
            onTap: () {
              if(widget.article.productNegociable == false){
                Toast.show("cet article n'autorise pas la négociation!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
              }
              else{
                _openDialog(infoNegociation());
              }
            },
            child:  Chip(
              backgroundColor: color2,
              label: Text(
                "Negocier",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'SamBold',
                  letterSpacing: 1.5,
                ),
              ),
              avatar: Icon(
                Icons.hourglass_bottom,
                color: Colors.white,
              ),
            ) ,
          ) : Container(width: 1, height: 1,),
          SizedBox(width: 5,),
          Chip(
            backgroundColor: fisrtcolor,
            label: Text(
              "Achat direct",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'SamBold',
                letterSpacing: 1.5,
              ),
            ),
            avatar: Icon(
              Icons.monetization_on_outlined,
              color: Colors.white,
            ),
          ),
        ],
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
              // borderRadius: true,
              // radius: Radius.circular(10),
              autoplay: false,
              animationCurve: Curves.fastOutSlowIn,
              // animationDuration: Duration(milliseconds: 1000),
              dotSize: 6.0,
              dotIncreasedColor: Color(0xFFFF335C),
              dotBgColor: Colors.transparent,
              dotPosition: DotPosition.bottomRight,
              dotVerticalPadding: 10.0,
              showIndicator: true,
              indicatorBgPadding: 7.0,
              images: [
                for(int i=0; i<widget.article.productImage.length; i++)
                  NetworkImage(widget.article.productImage[i])
              ]
          ),
        ],
      ),
    );
  }

  infoNegociation(){
    final produitprovider =  Provider.of<ProduitProvider>(context, listen: false);
    return Container(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Condition de négociation",
            softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontFamily: 'SamBold',
            ),
            textAlign: TextAlign.center,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Le montant de la négociation de cette article est fixé à ",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontFamily: 'SamBold',
                ),
                children: [
                  TextSpan(text: produitprovider.productSellerPrice.toString(), style: TextStyle(
                    color: secondcolor,
                    fontFamily: 'SamBold',
                    fontSize: 14
                  )),
                  TextSpan(text: " FCFA  "),
                  TextSpan(text: "la vente est attribué  au premeier acheteur."),
                ]
            ),

          ),
          Text(
            "Si vous choisissez l'option plus tard l'article sera ajouté au panier",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'SamBold',
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Voulez vous achetez ?",
            softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'SamBold',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

    void _openDialog(Widget content) {
      final produitprovider =  Provider.of<ProduitProvider>(context, listen: false);
      final compteProvider = Provider.of<CompteProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          // title: Text(title),
          content: content,
          actions: [
            Row(
              children: [
                FlatButton(
                  child: Text(
                    'Annuler',
                    softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontFamily: 'PopBold',
                    ),
                  ),
                  onPressed: Navigator.of(context).pop,
                ),
                FlatButton(
                  child: Text(
                    'Plus tard',
                    softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: color1,
                      fontFamily: 'PopBold',
                    ),
                  ),
                  onPressed: () {
                    if(widget.article.productPanier.contains(userId)){
                      Toast.show("votre panier contient déjà cette article", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.TOP);
                    }else {
                      setState(() {
                        compteProvider.changeCompteFacture = compteProvider.compteFacture + widget.article.productMinimalPrice;
                        widget.article.productPanier.add(userId);
                        produitprovider.loadall(widget.article);
                        compteProvider.saveCompte(userId);
                        produitprovider.saveArticle();
                        Toast.show("Article ajouté avec succès", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    'Maintenant',
                    softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontFamily: 'PopBold',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> shareLink() async{
    Uri image =  Uri.parse(widget.article.productImage[0]);
   final linkuri = await linkservice.createDynamicLink(widget.article.productId, widget.article.productReference, widget.article.productDescription, image);
   setState(() {
     link = linkuri.toString();
   });
  }

  topbaroption() {
    final produitprovider =  Provider.of<ProduitProvider>(context);
    final compteProvider = Provider.of<CompteProvider>(context);
    compteProvider.loadAll(userConnecter);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              icon: Icon(Icons.arrow_back, color: Colors.black,),
              onPressed: () {
                Navigator.pop(context);
              },
              // color: thirdcolor,
            ),
          ),
        ),
        Row(
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
                  icon: Icon(Icons.share, color: Colors.black54,),
                  onPressed: () {
                   // shareLink();
                    Share.share(link);
                  },
                  // color: thirdcolor,
                ),
              ),
            ),
            SizedBox(width: 5.0,),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20.0)
              ),
              child: Center(
                child: IconButton(
                  icon: widget.article.productPanier.contains(userId) ? Icon(Icons.add_shopping_cart_sharp, color: color1,)
                      : Icon(Icons.add_shopping_cart_sharp, color: Colors.black54,),
                  onPressed: () {
                    if(widget.article.productPanier.contains(userId)){
                      Toast.show("votre panier contient déjà cette article", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.TOP);
                    }else {
                      setState(() {
                        compteProvider.changeCompteFacture = compteProvider.compteFacture + widget.article.productSellerPrice;
                        widget.article.productPanier.add(userId);
                        produitprovider.loadall(widget.article);
                        compteProvider.saveCompte(userId);
                        produitprovider.saveArticle();
                        Toast.show("Article ajouté avec succès", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                      });
                    }
                  },
                  // color: thirdcolor,
                ),
              ),
            ),
            SizedBox(width: 5.0,),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20.0)
              ),
              child: Center(
                child: IconButton(
                  icon: widget.article.productFavories.contains(userId) ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border, color: Colors.black54,),
                  onPressed: () {
                    if(widget.article.productFavories.contains(userId)){
                      setState(() {
                        widget.article.productFavories.remove(userId);
                        produitprovider.loadall(widget.article);
                      });
                    }else {
                      setState(() {
                        widget.article.productFavories.add(userId);
                        produitprovider.loadall(widget.article);
                      });
                    }
                    produitprovider.saveArticle();
                    Toast.show("Whishlist ajouté", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                  },
                  // color: thirdcolor,
                ),
              ),
            ),
            SizedBox(width: 5.0,),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white54,
                 // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(20.0)
              ),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      // Respond to button press
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                        return new Profil(id: user.compteId,);
                      }));
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: user != null ? NetworkImage(user.compteProfil,) : null,
                      child: user != null ? user.compteProfil == null || user.compteProfil == "" ? Center(child: Text(
            user.compteName.toUpperCase().substring(0, 1),
          style: TextStyle(
            fontSize: 24
          ),
        ),) : SizedBox() : SizedBox(),
                      // child: user != null ?
                      // CachedNetworkImage(
                      //   imageUrl: user.compteProfil == null ? "" : user.compteProfil,
                      //   placeholder: (context, url) => Text(
                      //     user.compteName.toUpperCase().substring(0, 1)
                      //   ),
                      //   errorWidget: (context, url, error) => Center(
                      //     child: Text(
                      //         user.compteName.toUpperCase().substring(0, 1),
                      //       style: TextStyle(
                      //         fontSize: 24
                      //       ),
                      //     ),
                      //   ),
                      //   width: 40,
                      //   height: 40,
                      //   fit: BoxFit.cover,
                      // )
                      // :SizedBox(),
                    ),
                  ),
                  Positioned(
                    // alignment: Alignment.bottomCenter,
                    bottom: .0,
                    right: .0,
                    child: InkWell(
                      onTap: () {
                        if(user.compteAbonnes.contains(userId)){
                          // setState(() {
                          //   user.userAbonnes.remove(userId);
                          //   userprovider.loadAll(user);
                          // });
                          Toast.show( user.compteName + "ajouté", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                        }else{
                          setState(() {
                            user.compteAbonnes.add(userId);
                            compteProvider.loadAll(user);
                          });
                        }
                        compteProvider.saveCompte(compteProvider.compteId);
                      },
                      child: widget.article.productSeller != userId  ? Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: color1,
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Center(
                          child:
                          user.compteAbonnes.contains(userId)
                              ? Icon(Icons.check, color: Colors.white, size: 12,)
                              : Icon(Icons.add, color: Colors.white, size: 12,),
                        ),
                      ) : Container(),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  getdivider(){
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      width: double.infinity,
      height: 0.3,
      color: Colors.grey,
    );
  }

  displaydetails() {
    final produitprovider =  Provider.of<ProduitProvider>(context);
    //final articleProvider = Provider.of<ArticleProvider>(context);
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // premier bloc
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.article.productReference,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SamBold',
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "FCFA",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'PopSemi',
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text(
                        widget.article.productSellerPrice.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'PopSemi',
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  stars(5),
                ],
              ),
              SizedBox(height: 15,),
              widget.article.productNegociable == true ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "0 enchères",
                    style: TextStyle(
                      color: fisrtcolor,
                      fontSize: 14,
                      fontFamily: 'SamBold',
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Plafond: ",
                        style: TextStyle(
                          //color: color1,
                          fontSize: 14,
                          fontFamily: 'SamRegular',
                        ),
                      ),
                      Text(
                        widget.article.productSellerPrice.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'SamBold',
                           // decoration: TextDecoration.lineThrough
                        ),
                      ),
                    ],
                  ),
                ],
              ) : Container(),
              SizedBox(height: 15,),
              ExpandablePanel(
                header: Text(
                  "Description",
                  style: TextStyle(
                      //color: secondcolor,
                      fontSize: 15,
                      letterSpacing: 1.0,
                      fontFamily: 'SamRegular'
                  ),
                ),
                collapsed: Text(widget.article.productDescription, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                     color: Colors.black,
                      fontSize: 14,
                      letterSpacing: 1.0,
                      fontFamily: 'SamRegular'
                  ),),
                expanded: Text(widget.article.productDescription, softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      letterSpacing: 1.0,
                      fontFamily: 'SamRegular'
                  ),),
              )
            ],
          ),
         // SizedBox(height: 20,),
          getdivider(),
          // deuxième bloc
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Caractéristique",
                style: TextStyle(
                   // color: secondcolor,
                    fontSize: 15,
                    letterSpacing: 1.0,
                    fontFamily: 'SamRegular'
                ),
              ),
              SizedBox(height: 5.0,),
              Wrap(
                spacing: 30.0,
                runSpacing: 5.0,
                children: [
                  Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "couleur: ",
                          style: TextStyle(
                              //color: Colors.black,
                              fontSize: 13,
                              letterSpacing: 1.0,
                              fontFamily: 'SamRegular'
                          )
                      ),
                      Text(
                        produitprovider.productCaracteristique["couleur"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              letterSpacing: 1.0,
                              fontFamily: 'SamBold'
                          )
                      ),
                    ],
                  ),
                  produitprovider.productCategorie == "Chaussures" || produitprovider.productCategorie == "Vètements" || produitprovider.productCategorie == "Télévision" ? Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "taille: ",
                          style: TextStyle(
                            //color: Colors.black,
                              fontSize: 13,
                              letterSpacing: 1.0,
                              fontFamily: 'SamRegular'
                          )
                      ),
                      Text(
                         produitprovider.productCaracteristique["taille"].toString() + produitprovider.productCategorie == "Télévision" ? "pouce" : "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 1.0,
                              fontFamily: 'SamBold'
                          )
                      ),
                    ],
                  ) : SizedBox(),
                  produitprovider.productCategorie == "Ordinateurs" || produitprovider.productCategorie == "Téléphones" ? Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Ram: ",
                          style: TextStyle(
                            //color: Colors.black,
                              fontSize: 13,
                              letterSpacing: 1.0,
                              fontFamily: 'SamRegular'
                          )
                      ),
                      Text(
                        produitprovider.productCaracteristique["ram"] ,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 1.0,
                              fontFamily: 'SamBold'
                          )
                      ),
                    ],
                  ) : SizedBox(),
                  produitprovider.productCategorie == "Ordinateurs" || produitprovider.productCategorie == "Téléphones" ?  Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Stockage: ",
                          style: TextStyle(
                            //color: Colors.black,
                              fontSize: 13,
                              letterSpacing: 1.0,
                              fontFamily: 'SamRegular'
                          )
                      ),
                      Text(
                        produitprovider.productCaracteristique["stockage"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 1.0,
                              fontFamily: 'SamBold'
                          )
                      ),
                    ],
                  ) : SizedBox(),
                  produitprovider.productCategorie == "Ordinateurs" ? Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Système d'exploitation: ",
                          style: TextStyle(
                            //color: Colors.black,
                              fontSize: 13,
                              letterSpacing: 1.0,
                              fontFamily: 'SamRegular'
                          )
                      ),
                      Text(
                        produitprovider.productCaracteristique["os"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 1.0,
                              fontFamily: 'SamBold'
                          )
                      ),
                    ],
                  ) : SizedBox(),
                  produitprovider.productCategorie == "Ordinateurs" || produitprovider.productCategorie == "Téléphones" ? Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "CPU(GHz): ",
                          style: TextStyle(
                            //color: Colors.black,
                              fontSize: 13,
                              letterSpacing: 1.0,
                              fontFamily: 'SamRegular'
                          )
                      ),
                      Text(
                        produitprovider.productCaracteristique["cpu"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 1.0,
                              fontFamily: 'SamBold'
                          )
                      ),
                    ],
                  ) :SizedBox(),
                  produitprovider.productCategorie == "Téléphones" ? Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Camera avant: ",
                          style: TextStyle(
                            //color: Colors.black,
                              fontSize: 13,
                              letterSpacing: 1.0,
                              fontFamily: 'SamRegular'
                          )
                      ),
                      Text(
                        produitprovider.productCaracteristique["pixelavant"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 1.0,
                              fontFamily: 'SamBold'
                          )
                      ),
                    ],
                  ) : SizedBox(),
                  produitprovider.productCategorie == "Téléphones" ? Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Camera arrière: " ,
                          style: TextStyle(
                            //color: Colors.black,
                              fontSize: 13,
                              letterSpacing: 1.0,
                              fontFamily: 'SamRegular'
                          )
                      ),
                      Text(
                        produitprovider.productCaracteristique["pixelarrier"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 1.0,
                              fontFamily: 'SamBold'
                          )
                      ),
                    ],
                  ) :SizedBox(),
                ],
              ),
            ],
          ),
          getdivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Etat",
                style: TextStyle(
                   // color: secondcolor,
                    fontSize: 16,
                    letterSpacing: 1.0,
                    fontFamily: 'SamRegular'
                ),
              ),
              SizedBox(height: 10,),
              Text(widget.article.productEtat, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    letterSpacing: 1.0,
                    fontFamily: 'SamBold'
                ),),
            ],
          ),
          getdivider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Catégorie",
                style: TextStyle(
                  // color: secondcolor,
                    fontSize: 15,
                    letterSpacing: 1.0,
                    fontFamily: 'SamRegular'
                ),
              ),
              SizedBox(height: 5.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.article.productCategorie,
                    style: TextStyle(
                      color: fisrtcolor,
                      fontFamily: 'SamRegular',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Aller",
                        style: TextStyle(
                            fontFamily: 'SamRegular',
                            color: fisrtcolor
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: fisrtcolor,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          getdivider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Paiement",
                style: TextStyle(
                   // color: secondcolor,
                    fontSize: 15,
                    letterSpacing: 1.0,
                    fontFamily: 'SamRegular'
                ),
              ),
              SizedBox(height: 5.0,),
              Text('Avance de 5O% via operateur mobile et versement final au retrait de l\'article',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    letterSpacing: 1.5,
                    fontFamily: 'SamBold'
                ),),
            ],
          ),
          getdivider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Point de relais",
                style: TextStyle(
                  // color: secondcolor,
                    fontSize: 15,
                    letterSpacing: 1.0,
                    fontFamily: 'SamRegular'
                ),
              ),
              SizedBox(height: 5.0,),
              Row(
                children: [
                  Icon( Icons.location_on, color: fisrtcolor,),
                  Text('Douala, village, entrée lycée',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        letterSpacing: 1.5,
                        fontFamily: 'SamBold'
                    ),),
                ],
              ),
            ],
          ),
          getdivider(),
          Text(
            "Articles similaires",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'SamBold',
                letterSpacing: 1.0
            ),
          ),
        ],
      ),
    );
  }

}
