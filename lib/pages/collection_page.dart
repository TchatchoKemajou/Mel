import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constantes.dart';
import 'package:flutter_app/models/collection.dart';
import 'package:flutter_app/pages/resultat.dart';
import 'package:flutter_app/provider/collection_provider.dart';
import 'package:provider/provider.dart';

class CollectionPage extends StatefulWidget {
  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  Widget build(BuildContext context) {
    final collectionprovirder = Provider.of<CollectionProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Collection",
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
      body: Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: StreamBuilder<List<Collection>>(
          stream: collectionprovirder.collections,
          builder: (context, snapshot) {
            return snapshot.data != null
              ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return snapshot.hasData
                    ? InkWell(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                        return ResultPage(collection: snapshot.data[index].collectionType);
                      }));
                    },
                      child: Container(
                      margin: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 15.0),
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: snapshot.data[index].collectionImage,
                            placeholder: (context, url) => Image(
                              image: AssetImage('assets/images/cadeau.png'),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 15,
                            left: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                             // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  snapshot.data[index].collectionType,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'SamBold',
                                  ),
                                ),
                                Text(
                                  "Consultez des millions d'articles",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'SamRegular',
                                  ),
                                ),
                                Text(
                                  "jusqu'a 20% de reduction",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'SamRegular',
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                  ),
                    )
                    : null
                  ;
                }
            )
              : Container()
            ;
          }
        ),
      ),
    );
  }
}
