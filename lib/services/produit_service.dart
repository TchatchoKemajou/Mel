
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/produit.dart';

class ProduitService{
  FirebaseFirestore _db = FirebaseFirestore.instance;


  //Get Article
  Stream<List<Produit>> getArticles(String id, String adresse){
    return _db
        .collection('MelProduits')
        .where('productLocation', isEqualTo: adresse)
        //.where('productSeller', isNotEqualTo: id)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Produit.fromJson(doc.data()))
        .toList());
  }

  Stream<List<Produit>> getArticlesSimilaires(String categorie, String id){
    return _db
        .collection('MelProduits')
        .where('productCategorie', isEqualTo: categorie)
        .where('productId', isNotEqualTo: id)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Produit.fromJson(doc.data()))
        .toList());
  }

  Future getCurrentArticle(String id) async{
    try{
      final data = await _db.collection('MelProduits').doc(id).get();
      final artiicle = Produit.fromJson(data.data());
      return artiicle;
    }catch(e){
      return false;
    }
  }

  Stream<List<Produit>> getArticlesCatalogue(String categorie, String collection){
    return _db
        .collection('MelProduits')
        .where('productCategorie', isEqualTo: categorie)
        .where('productCollection', isEqualTo: collection)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Produit.fromJson(doc.data()))
        .toList());
  }

  Stream<List<Produit>> getArticlesCollection(String collection){
    return _db
        .collection('MelProduits')
        .where('productCollection', isEqualTo: collection)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Produit.fromJson(doc.data()))
        .toList());
  }

  Stream<List<Produit>> getArticlesresultat(String categorie){
    return _db
        .collection('MelProduits')
        .where('productCategorie', isEqualTo: categorie)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Produit.fromJson(doc.data()))
        .toList());
  }

  Stream<List<Produit>> getArticlespanier(String id){
    return _db
        .collection('MelProduits')
        .where('productPanier', arrayContains: id)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Produit.fromJson(doc.data()))
        .toList());
  }

  Stream<List<Produit>> getArticleWishlist(String id){
    return _db
        .collection('MelProduits')
        .where('productFavories', arrayContains: id)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Produit.fromJson(doc.data()))
        .toList());
  }

  Stream<List<Produit>> getArticleposter(String id){
    return _db
        .collection('MelProduits')
        .where('productSeller', isEqualTo: id)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Produit.fromJson(doc.data()))
        .toList());
  }

  // set Article
  Future<void> setArticle(Produit article){
    var options = SetOptions(merge:true);

    return _db
        .collection('MelProduits')
        .doc(article.productId)
        .set(article.toMap(),options);
  }


  //Delete Article
  Future<void> removeArticle(String articleId){
    return _db
        .collection('MelProduits')
        .doc(articleId)
        .delete();
  }
}