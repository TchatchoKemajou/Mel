import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constantes.dart';
import 'package:flutter_app/pages/resultat.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  int tag = 1;
  List<String> tags = [];
  List<String> categorielist = [];

  @override
  void initState() {
    // TODO: implement initState
    categorielist = ['Chaussures', 'Véhicules', 'Electro-Menager', 'Sacs', 'Vêtements', 'Téléphones', 'Ordinateurs', 'Cosmétiques', 'Télévision'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          InkWell(
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return ResultPage(categorie: categorielist[tag],);
                }));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Center(
                  child: Text(
                    "Valider",
                    style: TextStyle(
                        color: secondcolor,
                        fontFamily: 'SamBold',
                        fontSize: 14.0
                    ),
                  ),
                ),
              )
          )
        ],
        title: searchbar() ,
        elevation: 0.0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          children: [
            selectMotcles(),
          ],
        ),
      ),
    );
  }

  selectMotcles(){
    return Column(
      children: [
        Text("Mots clés"),
        ChipsChoice<int>.single(
          mainAxisSize: MainAxisSize.min,
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
              labelPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              labelStyle: TextStyle(
                fontFamily: 'MontBold',
                fontSize: 12.0,
                color: fisrtcolor,
              )
          ),
          spacing: 5.0,
          runSpacing: 3.0,
          wrapped: true,
          value: tag,
          onChanged: (val) => setState(() => tag = val),
          choiceItems: C2Choice.listFrom<int, String>(
            source: categorielist,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
        )
      ],
    );
  }
  searchbar(){
    return Material(
      // elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      child: TextField(
        autocorrect: true,
        style: TextStyle(
          // fontFamily: 'rowregular'
        ),
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: IconButton(
            onPressed: (){},
            icon: Icon(Icons.search, color:  Colors.black,),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
