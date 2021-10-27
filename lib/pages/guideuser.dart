import 'package:flutter/material.dart';
import 'package:flutter_app/constantes.dart';

class GuideUser extends StatefulWidget {
  //const GuideUser({Key? key}) : super(key: key);

  @override
  _GuideUserState createState() => _GuideUserState();
}

class _GuideUserState extends State<GuideUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Guide d'utilisation",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'SamBold',
              letterSpacing: 1.0,
              fontSize: 18
          ),
        ),
        elevation: .0,
        foregroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // elevation: 3.0,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shop,
                        color: fisrtcolor,
                        size: 24,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Boutique",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SamBold',
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "La création d'un compte MEL vous donne la possiblité de vendre et/ou d'acheter sur la platform. Cliquer sur le bouton + à la page principale pour vendre un article, et votre boutique sera automatiquement crée",
                    style: TextStyle(
                      //color: Colors.black,
                      fontFamily: 'SamRegular',
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
           // elevation: 3.0,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                        size: 24,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Wishlist",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SamBold',
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Ajouter des articles dans votre liste de souhait, et retrouvés les dans l'option WishList sur la page principale",
                    style: TextStyle(
                      //color: Colors.black,
                      fontFamily: 'SamRegular',
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // elevation: 3.0,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: secondcolor,
                        size: 24,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Panier",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SamBold',
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Ajoutez des articles dans votre panier et prévisualisez vos achats, le panier vous permet d'avoir le contrôle sur vos commandes et de décider quand vous voulez acheter. il est disponible dans le menu de l'application",
                    style: TextStyle(
                      //color: Colors.black,
                      fontFamily: 'SamRegular',
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // elevation: 3.0,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.flash_on,
                        color: color2,
                        size: 24,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Ventes flash",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SamBold',
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Achetez des articles instantannément durant une courte période de vente au enchers. disponible sur la page principale",
                    style: TextStyle(
                      //color: Colors.black,
                      fontFamily: 'SamRegular',
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // elevation: 3.0,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        color: color1,
                        size: 24,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Coupons",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SamBold',
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Les coupons peuvent être utilisés comme monnaie lors de vos achats. vous pouvez obtenir des coupons en fonction de vos achats ou de vos abonnés sur la plateform",
                    style: TextStyle(
                      //color: Colors.black,
                      fontFamily: 'SamRegular',
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
