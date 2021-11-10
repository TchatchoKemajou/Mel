import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/provider/compteprovider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;

import '../constantes.dart';

class EditProfil extends StatefulWidget {
  final Compte user;
  EditProfil({this.user});
  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  String userId = FirebaseAuth.instance.currentUser.uid;
  String imagesLink;
  firebase_storage.Reference ref;
  final picker = ImagePicker();
  //firebase_storage.Reference ref;
  io.File image;
  PickedFile file;
  bool isModify = false;

  @override
  void initState() {
    final compteprovider = Provider.of<CompteProvider>(context, listen: false);
    if(widget.user != null){
      compteprovider.loadAll(widget.user);
    }
    // TODO: implement initState
    super.initState();
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

  Text start(int rating){
    String stars = '';
    for(int i = 0; i < rating; i++){
      stars += '★';
    }
    return Text(
      stars,
      style: TextStyle(
        fontFamily: 'MontRegular',
        color: Colors.deepOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compteprovider = Provider.of<CompteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: isModify == true ?  InkWell(
              onTap: () {
                compteprovider.saveCompte(userId);
                Navigator.pop(context);
              },
              child: Icon(
                Icons.check,
                color: Colors.blueAccent,
                size: 32,
              ),
            ) : SizedBox(),
          )
        ],
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 32,
          ),
        ),
        title: Text(
          "Mon profil",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'SamBold',
              letterSpacing: 1.0,
              fontSize: 18
          ),
        ),
        elevation: 2.0,
        foregroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Avatar",
                    style: TextStyle(
                      //color: Colors.white,
                      fontFamily: 'SamRegular',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InkWell(
                    onTap: () async{
                      file = await picker.getImage(
                          source: ImageSource.gallery,
                          imageQuality: 50,
                          maxWidth: 150);
                      openDialogprofil(imageSelect(io.File(file.path)));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: widget.user != null ? NetworkImage(widget.user.compteProfil,) : null,
                          child: widget.user != null ? widget.user.compteProfil == null || widget.user.compteProfil == "" ? Center(child: Text(
                            widget.user.compteName.toUpperCase().substring(0, 1),
                            style: TextStyle(
                                fontSize: 24
                            ),
                          ),) : SizedBox() : SizedBox(),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: secondcolor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "User name",
                  style: TextStyle(
                    //color: Colors.white,
                    fontFamily: 'SamRegular',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                   width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (e) {
                      setState(() {
                        compteprovider.changeCompteName = e;
                        if(e != null){
                          isModify = true;
                        }else isModify = false;
                      });
                    },
                    style: TextStyle(
                      fontFamily: 'SamBold',
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: compteprovider.compteName,
                      hintStyle: TextStyle(
                        fontFamily: 'SamBold',
                        color: Colors.black,
                      ),
                      suffixIcon: Icon(
                        Icons.edit,
                        color: fisrtcolor,
                        size: 16,
                      ),
                      hintTextDirection: TextDirection.rtl,
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Téléphone",
                  style: TextStyle(
                    //color: Colors.white,
                    fontFamily: 'SamRegular',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (e) {
                      compteprovider.changeComptePhone = e;
                      setState(() {
                        if(e != null){
                          isModify = true;
                        }else isModify = false;
                      });
                    },
                    style: TextStyle(
                      fontFamily: 'SamBold',
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: compteprovider.comptePhone,
                      hintStyle: TextStyle(
                        fontFamily: 'SamBold',
                        color: Colors.black,
                      ),
                      suffixIcon: Icon(
                        Icons.edit,
                        color: fisrtcolor,
                        size: 16,
                      ),
                      hintTextDirection: TextDirection.rtl,
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "E-Mail",
                  style: TextStyle(
                    //color: Colors.white,
                    fontFamily: 'SamRegular',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (e) {
                      compteprovider.changeCompteEmail = e;
                      setState(() {
                        if(e != null){
                          isModify = true;
                        }else isModify = false;
                      });
                    },
                    style: TextStyle(
                      fontFamily: 'SamBold',
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: compteprovider.compteEmail,
                      hintStyle: TextStyle(
                        fontFamily: 'SamBold',
                        color: Colors.black,
                      ),
                      suffixIcon: Icon(
                        Icons.edit,
                        color: fisrtcolor,
                        size: 16,
                      ),
                      hintTextDirection: TextDirection.rtl,
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Evaluation",
                  style: TextStyle(
                    //color: Colors.white,
                    fontFamily: 'SamRegular',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                start(4),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Compte",
                  style: TextStyle(
                    //color: Colors.white,
                    fontFamily: 'SamRegular',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: (){

                  },
                  child: Row(
                    children: [
                      Text(
                        "Standard",
                        style: TextStyle(
                            fontFamily: 'SamBold',
                            color: secondcolor
                        ),
                      ),
                      Icon(
                        Icons.edit,
                        color: fisrtcolor,
                        size: 16,
                      ),
                    ],
                  ),
                )
              ],
            ),

            getdivider(),

            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pays",
                    style: TextStyle(
                      //color: Colors.white,
                      fontFamily: 'SamRegular',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Cameroun",
                    style: TextStyle(
                        fontFamily: 'SamBold',
                        color: Colors.black
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Region",
                    style: TextStyle(
                      //color: Colors.white,
                      fontFamily: 'SamRegular',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.user.compteAddress["region"],
                    style: TextStyle(
                        fontFamily: 'SamBold',
                        color: Colors.black
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ville",
                    style: TextStyle(
                      //color: Colors.white,
                      fontFamily: 'SamRegular',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.user.compteAddress["ville"],
                    style: TextStyle(
                        fontFamily: 'SamBold',
                        color: Colors.black
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Quartier",
                    style: TextStyle(
                      //color: Colors.white,
                      fontFamily: 'SamRegular',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.user.compteAddress["quartier"],
                    style: TextStyle(
                        fontFamily: 'SamBold',
                        color: Colors.black
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Carrefour",
                    style: TextStyle(
                      //color: Colors.white,
                      fontFamily: 'SamRegular',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.user.compteAddress["rue"],
                    style: TextStyle(
                        fontFamily: 'SamBold',
                        color: Colors.black
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
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
   // compteProvider.loadAll(user);
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
  getdivider(){
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
