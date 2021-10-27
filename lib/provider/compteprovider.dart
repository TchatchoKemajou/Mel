import 'package:flutter/material.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/services/compteservice.dart';
import 'package:uuid/uuid.dart';

class CompteProvider with ChangeNotifier{
  final compteService = CompteService();

  String _compteId;
  String _compteName;
  String _compteEmail;
  String _comptePassword;
  String _compteProfil;
  String _comptePhone;
  Map<String, dynamic> _compteAddress = Map();
  String _compteType = "Standard";
  int _compteFacture = 0;
  List<String> _compteAbonnes = [];
  List<String> _compteAbonnement = [];
  int _compteWalter;
  String _comptePaiementMode;
  DateTime _compteCreateDate = DateTime.now();
  var uuid = Uuid();

  Stream<List<Compte>>  mesabonnements(String id)  =>  compteService.getAbonnements(id);
  Stream<List<Compte>> mesabonnes(String id) => compteService.getAbonnes(id);


  int get compteFacture => _compteFacture;

  set changeCompteFacture(int value) {
    _compteFacture = value;
    notifyListeners();
  }

  String get compteId => _compteId;

  set changeCompteId(String value) {
    _compteId = value;
    notifyListeners();
  }

  String get compteName => _compteName;

  set changeCompteName(String value) {
    _compteName = value;
    notifyListeners();
  }

  String get compteEmail => _compteEmail;

  set changeCompteEmail(String value) {
    _compteEmail = value;
    notifyListeners();
  }

  String get comptePassword => _comptePassword;

  set changeComptePassword(String value) {
    _comptePassword = value;
    notifyListeners();
  }

  String get compteProfil => _compteProfil;

  set changeCompteProfil(String value) {
    _compteProfil = value;
    notifyListeners();
  }

  String get comptePhone => _comptePhone;

  set changeComptePhone(String value) {
    _comptePhone = value;
    notifyListeners();
  }

  Map<String, dynamic> get compteAddress => _compteAddress;

  set changeCompteAddress(Map<String, dynamic> value) {
    _compteAddress = value;
    notifyListeners();
  }

  String get compteType => _compteType;

  set changeCompteType(String value) {
    _compteType = value;
    notifyListeners();
  }

  List<String> get compteAbonnes => _compteAbonnes;

  set changeCompteAbonnes(List<String> value) {
    _compteAbonnes = value;
    notifyListeners();
  }

  List<String> get compteAbonnement => _compteAbonnement;

  set changeCompteAbonnement(List<String> value) {
    _compteAbonnement = value;
    notifyListeners();
  }

  int get compteWalter => _compteWalter;

  set changeCompteWalter(int value) {
    _compteWalter = value;
    notifyListeners();
  }

  String get comptePaiementMode => _comptePaiementMode;

  set changeComptePaiementMode(String value) {
    _comptePaiementMode = value;
    notifyListeners();
  }

  DateTime get compteCreateDate => _compteCreateDate;

  set changeCompteCreateDate(DateTime value) {
    _compteCreateDate = value;
    notifyListeners();
  }
  loadAll(Compte compte){
    if (compte != null){
      _compteId = compte.compteId;
      _compteName = compte.compteName;
      _compteEmail = compte.compteEmail;
      _comptePassword = compte.comptePasssword;
      _compteProfil = compte.compteProfil;
      _comptePhone = compte.comptePhone;
      _compteType = compte.compteType;
      _compteFacture = compte.compteFacture;
      _compteAddress = compte.compteAddress;
      _compteAbonnes = compte.compteAbonnes;
      _compteAbonnement = compte.compteAbonnement;
      _compteWalter = compte.compteWalter;
      _comptePaiementMode = compte.comptePaiementMode;
      _compteCreateDate = compte.compteCreateDate;
    } else {
      // _date = DateTime.now();
      // _entry = null;
      // _entryId = null;
    }
  }

  saveCompte(String id){
    if (_compteId == null){
      //Add
      var newCompte = Compte(compteId: id, compteName: _compteName, compteEmail: _compteEmail, comptePasssword: _comptePassword, compteProfil: _compteProfil,
          comptePhone: _comptePhone, compteAddress: _compteAddress, compteType: _compteType, compteFacture: _compteFacture, compteAbonnes: _compteAbonnes, compteAbonnement: _compteAbonnement, compteWalter: _compteWalter, comptePaiementMode: _comptePaiementMode, compteCreateDate: _compteCreateDate);
      compteService.setCompte(newCompte);
    } else {
      //Edit
      var updateCompte = Compte(compteId: _compteId, compteName: _compteName, compteEmail: _compteEmail, comptePasssword: _comptePassword, compteProfil: _compteProfil,
          comptePhone: _comptePhone, compteAddress: _compteAddress, compteType: _compteType, compteFacture: _compteFacture, compteAbonnes: _compteAbonnes, compteAbonnement: _compteAbonnement, compteWalter: _compteWalter, comptePaiementMode: _comptePaiementMode, compteCreateDate: _compteCreateDate);
      compteService.setCompte(updateCompte);
    }
  }
}