import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/article_detail.dart';
import 'package:flutter_app/pages/splashscreen.dart';
import 'package:flutter_app/provider/collection_provider.dart';
import 'package:flutter_app/provider/compteprovider.dart';
import 'package:flutter_app/provider/locationservice.dart';
import 'package:flutter_app/provider/produit_provider.dart';
import 'package:flutter_app/services/google_sign_in.dart';
import 'package:flutter_app/provider/notification.dart';
import 'package:provider/provider.dart';

import 'constantes.dart';

void main() async{
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CompteProvider>(create: (_) => CompteProvider()),
        Provider<ProduitProvider>(create: (_) => ProduitProvider()),
        Provider<CollectionProvider>(create: (_) => CollectionProvider()),
        Provider<GoogleSignInProvider>(create: (_) => GoogleSignInProvider()),
        Provider<LocationService>(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => NotificationService())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: fisrtcolor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes:<String, WidgetBuilder> {
          '/': (BuildContext context)  => Splashcreen(),
          '/article': (BuildContext context)  => ArticleDetail()
        },
      ),
    );
  }
}

