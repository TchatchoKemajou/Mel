
class Produit{
  final String productId;
  final String productReference;
  final int productPrice;
  final int productSellerPrice;
  final int productMinimalPrice;
  final int productRemise;
  final String productLocation;
  final bool productNegociable;
  final List<String> productListNegocian;
  final String productCategorie;
  final String productCollection;
  final Map<String, dynamic> productCaracteristique;
  final List<String> productImage;
  final List<String> productFavories;
  final List<String> productPanier;
  final String productEtat;
  final String productDescription;
  final int productNbVues;
  final int productNote;
  final String productRelais;
  final String productSeller;
  final DateTime productCreateDate;

  Produit({ this.productId, this.productReference, this.productPrice, this.productSellerPrice, this.productMinimalPrice, this.productRemise, this.productLocation,
    this.productListNegocian, this.productNegociable, this.productCollection, this.productCategorie, this.productCaracteristique, this.productImage,
    this.productFavories, this.productPanier, this.productEtat, this.productDescription, this.productNbVues, this.productNote, this.productRelais, this.productSeller, this.productCreateDate});

  factory Produit.fromJson(Map<String, dynamic> json){
    return Produit(
        productId: json['productId'] == null ? "" : json['productId'],
        productReference: json['productReference'] == null ? "" : json['productReference'],
        productPrice: json['productPrice'] == null ? 0 : json['productPrice'],
        productSellerPrice: json['productSellerPrice'] == null ? 0 : json['productSellerPrice'],
        productMinimalPrice: json['productMinimalPrice'] == null ? 0 : json['productMinimalPrice'],
        productRemise: json['productRemise'] == null ? 0 : json['productRemise'],
        productLocation: json['productLocation'] == null ? "" : json['productLocation'],
        productNegociable: json['productNegociable'] == null ? false : json['productNegociable'],
        productListNegocian: json['productListNegocian'] == null ? [] : json['productListNegocian'].map<String>((i) => i as String).toList(),
        productCollection: json['productCollection'] == null ? "" : json['productCollection'],
        productCategorie: json['productCategorie'] == null ? "" : json['productCategorie'],
        productCaracteristique: json['productCaracteristique'] == null ? [] : json['productCaracteristique'],
        productImage: json['productImage'] == null ? [] : json['productImage'].map<String>((i) => i as String).toList(),
    productFavories: json['productFavories'] == null ? [] : json['productFavories'].map<String>((i) => i as String).toList(),
    productPanier: json['productPanier'] == null ? [] : json['productPanier'].map<String>((i) => i as String).toList(),
    productEtat: json['productEtat'] == null ? "": json['productEtat'],
    productDescription: json['productDescription'] == null ? "" : json['productDescription'],
    productNbVues: json['productNbVues'] == null ? 0 : json['productNbVues'],
    productNote: json['productNote'] == null ? 0 : json['productNote'],
    productRelais: json['productRelais'] == null ? "" : json['productRelais'],
    productSeller: json['productSeller'] == null ? "" : json['productSeller'],
    productCreateDate: json['articleCreateDate'] == null ? DateTime.now() : json['articleCreateDate'].toDate()
    );
  }

  Map<String, dynamic> toMap(){
    return {
      // 'articleId' : articleId,
      'productId' : productId,
      'productReference' : productReference,
      'productPrice' : productPrice,
      'productSellerPrice' : productSellerPrice,
      'productMinimalPrice' : productMinimalPrice,
      'productRemise' : productRemise,
      'productLocation' : productLocation,
      'productNegociable' : productNegociable,
      'productListNegocian' : productListNegocian,
      'productCollection' : productCollection,
      'productCategorie' : productCategorie,
      'productCaracteristique' : productCaracteristique,
      'productImage' : productImage,
      'productFavories' : productFavories,
      'productPanier' : productPanier,
      'productEtat' : productEtat,
      'productDescription' : productDescription,
      'productNbVues' : productNbVues,
      'productNote' : productNote,
      'productRelais' : productRelais,
      'productSeller' : productSeller,
      'articleCreateDate' : productCreateDate
    };
  }
}