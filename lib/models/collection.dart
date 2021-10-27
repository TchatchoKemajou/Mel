import 'package:flutter/material.dart';

class Collection {
  final String collectionId;
  final String collectionType;
  final String collectionImage;

  Collection({@required this.collectionId, this.collectionType, this.collectionImage});

  factory Collection.fromJson(Map<String, dynamic> json){
    return Collection(
        collectionId: json['collectionId'] == null ? 0 : json['collectionId'],
        collectionType: json['collectionType'] == null ? 0 : json['collectionType'],
      collectionImage: json['collectionImage'] == null ? 0 : json['collectionImage'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'collectionId':collectionId,
      'collectionType':collectionType,
      'collectionImage':collectionImage,
    };
  }
}