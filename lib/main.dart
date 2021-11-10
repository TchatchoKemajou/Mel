import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/article_detail.dart';
import 'package:flutter_app/pages/splashscreen.dart';
import 'package:flutter_app/provider/LanguageChangeProvider.dart';
import 'package:flutter_app/provider/collection_provider.dart';
import 'package:flutter_app/provider/compteprovider.dart';
import 'package:flutter_app/provider/locationservice.dart';
import 'package:flutter_app/provider/produit_provider.dart';
import 'package:flutter_app/services/google_sign_in.dart';
import 'package:flutter_app/provider/notification.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        ChangeNotifierProvider(create: (_) => NotificationService()),
        ChangeNotifierProvider(create: (_) =>  LanguageChangeProvider(),)
      ],
      child: Builder(
        builder: (context) => Consumer<LanguageChangeProvider>(
            builder: (context, value, child){
              return  MaterialApp(
                //title: 'Flutter Demo',
                locale: Provider.of<LanguageChangeProvider>(context, listen: true).currentLocale,
                localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: fisrtcolor,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                routes:<String, WidgetBuilder> {
                  '/': (BuildContext context)  => Splashcreen(),
                  '/article': (BuildContext context)  => ArticleDetail()
                },
              );
            }
        ),
      ),
    );
  }
}


class LoadingScreen extends StatefulWidget {
  final BuildContext context;
  const LoadingScreen({@required this.context});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  void getdata() async{
    await Future.delayed(Duration(seconds: 2));
    widget.context.read<LanguageChangeProvider>().doneLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        // body: Center(
        //   child: Text(
        //     "Duvals",
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 24,
        //       fontFamily: 'ManropeBold',
        //     ),
        //   ),
        // ),
      ),
    );
  }
}

