import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/produit.dart';
import 'package:flutter_app/services/produit_service.dart';
import 'package:uuid/uuid.dart';

class ProduitProvider with ChangeNotifier{
  String userId = FirebaseAuth.instance.currentUser.uid;
  var uuid = Uuid();
  final produitservice = ProduitService();

  String _productId;
  String _productReference;
  int _productPrice;
  int _productSellerPrice;
  int _productMinimalPrice;
  int _productRemise = 0;
  String _productLocation;
  bool _productNegociable;
  List<String> _productListNegocian;
  String _productCategorie = "Chaussures";
  String _productCollection = "Hommes";
  Map<String, dynamic> _productCaracteristique = Map();
  List<String> _productImage;
  List<String> _productFavories;
  List<String> _productPanier;
  String _productEtat;
  String _productDescription;
  int _productNbVues;
  int _productNote;
  String _productRelais;
  String _productSeller;
  DateTime _productCreateDate;


  List<String> get productListNegocian => _productListNegocian;

  set ChangeProductListNegocian(List<String> value) {
    _productListNegocian = value;
    notifyListeners();
  }

  int get productRemise => _productRemise;

  set ChangeProductRemise(int value) {
    _productRemise = value;
    notifyListeners();
  }

  String get productLocation => _productLocation;

  set ChangeProductLocation(String value) {
    _productLocation = value;
    notifyListeners();
  }

  int get productSellerPrice => _productSellerPrice;

  set changeProductSellerPrice(int value) {
    _productSellerPrice = value;
    notifyListeners();
  }

  String get productId => _productId;

  set changeProductId(String value) {
    _productId = value;
    notifyListeners();
  }

  String get productReference => _productReference;

  set changeProductReference(String value) {
    _productReference = value;
    notifyListeners();
  }

  int get productPrice => _productPrice;

  set changeProductPrice(int value) {
    _productPrice = value;
    notifyListeners();
  }

  int get productMinimalPrice => _productMinimalPrice;

  set changeProductMinimalPrice(int value) {
    _productMinimalPrice = value;
    notifyListeners();
  }

  bool get productNegociable => _productNegociable;

  set changeProductNegociable(bool value) {
    _productNegociable = value;
    notifyListeners();
  }

  String get productCategorie => _productCategorie;

  set changeProductCategorie(String value) {
    _productCategorie = value;
    notifyListeners();
  }

  String get productCollection => _productCollection;

  set changeProductCollection(String value) {
    _productCollection = value;
    notifyListeners();
  }

  Map<String, dynamic> get productCaracteristique => _productCaracteristique;

  set changeProductCaracteristique(Map<String, dynamic> value) {
    _productCaracteristique = value;
    notifyListeners();
  }

  DateTime get productCreateDate => _productCreateDate;

  set changeProductCreateDate(DateTime value) {
    _productCreateDate = value;
    notifyListeners();
  }

  String get productSeller => _productSeller;

  set changeProductSeller(String value) {
    _productSeller = value;
    notifyListeners();
  }

  String get productRelais => _productRelais;

  set changeProductRelais(String value) {
    _productRelais = value;
    notifyListeners();
  }

  int get productNote => _productNote;

  set changeProductNote(int value) {
    _productNote = value;
    notifyListeners();
  }

  int get productNbVues => _productNbVues;

  set changeProductNbVues(int value) {
    _productNbVues = value;
    notifyListeners();
  }

  String get productDescription => _productDescription;

  set changeProductDescription(String value) {
    _productDescription = value;
    notifyListeners();
  }

  String get productEtat => _productEtat;

  set changeProductEtat(String value) {
    _productEtat = value;
    notifyListeners();
  }

  List<String> get productPanier => _productPanier;

  set changeProductPanier(List<String> value) {
    _productPanier = value;
    notifyListeners();
  }

  List<String> get productFavories => _productFavories;

  set changeProductFavories(List<String> value) {
    _productFavories = value;
    notifyListeners();
  }

  List<String> get productImage => _productImage;

  set changeProductImage(List<String> value) {
    _productImage = value;
    notifyListeners();
  }

  loadall(Produit article){
    if (article != null){
      _productId = article.productId;
      _productReference = article.productReference;
      _productPrice = article.productPrice;
      _productSellerPrice = article.productSellerPrice;
      _productMinimalPrice = article.productMinimalPrice;
      _productRemise = article.productRemise;
      _productLocation = article.productLocation;
      _productNegociable = article.productNegociable;
      _productListNegocian = article.productListNegocian;
      _productCollection = article.productCollection;
      _productCategorie = article.productCategorie;
      _productCaracteristique = article.productCaracteristique;
      _productImage = article.productImage;
      _productFavories = article.productFavories;
      _productPanier = article.productPanier;
      _productEtat = article.productEtat;
      _productDescription = article.productDescription;
      _productNbVues = article.productNbVues;
      _productNote = article.productNote;
      _productRelais = article.productRelais;
      _productSeller = article.productSeller;
      _productCreateDate = article.productCreateDate;
    } else {
      _productId = null;
      _productReference = null;
      _productPrice = null;
      _productMinimalPrice = null;
      // _articleCollection = null;
      // _articleCategorie = null;
      // _articleCaracteristique = null;
      _productImage = null;
      _productFavories = null;
      _productPanier = null;
      _productEtat = null;
      _productDescription = null;
      _productNbVues = null;
      _productNote = null;
      _productRelais = null;
      _productSeller = null;
    }
  }

  clearAll(){
    // _articleId = null;
    _productReference.isEmpty;
    _productPrice = null;
    _productCategorie.isEmpty;
    _productCaracteristique.clear();
    _productImage.clear();
    _productEtat.isEmpty;
    _productDescription.isEmpty;
  }

  Stream<List<Produit>>  articles(String id, String adresse)  =>  produitservice.getArticles(id, adresse);
  Stream<List<Produit>>  articlesSimilaire(String categorie, String id)  =>  produitservice.getArticlesSimilaires(categorie, id);
  Stream<List<Produit>>  articlesCatalogue(String categorie, String collection)  =>  produitservice.getArticlesCatalogue(categorie, collection);
  Stream<List<Produit>>  articlesresultat(String categorie)  =>  produitservice.getArticlesresultat(categorie);
  Stream<List<Produit>>  articlescolllection(String collection)  =>  produitservice.getArticlesCollection(collection);
  Stream<List<Produit>> get panier  =>  produitservice.getArticlespanier(userId);
  Stream<List<Produit>> get wishlist  =>  produitservice.getArticleWishlist(userId);
  Stream<List<Produit>>  postes(String id)  =>  produitservice.getArticleposter(id);

  saveArticle(){
    if (_productId == null){
      //Add
      var newArticle = Produit( productId: uuid.v1(), productReference: _productReference, productPrice: _productPrice, productSellerPrice: _productSellerPrice, productMinimalPrice: _productMinimalPrice,
          productRemise: _productRemise, productLocation: _productLocation,
          productNegociable: _productNegociable, productListNegocian: _productListNegocian, productCollection: _productCollection, productCategorie: _productCategorie, productCaracteristique: _productCaracteristique,
          productImage: _productImage, productFavories: _productFavories, productPanier: _productPanier, productEtat: _productEtat, productDescription: _productDescription, productNbVues: _productNbVues, productNote: _productNote,
          productRelais: _productRelais, productSeller: userId, productCreateDate: DateTime.now());
      produitservice.setArticle(newArticle);
    }else{
      var updateArticle = Produit( productId: _productId, productReference: _productReference, productPrice: _productPrice, productSellerPrice: _productSellerPrice, productMinimalPrice: _productMinimalPrice,
          productRemise: _productRemise, productLocation: _productLocation,
          productNegociable: _productNegociable, productListNegocian: _productListNegocian, productCollection: _productCollection, productCategorie: _productCategorie, productCaracteristique: _productCaracteristique,
          productImage: _productImage, productFavories: _productFavories, productPanier: _productPanier, productEtat: _productEtat, productDescription: _productDescription, productNbVues: _productNbVues, productNote: _productNote,
          productRelais: _productRelais, productSeller: _productSeller, productCreateDate: _productCreateDate);
      produitservice.setArticle(updateArticle);
    }
  }

}