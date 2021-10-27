import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/compte.dart';

class CompteService{
  FirebaseFirestore _db = FirebaseFirestore.instance;


  //Get Users
  Stream<List<Compte>> getComptes(){
    return _db
        .collection('Comptes')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Compte.fromJson(doc.data()))
        .toList());
  }

  Stream<List<Compte>> getAbonnements(String id){
    return _db
        .collection('Comptes')
        .where('compteAbonnement', arrayContains: id)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Compte.fromJson(doc.data()))
        .toList());
  }

  Stream<List<Compte>> getAbonnes(String id){
    return _db
        .collection('Comptes')
        .where('compteAbonnes', arrayContains: id)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Compte.fromJson(doc.data()))
        .toList());
  }

  Future getCurrentCompte(String id) async{
    try{
      final data = await _db.collection('Comptes').doc(id).get();
      final user = Compte.fromJson(data.data());
      return user;
    }catch(e){
return false;
    }
  }

  Future<String> uploadImage(File file, {String path}) async{
    var time = DateTime.now().toString();
    String image = '/image' + "_" + time;
    try{

    }catch(e){

    }
  }

  // Stream<Compte>  getCompte(String id){
  //   return _db
  //       .collection('Comptes')
  //       .doc(id)
  //       .snapshots()
  //       .map((doc) => Compte.fromJson(doc.data()));
  // }


  //Upsert
  Future<void> setCompte(Compte compte){
    var options = SetOptions(merge:true);

    return _db
        .collection('Comptes')
        .doc(compte.compteId)
        .set(compte.toMap(),options);
  }

  //Delete
  Future<void> removeCompte(String compteid){
    return _db
        .collection('Comptes')
        .doc(compteid)
        .delete();
  }
}