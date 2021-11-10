import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/constantes.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/models/produit.dart';
import 'package:flutter_app/pages/mesabonnees.dart';
import 'package:flutter_app/pages/panier.dart';
import 'package:flutter_app/pages/settings.dart';
import 'package:flutter_app/provider/compteprovider.dart';
import 'package:flutter_app/provider/produit_provider.dart';
import 'package:flutter_app/services/compteservice.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'abonnement.dart';
import 'editprofil.dart';
import 'mesabonnements.dart';
import 'message.dart';
import 'dart:io' as io;


class Profil extends StatefulWidget {
  final String id;

  Profil({this.id});
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {

  String userId = FirebaseAuth.instance.currentUser.uid;
  Compte user, userconnect;
  double rating = 0.0;
  Timer time;
  firebase_storage.TaskSnapshot snapshot;
  firebase_storage.TaskState state;


  bool isUpload = true;
  String imagesLink;
  firebase_storage.Reference ref;
  final picker = ImagePicker();
  //firebase_storage.Reference ref;
  io.File image;
  PickedFile file;

  Future<void> getcurrentuse() async{
    // User user = await sauth.user;
    final result = await CompteService().getCurrentCompte(widget.id);
    setState(() {
      user = result;
    });
  }

  Future<void> getcurrentuser() async{
    // User user = await sauth.user;
    final result = await CompteService().getCurrentCompte(userId);
    setState(() {
      userconnect = result;
    });
  }

  Future<void> _downloadLink(firebase_storage.Reference ref) async {

    final link = await ref.getDownloadURL();

    setState(() {
      imagesLink = link;
    });
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
   // firebase_storage.TaskSnapshot taskSnapshot;
    String link;
    var time = DateTime.now().toString();
    String image = '/image' + "_" + time;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('MelProfil')
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

  Future getImage() async{
    var image =  await picker.getImage(
      source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 150);
    setState(() {
      file = image;
    });
  }

  Future<firebase_storage.Reference> uploadProfil(PickedFile file) async {
        firebase_storage.UploadTask task = await uploadFile(file);
        if (task.snapshot.state == firebase_storage.TaskState.success) {
          return task.snapshot.ref;
        }
        if(task.snapshot.state == firebase_storage.TaskState.error) {
          return null;
        }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final produitprovider =  Provider.of<ProduitProvider>(context);
    getcurrentuser();
    //final articleProvider = Provider.of<ArticleProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Profil",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'SamBold',
                letterSpacing: 1.0,
                fontSize: 18
            ),
          ),
          //centerTitle: true,
          elevation: 2.0,
          foregroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                        return EditProfil(user: user,);
                      }));
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.black54,
                      size: 24,
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications, color: Colors.black54, size: 24.0,),
                        onPressed: () {
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                            return MessagePage();
                          }));
                        },
                        // color: thirdcolor,
                      ),
                      Positioned(
                        right: 10.0,
                        top: 10.0,
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4.0)
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        body: StreamBuilder<List<Produit>>(
            stream: produitprovider.postes(widget.id),
            builder: (context, snapshot) {
              return CustomScrollView(
                slivers: [
                  SliverFixedExtentList(
                    delegate: SliverChildListDelegate([
                      getinfoperso(),
                    ]),
                    itemExtent: 331.0,
                  ),
                  snapshot.connectionState == ConnectionState.none || snapshot.data == null
                      ? SliverPadding(padding: EdgeInsets.all(10.0))
                      : SliverPadding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                      sliver: SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        staggeredTileBuilder: (int index) => StaggeredTile.count(1, index.isEven ? 1.5 : 1.5),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return snapshot.hasData
                              ? Card(
                                child: Container(
                            color: Colors.white,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data[index].productImage[0],
                                      placeholder: (context, url) => Image(
                                        image: AssetImage('assets/images/cadeau.png'),
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      width: 250,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                snapshot.data[index].productPrice.toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'SamBold',
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                "FCFA",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'SamBold',
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            snapshot.data[index].productReference,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'SamRegular',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                            ),
                          ),
                              )
                              : null;
                        },
                      )
                  )
                ],
              );
            }
        )
    );
  }
  Future<void> _refreshState() async {
    await Future.delayed(Duration(seconds: 5));
  }
  getinfoperso(){
    getcurrentuse();
    final compteProvider = Provider.of<CompteProvider>(context);
    compteProvider.loadAll(user);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only( left: 15, right: 15, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                 isUpload == false ? Center(
                    child: CircularProgressIndicator(),
                  ) : SizedBox(),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user != null ? NetworkImage(user.compteProfil,) : null,
                    child: user != null ? user.compteProfil == null || user.compteProfil == "" ? Center(child: Text(
                      user.compteName.toUpperCase().substring(0, 1),
                      style: TextStyle(
                          fontSize: 24
                      ),
                    ),) : SizedBox() : SizedBox(),
                  ),
          widget.id == userId
              ?Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey,
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                    ),
                    iconSize: 15.0,
                    color: Colors.white,
                    onPressed: () async{
                       file = await picker.getImage(
                         source: ImageSource.gallery,
                           imageQuality: 50,
                           maxWidth: 150);
                      openDialogprofil(imageSelect(io.File(file.path)));
                    },
                  ),
                ),
              )
              : SizedBox(),
                ],
              ),
              user != null
                  ? Text(
                user.compteName,
                style: TextStyle(
                   // color: Colors.white,
                    fontFamily: 'SamRegular',
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                ),
              )
                  : Text(""),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon( Icons.location_on, color: Colors.grey,),
                  user != null
                      ? Text(
                    "Cameroun, " + user.compteAddress["region"] + ", " + user.compteAddress["ville"],
                    style: TextStyle(
                       // color: Colors.white,
                        fontFamily: 'SamRegular',
                        fontWeight: FontWeight.w500,
                        fontSize: 15
                    ),
                  )
                      : Text(""),
                ],
              ),
              user != null
              ? widget.id == userId
              ? showmybutton()
                  : showvisiteurbutton()
              : SizedBox(),
            ],
          ),
        ),
        getButton(),
        SizedBox(height: 15.0,),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            widget.id == userId ? "Mes postes sur Mel" : "Articles postés",
            style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                letterSpacing: 1.0,
                fontFamily: 'SamBold'
            ),
          ),
        )
      ],
    );
  }
  showmybutton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            // notifyme.instantNofitication();
          },
          child: Row(
            children: [
              Icon( Icons.add_moderator, color: color2, size: 16,),
              Text(
                "  Mel Premuim",
                style: TextStyle(
                  color: color2,
                    fontSize: 14,
                    fontFamily: 'SamBold',
                    letterSpacing: 1.5
                ),
              ),
            ],
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
              padding: MaterialStateProperty.all(EdgeInsets.only(left: 10, right: 10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    // side: BorderSide(color: Colors.red)
                  )
              )
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
              return SettingsPage();
            }));
          },
          child: Row(
            children: [
              Icon( Icons.settings, color: fisrtcolor, size: 16,),
              Text(
                "  Réglages",
                style: TextStyle(
                    color: fisrtcolor,
                    fontSize: 14,
                    fontFamily: 'SamBold',
                    letterSpacing: 1.5
                ),
              ),
            ],
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
              padding: MaterialStateProperty.all(EdgeInsets.only(left: 10, right: 10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    // side: BorderSide(color: Colors.red)
                  )
              )
          ),
        ),
      ],
    );
  }

  void _openDialog(Widget content) {
    final compteProvider = Provider.of<CompteProvider>(context, listen: false);
    compteProvider.loadAll(user);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
         // title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('Annuler'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('Enregistrer'),
              onPressed: () {
                compteProvider.changeCompteWalter = (compteProvider.compteWalter + (rating as int));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  imageSelect(io.File fil){
    return Container(
      height: 200,
      width: double.infinity,
      child: Image.file(fil, fit: BoxFit.cover,),
    );
  }

  void openDialogprofil(Widget content) {
    final compteProvider = Provider.of<CompteProvider>(context, listen: false);
    compteProvider.loadAll(user);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          // title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('Annuler'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('Enregistrer'),
              onPressed: () async{
                firebase_storage.UploadTask task = await uploadFile(file);
                task.whenComplete(()  async{
                     imagesLink = await task.snapshot.ref.getDownloadURL();
                     compteProvider.changeCompteProfil = imagesLink;
                     compteProvider.saveCompte(userId);
                     Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }


  formEvaluation(){
    return Container(
      height: 130,
      margin: EdgeInsets.only(top: 20, left: 5, right: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Evaluation!",
            style: TextStyle(
              fontFamily: 'SamBold',
              fontSize: 16,
            ),
          ),
          SmoothStarRating(
              allowHalfRating: false,
              onRated: (v) {
                setState(() {
                  rating = v;
                });
              },
              starCount: 5,
              rating: 3,
              size: 40.0,
              isReadOnly: false,
              filledIconData: Icons.star,
              defaultIconData: Icons.star_border,
              color: Colors.green,
              borderColor: Colors.green,
              spacing:0.0
          ),
          Text(
            "Cette evaluation nous permettra d'ameliorer nos recommandations et vous proposez un contenu de qualité!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'SamREgular',
            ),
          )
        ],
      ),
    );
  }
  showvisiteurbutton(){
    final compteProvider = Provider.of<CompteProvider>(context);
    final compteProvider2 = Provider.of<CompteProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            if(user.compteAbonnes.contains(userId)){
              _openDialog(formEvaluation());
            }else{
              Toast.show( "Abonnez vous pour evaluer", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
            }
          },
          child: Row(
            children: [
              Icon( Icons.add_moderator, color: fisrtcolor, size: 16,),
              Text(
                "  Evaluer",
                style: TextStyle(
                    color: fisrtcolor,
                    fontSize: 14,
                    fontFamily: 'SamBold',
                    letterSpacing: 1.5
                ),
              ),
            ],
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
              padding: MaterialStateProperty.all(EdgeInsets.only(left: 10, right: 10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    // side: BorderSide(color: Colors.red)
                  )
              )
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if(user.compteAbonnes.contains(userId)){
              setState(() {
                user.compteAbonnes.remove(userId);
                userconnect.compteAbonnement.remove(user.compteId);
                compteProvider.loadAll(user);
                compteProvider2.loadAll(userconnect);
              });
              Toast.show( user.compteName + "ajouté", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
            }else{
              setState(() {
                user.compteAbonnes.add(userId);
                userconnect.compteAbonnement.add(user.compteId);
                compteProvider.loadAll(user);
                compteProvider2.loadAll(userconnect);
              });
            }
            compteProvider.saveCompte(compteProvider.compteId);
            compteProvider2.saveCompte(compteProvider2.compteId);
          },
          child: Row(
            children: [
              Icon( Icons.add_circle_outline, color: color2, size: 16,),
              Text(
                user.compteAbonnes.contains(userId) ? "Se désabonner" : " S'abonner",
                style: TextStyle(
                    color: color2,
                    fontSize: 14,
                    fontFamily: 'SamBold',
                    letterSpacing: 1.5
                ),
              ),
            ],
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
              padding: MaterialStateProperty.all(EdgeInsets.only(left: 10, right: 10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    // side: BorderSide(color: Colors.red)
                  )
              )
          ),
        ),
      ],
    );
  }
  getButton(){
    return Card(
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                if(widget.id == userId){
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return Abonnement();
                  }));
                }
              },
              child: Column(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: user != null
                          ? Text(
                          user.compteAbonnes.length.toString()
                      )
                          : Text(""),
                    ),
                  ),
                  Text(
                    "Abonnés",
                    style: TextStyle(
                      fontFamily: 'SamRegular',
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                if(widget.id == userId){
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                    return Abonnement();
                  }));
                }
              },
              child: Column(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: user != null
                          ? Text(
                          user.compteAbonnement.length.toString()
                      )
                          : Text(""),
                    ),
                  ),
                  Text(
                    "Abonnemments",
                    style: TextStyle(
                      fontFamily: 'SamRegular',
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                      ),
                      iconSize: 20.0,
                      color: secondcolor,
                      onPressed: () {
                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                          return Panier();
                        }));
                      },
                    ),
                  ),
                ),
                Text(
                  "Mes Commandes",
                  style: TextStyle(
                    fontFamily: 'SamRegular',
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.attach_money,
                      ),
                      iconSize: 20.0,
                      color: Colors.black,
                      onPressed: () {
                        // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                        //   return MessagePage();
                        // }));
                      },
                    ),
                  ),
                ),
                Text(
                  "Coupons",
                  style: TextStyle(
                    fontFamily: 'SamRegular',
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  getoption(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.grey,
                ),
                SizedBox(width: 30.0,),
                Text(
                  "My Address",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'SamBold',
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.translate,
                  color: Colors.grey,
                ),
                SizedBox(width: 30.0,),
                Text(
                  "Languages",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'SamBold',
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.supervised_user_circle,
                  color: Colors.grey,
                ),
                SizedBox(width: 30.0,),
                Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'SamBold',
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.contacts,
                  color: Colors.grey,
                ),
                SizedBox(width: 30.0,),
                Text(
                  "Contact us",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'SamBold',
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.contact_support_outlined,
                  color: Colors.grey,
                ),
                SizedBox(width: 30.0,),
                Text(
                  "Help & Forum",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'SamBold',
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0,),

        ],
      ),
    );
  }
}
