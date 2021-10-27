
import 'dart:async';
import 'dart:io' as io;

import 'package:chips_choice/chips_choice.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/constantes.dart';
import 'package:flutter_app/provider/locationservice.dart';
import 'package:flutter_app/provider/notification.dart';
import 'package:flutter_app/provider/produit_provider.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:toast/toast.dart';


class AddArticle extends StatefulWidget {
  AddArticle({Key key}) : super(key: key);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {

  final keyA = GlobalKey<FormState>();
  bool checking = false;
  List<io.File> images = [];
  List<PickedFile> files = [];
  List<String> imagesLink = [];
  List<firebase_storage.Reference> reflist = [];
  final picker = ImagePicker();
  //firebase_storage.Reference ref;
  io.File image;
  PickedFile file;
  String l = "nvjnhvnv";
  List<String> Collection = [];
  List<String> categorielist = [];
  List<String> osList = [];
  List<String> colorList = [];
  List<String> ramlist = [];
  List<String> Cpu = [];
  List<String> Stockage = [];
  List<String> pixelAvant = [];
  List<String> pixelArriere = [];
  Map<String, dynamic> caracteristiques = Map();
  final referenceController = TextEditingController();
  final priceController = TextEditingController();
  final etatController = TextEditingController();
  final descriptionController = TextEditingController();
  final marqueController = TextEditingController();
  final tailleController = TextEditingController();
  final minimalPriceController = TextEditingController();
  int tag = 0;
  bool isnegociable = false;
  bool isPositionCorrect = false;
  String userId = FirebaseAuth.instance.currentUser.uid;

  double spinner = 0;
  String collection;
  int oldlength;
  var subscription;
  bool internet;


  Placemark placemark;
  String place;


  void _handleRadioValueChange(int value) {

    setState(() {

      tag = value;


      switch (tag) {

        case 0:
          collection = Collection[0];
          break;

        case 1:
          collection = Collection[1];
          break;

        case 2:
          collection = Collection[2];
          break;

        case 3:
          collection = Collection[3];
          break;
      }

    });

  }

  Future<void> _downloadLink(firebase_storage.Reference ref) async {
    final link = await ref.getDownloadURL();
    imagesLink.add(link);
    print(link);
    await Clipboard.setData(ClipboardData(
      text: link,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Success!\n Copied download URL to Clipboard!',
        ),
      ),
    );
  }

  Future<firebase_storage.UploadTask> uploadFile(PickedFile file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }

    firebase_storage.UploadTask uploadTask;
    String link;
    var time = DateTime.now().toString();
    String image = '/image' + "_" + time;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('MelImage')
        .child(image);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/png',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(io.File(file.path), metadata);
    }
    // setState(() {
    //   imagesLink.add(link);
    // });
    return Future.value(uploadTask);
  }
  checkconnectivity() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    subscription = Connectivity().onConnectivityChanged.listen((connectivityResult) async {
      // Got a new connectivity status!
      if (connectivityResult == ConnectivityResult.none) {
        // I am connected to a mobile network.
        Toast.show("echec de connexion", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        if (await DataConnectionChecker().hasConnection) {
          // Wifi detected & internet connection confirmed.
          setState(() {
            internet = true;
          });
        } else {
          // Wifi detected but no internet connection found.
          setState(() {
            internet = false;
          });
        }
        Toast.show("connexion wifi", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }else if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a wifi network.
        if (await DataConnectionChecker().hasConnection) {
          // Mobile data detected & internet connection confirmed.
          setState(() {
            internet = true;
          });
        } else {
          // Mobile data detected but no internet connection found.
          setState(() {
            internet = false;
          });
        }
        Toast.show("connexion mobile", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    referenceController.dispose();
    priceController.dispose();
    etatController.dispose();
    descriptionController.dispose();
    marqueController.dispose();
    tailleController.dispose();
    minimalPriceController.dispose();
    super.dispose();
    subscription.cancel();
  }

  int PrixDeVente(int prix){
    double benefice;
    int    prixvente;
    if(prix > 1 && prix <= 300000 ){
      benefice = (prix * 3 / 100) ;
      prixvente = prix +  benefice.toInt();
    }
    if(prix > 300000 && prix < 500000){
      benefice = (prix * 2.5 / 100);
      prixvente = prix + benefice.toInt();
    }
    if(prix >= 500000 ){
      benefice = (prix * 2 / 100);
      prixvente = prix + benefice.toInt();
    }
    return prixvente;
  }

  @override
  void initState() {
    Provider.of<NotificationService>(context, listen: false).initialize();
   // final produitprovider = Provider.of<ArticleProvider>(context, listen: false);
    final produitprovider =  Provider.of<ProduitProvider>(context, listen: false);
    categorielist = ['Chaussures', 'Véhicules', 'Electro-Menager', 'Sacs', 'Vêtements', 'Téléphones', 'Ordinateurs', 'Cosmétiques', 'Télévision'];
    Collection = ['Hommes', 'Femmes', 'Enfants', 'Autres'];
    osList = ['Windows', 'Mac OS', 'Linux', 'Autres'];
    ramlist = ['1GB', '2GB', '4GB', '6GB', '8GB', '10GB', '12GB', '14GB', '16GB', '32GB', '64GB'];
    Stockage = ['50GB', '80GB', '120GB', '250GB', '500GB', '750GB', '1T'];
    Cpu = ['1GHz', '1.70GHz', '1.80GHz', '1+GHz', '2GHz', '2.50GHz', '2.54GHz', '2+GHz', '3+GHz'];
    pixelArriere = ['8M', '10M', '12M', '16M', '32M', '48M', '64M'];
    pixelAvant = ['8M', '10M', '12M', '16M', '32M', '48M', '64M'];
    colorList = ['Noir', 'Blanc', 'Bleu', 'Rouge'];
    caracteristiques["couleur"] = "Noir";
    caracteristiques["taille"] = 0.0;
    caracteristiques["stockage"] = "50GB";
    caracteristiques["ram"] = "1GB";
    caracteristiques["os"] = "Windows";
    caracteristiques["cpu"] = "1GHz";
    caracteristiques["pixelavant"] = "8M";
    caracteristiques['pixelarrier'] = "8M";
    produitprovider.changeProductCaracteristique = caracteristiques;
    produitprovider.changeProductId = null;
    // TODO: implement initState
    super.initState();
    checkconnectivity();
  }

  void openDialogprofil() {
    final produitprovider =  Provider.of<ProduitProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          // title: Text(title),
          content: Text(place,),
          actions: [
            FlatButton(
              child: Text('Annuler'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('Enregistrer'),
              onPressed: () {
                produitprovider.ChangeProductLocation = placemark.locality;
                Navigator.of(context).pop();
                setState(() {
                  isPositionCorrect = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationservice = Provider.of<LocationService>(context);
    locationservice.getCurrentAdress();
    if(locationservice.place != null){
      setState(() {
        placemark = locationservice.place;
        place = locationservice.place.locality;
      });
    }else place = "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fisrtcolor,
        title: Text(
          "Ajouter un article",
          style: TextStyle(
            color: Colors.white,
          ),
        ) ,
        elevation: 0.0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
        children: [
          Text(
            "tous les champs sont obigatoires, vous êtes prier de valider les images avant de publier l'article",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'SamBoldItalic'
            ),
          ),
          SizedBox(height: 10,),
          formulaire(),
        ],

      ),
    );
  }
  formulaire(){
    final produitprovider =  Provider.of<ProduitProvider>(context);
    //final produitprovider = Provider.of<ArticleProvider>(context);
    final notifyme = Provider.of<NotificationService>(context);
    return Form(
      key: keyA
      ,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          selectImage(),
          selectCollection(),
          SizedBox(height: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nom",
                style: TextStyle(
                  color: secondcolor,
                  fontFamily: 'SamBold',
                  fontWeight: FontWeight.w500,
                  // fontSize: 12
                ),
              ),
              SizedBox(height: 5.0,),
              Container(
                // width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.only(left:10.0,),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey,)
                ),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: referenceController,
                  onChanged: (e) => produitprovider.changeProductReference = e,
                  validator: (e) => e.isEmpty ? " Reference obligatoire":null,
                  autocorrect: true,
                  style: TextStyle(
                    // fontFamily: 'rowregular'
                  ),
                  decoration: InputDecoration(
                    hintText: "Ex: Air Max pro 2021",
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Catégories",
                style: TextStyle(
                  color: secondcolor,
                  fontFamily: 'SamBold',
                  fontWeight: FontWeight.w500,
                  // fontSize: 12
                ),
              ),
              SizedBox(height: 5.0,),
              Container(
                // width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.only(left:10.0, right: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey,)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton<String>(
                        value: produitprovider.productCategorie,
                        icon: Icon(
                          Icons.arrow_drop_down,
                        ),
                        iconSize: 24,
                        //elevation: 16,
                        underline: Container(
                          height: 1,
                          color: Colors.white,
                        ),
                        style: TextStyle(
                            color: Colors.black
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            produitprovider.changeProductCategorie = newValue;
                          });
                        },
                        items: categorielist
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  )
              )
            ],
          ),
          SizedBox(height: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Caratéristiques",
                style: TextStyle(
                  color: secondcolor,
                  fontFamily: 'SamBold',
                  fontWeight: FontWeight.w500,
                  // fontSize: 12
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                 padding: EdgeInsets.only(left:5.0, top: 5.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey,)
                ),
                child: Wrap(
                  spacing: 5.0,
                  children: [
                    Column(
                      children: [
                        Text(
                          "taille",
                          style: TextStyle(
                              color: secondcolor,
                              fontFamily: 'SamBold',
                              fontSize: 12
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        SpinnerInput(
                          minValue: 0,
                          maxValue: 200,
                          plusButton: SpinnerButtonStyle(elevation: 0, color: Colors.blue, height: 25.0, width: 25.0),
                          minusButton: SpinnerButtonStyle(elevation: 0, color: Colors.red, height: 25.0, width: 25.0),
                          middleNumberWidth: 70,
                          middleNumberPadding: EdgeInsets.all(0),
                          middleNumberStyle: TextStyle(fontSize: 14),
                          spinnerValue: produitprovider.productCaracteristique["taille"],
                          onChange: (e) {
                            setState(() {
                              caracteristiques.update("taille", (value) => e);
                              produitprovider.changeProductCaracteristique = caracteristiques;
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Couleur",
                          style: TextStyle(
                              color: secondcolor,
                              fontFamily: 'SamBold',
                              fontSize: 12
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15.0),
                            child: DropdownButton<String>(
                              value: produitprovider.productCaracteristique["couleur"],
                              icon: Icon(
                                Icons.arrow_drop_down,
                              ),
                              iconSize: 24,
                              //elevation: 16,
                              underline: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                              style: TextStyle(
                                  color: Colors.black
                              ),
                              onChanged: (String e) {
                                setState(() {
                                  caracteristiques.update("couleur", (value) => e);
                                  produitprovider.changeProductCaracteristique = caracteristiques;
                                });
                              },
                              items: colorList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                        ),
                      ],
                    ),
                    produitprovider.productCategorie == "Ordinateurs" || produitprovider.productCategorie == "Téléphones" ? Column(
                      children: [
                        Text(
                          "Ram",
                          style: TextStyle(
                              color: secondcolor,
                              fontFamily: 'SamBold',
                              fontSize: 12
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15.0),
                            child: DropdownButton<String>(
                              value: produitprovider.productCaracteristique["ram"],
                              icon: Icon(
                                Icons.arrow_drop_down,
                              ),
                              iconSize: 24,
                              //elevation: 16,
                              underline: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                              style: TextStyle(
                                  color: Colors.black
                              ),
                              onChanged: (String e) {
                                setState(() {
                                  caracteristiques.update("ram", (value) => e);
                                  produitprovider.changeProductCaracteristique = caracteristiques;
                                });
                              },
                              items: ramlist
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                        ),
                      ],
                    ) :SizedBox(),
                    produitprovider.productCategorie == "Ordinateurs" ? Column(
                      children: [
                        Text(
                          "Système d'explotattion",
                          style: TextStyle(
                              color: secondcolor,
                              fontFamily: 'SamBold',
                              fontSize: 12
                          ),
                        ),
                        Container(
                          // margin: EdgeInsets.only(left: 5.0),
                            child: DropdownButton<String>(
                              value: produitprovider.productCaracteristique["os"],
                              icon: Icon(
                                Icons.arrow_drop_down,
                              ),
                              iconSize: 24,
                              //elevation: 16,
                              underline: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                              style: TextStyle(
                                  color: Colors.black
                              ),
                              onChanged: (String e) {
                                setState(() {
                                  caracteristiques.update("os", (value) => e);
                                  produitprovider.changeProductCaracteristique = caracteristiques;
                                });
                              },
                              items: osList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                        ),
                      ],
                    ) : SizedBox(),
                    produitprovider.productCategorie == "Ordinateurs" || produitprovider.productCategorie == "Téléphones" ? Column(
                      children: [
                        Text(
                          "Stockage",
                          style: TextStyle(
                              color: secondcolor,
                              fontFamily: 'SamBold',
                              fontSize: 12
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15.0),
                            child: DropdownButton<String>(
                              value: produitprovider.productCaracteristique["stockage"],
                              icon: Icon(
                                Icons.arrow_drop_down,
                              ),
                              iconSize: 24,
                              //elevation: 16,
                              underline: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                              style: TextStyle(
                                  color: Colors.black
                              ),
                              onChanged: (String e) {
                                setState(() {
                                  caracteristiques.update("stockage", (value) => e);
                                  produitprovider.changeProductCaracteristique = caracteristiques;
                                });
                              },
                              items: Stockage
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                        ),
                      ],
                    ) : SizedBox(),
                    produitprovider.productCategorie == "Téléphones" ? Column(
                      children: [
                        Text(
                          "C avant",
                          style: TextStyle(
                              color: secondcolor,
                              fontFamily: 'SamBold',
                              fontSize: 12
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15.0),
                            child: DropdownButton<String>(
                              value: produitprovider.productCaracteristique['pixelavant'],
                              icon: Icon(
                                Icons.arrow_drop_down,
                              ),
                              iconSize: 24,
                              //elevation: 16,
                              underline: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                              style: TextStyle(
                                  color: Colors.black
                              ),
                              onChanged: (String e) {
                                setState(() {
                                  caracteristiques.update("pixelavant", (value) => e);
                                  produitprovider.changeProductCaracteristique = caracteristiques;
                                });
                              },
                              items: pixelAvant
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                        ),
                      ],
                    ) : SizedBox(),
                    produitprovider.productCategorie == "Téléphones" ? Column(
                      children: [
                        Text(
                          "C arrière",
                          style: TextStyle(
                              color: secondcolor,
                              fontFamily: 'SamBold',
                              fontSize: 12
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15.0),
                            child: DropdownButton<String>(
                              value: produitprovider.productCaracteristique["pixelarrier"],
                              icon: Icon(
                                Icons.arrow_drop_down,
                              ),
                              iconSize: 24,
                              //elevation: 16,
                              underline: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                              style: TextStyle(
                                  color: Colors.black
                              ),
                              onChanged: (String e) {
                                setState(() {
                                  caracteristiques.update("pixelarrier", (value) => e);
                                  produitprovider.changeProductCaracteristique = caracteristiques;
                                });
                              },
                              items: pixelArriere
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                        ),
                      ],
                    ) : SizedBox(),
                    produitprovider.productCategorie == "Ordinateurs" || produitprovider.productCategorie == "Téléphones" ? Column(
                      children: [
                        Text(
                          "CPU(GHz)",
                          style: TextStyle(
                              color: secondcolor,
                              fontFamily: 'SamBold',
                              fontSize: 12
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15.0),
                            child: DropdownButton<String>(
                              value: produitprovider.productCaracteristique["cpu"],
                              icon: Icon(
                                Icons.arrow_drop_down,
                              ),
                              iconSize: 24,
                              //elevation: 16,
                              underline: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                              style: TextStyle(
                                  color: Colors.black
                              ),
                              onChanged: (String e) {
                                setState(() {
                                  caracteristiques.update("cpu", (value) => e);
                                  produitprovider.changeProductCaracteristique = caracteristiques;
                                });
                              },
                              items: Cpu
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                        ),
                      ],
                    ) : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Prix",
                    style: TextStyle(
                      color: secondcolor,
                      fontFamily: 'SamBold',
                      fontWeight: FontWeight.w500,
                      // fontSize: 12
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isnegociable,
                        onChanged: (v){
                          setState(() {
                            isnegociable = v;
                            produitprovider.changeProductNegociable = isnegociable;
                          });
                        },
                      ),
                      Text(
                          "Négociable ?"
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5.0,),
              Container(
                // width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.only(left:10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey,)
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  onChanged: (e) => produitprovider.changeProductPrice = int.tryParse(e) ,
                  validator: (e) => double.tryParse(e) == null ? "prix invalide":null,
                  //autocorrect: true,
                  style: TextStyle(
                    // fontFamily: 'rowregular'
                  ),
                  decoration: InputDecoration(
                    hintText: "Ex: en FCFA",
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
          isnegociable == true ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Prix Minimal",
                style: TextStyle(
                  color: secondcolor,
                  fontFamily: 'SamBold',
                  fontWeight: FontWeight.w500,
                  // fontSize: 12
                ),
              ),
              SizedBox(height: 5.0,),
              Container(
                // width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.only(left:10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey,)
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: minimalPriceController,
                  onChanged: (e) {
                    produitprovider.changeProductMinimalPrice = int.tryParse(e);
                  },
                  validator: (e) => double.tryParse(e) == null ? "prix invalide":null,
                  //autocorrect: true,
                  style: TextStyle(
                    // fontFamily: 'rowregular'
                  ),
                  decoration: InputDecoration(
                    hintText: "Ex: en FCFA",
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ) : SizedBox(),
          SizedBox(height: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Etat",
                style: TextStyle(
                  color: secondcolor,
                  fontFamily: 'SamBold',
                  fontWeight: FontWeight.w500,
                  // fontSize: 12
                ),
              ),
              SizedBox(height: 5.0,),
              Container(
                // width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.only(left:10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey,)
                ),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: etatController,
                  onChanged: (e) => produitprovider.changeProductEtat = e,
                  validator: (e) => e.isEmpty ? " le champ état est  obligatoire":null,
                  //autocorrect: true,
                  style: TextStyle(
                    // fontFamily: 'rowregular'
                  ),
                  decoration: InputDecoration(
                    hintText: "Ex: décrivez l\'état de l'article (panne....)",
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description",
                style: TextStyle(
                  color: secondcolor,
                  fontFamily: 'SamBold',
                  fontWeight: FontWeight.w500,
                  // fontSize: 12
                ),
              ),
              SizedBox(height: 5.0,),
              Container(
                // width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.only(left:10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey,)
                ),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: descriptionController,
                  onChanged: (e) => produitprovider.changeProductDescription = e,
                  validator: (e) => e.isEmpty ? " Mot de passe obligatoire": e.length < 6 ? "Le mot de passe doit metre supérieur à 6 caractères":null,
                  //autocorrect: true,
                  style: TextStyle(
                    // fontFamily: 'rowregular'
                  ),
                  decoration: InputDecoration(
                    hintText: "Ex: donnez plus de détails sur l\'article",
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () async {
              if(keyA.currentState.validate() && files.length > 0){
                for(int i=0; i<files.length; i++){
                  firebase_storage.UploadTask task = await uploadFile(files[i]);
                  task.whenComplete(() async {
                    firebase_storage.Reference ref = task.snapshot.ref;
                    imagesLink.add(await ref.getDownloadURL());
                  });
                }

                produitprovider.changeProductImage = imagesLink;
                print(produitprovider.productImage.length);
                produitprovider.ChangeProductLocation = place;
                produitprovider.changeProductSellerPrice = PrixDeVente(produitprovider.productPrice);
                produitprovider.changeProductMinimalPrice = PrixDeVente(produitprovider.productMinimalPrice);
                produitprovider.changeProductCollection = collection;
                notifyme.ChangeNotificationContent = produitprovider.productId;
                notifyme.ChangeNotificationImage = produitprovider.productImage[0];
                notifyme.ChangeNotificationSender = userId;
                produitprovider.saveArticle();
                produitprovider.loadall(null);
                Toast.show("Article publié avec succès", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.TOP);
                notifyme.ChangeNotificationTitle = "Publication";
                notifyme.ChangeNotificationMessage = "l'article que vous venez d'ajouter sera supprimé dans deux semaines!";
                notifyme.instantNofitication(notifyme.notificationTitle, notifyme.notificationMessage);
                Navigator.of(context).pop();

              }else{
                Toast.show("selectionnez au moins 02 images et remplissez tous les champs ", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.TOP);
              }
              // notifyme.ChangeNotificationTitle = "publication";
              // notifyme.ChangeNotificationMessage = "l'article que vous venez d'ajouter sera supprimé dans deux semaines!";
              // notifyme.instantNofitication(notifyme.notificationTitle, notifyme.notificationMessage);
            },
            child: Text(
              "Publier",
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => fisrtcolor),
                padding: MaterialStateProperty.all(EdgeInsets.only(left: 80, right: 80)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      // side: BorderSide(color: Colors.red)
                    )
                )
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),

    );
  }

  selectCollection(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Collection",
          style: TextStyle(
            color: secondcolor,
            fontFamily: 'SamBold',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5.0,),
        Container(
          width: double.infinity,
          // padding: EdgeInsets.only(left:10.0,),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey,)
          ),
          child: ChipsChoice<int>.single(
            // mainAxisSize: MainAxisSize.min,
            choiceStyle: C2ChoiceStyle(
                color: background,
                labelPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                labelStyle: TextStyle(
                  fontFamily: 'MontBold',
                  fontSize: 12.0,
                  color: Colors.black,
                )
            ),
            choiceActiveStyle: C2ChoiceStyle(
                color: Colors.orangeAccent,
                labelPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                labelStyle: TextStyle(
                  fontFamily: 'MontBold',
                  fontSize: 12.0,
                  color: fisrtcolor,
                )
            ),
            spacing: 1.0,
            runSpacing: .0,
            wrapped: true,
            value: tag,
            onChanged: (val) => _handleRadioValueChange(val),
            choiceItems: C2Choice.listFrom<int, String>(
              source: Collection,
              value: (i, v) => i,
              label: (i, v) => v,
            ),
          ),
        )
      ],
    );
  }
  selectImage(){
    return Column(
      children: [
        SizedBox(height: 20.0,),
        Wrap(
          spacing: 5.0,
          children: [
            for(int i=0; i<images.length; i++)
              Container(
                decoration: BoxDecoration(
                 // color: Colors.black.withOpacity(.4),
                 // borderRadius: BorderRadius.circular(8.0),
                ),
                height: 80,
                width: 60,
                child: Stack(
                  children: [
                    Image.file(images[i], fit: BoxFit.cover,),
                    Align(
                      alignment: Alignment.center,
                      // right: -5,
                      // top: -5,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            images.removeAt(i);
                          });
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Icon(
                            Icons.remove, color: Colors.red, size: 20,),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            images.length <= 2 ? InkWell(
              onTap: () async {
                file = await picker.getImage(
                    source: ImageSource.gallery,
                    imageQuality: 30,
                    maxWidth: 150,
                 // maxHeight: 200,
                );
                // firebase_storage.UploadTask task = await uploadFile(picked);
                //  image = io.File(picked.path);
                setState(() {
                  files.add(file);
                  images.add(io.File(file.path));
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                  ),
                  height: 80,
                  width: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, color: Colors.white,),
                      Text("Select",
                        style: TextStyle(
                          fontFamily: 'SamBold',
                          color: Colors.white
                        ),
                      ),
                      Text("Picture",
                        style: TextStyle(
                            fontFamily: 'SamBold',
                            color: Colors.white
                        ),
                      )
                    ],
                  )
              ),
            ): SizedBox(),
          ],
        ),
        images.length < 2
            ? Text(
          "selectionnez au moins 02 images!!!",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'SamBold',
            color: Colors.red,
          ),
        )
            : SizedBox(),
      ],
    );
  }

}

