import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/collection.dart';

class CollectionService {
  FirebaseFirestore _db = FirebaseFirestore.instance;


  //Get Article
  Stream<List<Collection>> getcollection(){
    return _db
        .collection('collection')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Collection.fromJson(doc.data()))
        .toList());
  }

  // set Article
  Future<void> setcollection(Collection collection){
    var options = SetOptions(merge:true);

    return _db
        .collection('collection')
        .doc(collection.collectionId)
        .set(collection.toMap(),options);
  }

  //Delete Article
  Future<void> removecollection(String collectionid){
    return _db
        .collection('collection')
        .doc(collectionid)
        .delete();
  }
}