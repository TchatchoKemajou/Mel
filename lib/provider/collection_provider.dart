import 'package:flutter/material.dart';
import 'package:flutter_app/models/collection.dart';
import 'package:flutter_app/services/collection_service.dart';
import 'package:uuid/uuid.dart';

class CollectionProvider extends ChangeNotifier {

  final collectionservice = CollectionService();
  var uuid = Uuid();
  String _collectionId;
  String _collectionType;
  String _collectionImage;

  String get collectionId => _collectionId;
  String get collectionType => _collectionType;
  String get collectionImage => _collectionImage;
  Stream<List<Collection>> get collections => collectionservice.getcollection();

  set collectionId(String value) {
    _collectionId = value;
  }

  set collectionType(String value) {
    _collectionType = value;
  }

  set collectionImage(String value) {
    _collectionImage = value;
  }
}