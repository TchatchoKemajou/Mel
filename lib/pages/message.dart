import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/notification.dart';
import 'package:flutter_app/provider/notification.dart';
import 'package:provider/provider.dart';

import '../constantes.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  String userId = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    final notifyme = Provider.of<NotificationService>(context, listen: false);
    notifyme.cancelNotification();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Centre de notification",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'SamBold'
          ),
        ) ,
        elevation: 0.0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          tabs: [
            Tab(
              child: Text(
                "Notifications",
                style: TextStyle(
                    fontFamily: 'SamBold'
                ),
              ),
            ),
            Tab(
              child: Text(
                "Abonnements",
                style: TextStyle(
                    fontFamily: 'SamBold'
                ),
              ),
            ),
            Tab(
              child: Text(
                "Transactions",
                style: TextStyle(
                    fontFamily: 'SamBold'
                ),
              ),
            )
          ],
          controller: _tabController,
          indicatorColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          notificationTab(),
          Center(child: Text("Chats Tab Bar View")),
          Center(child: Text("Contacts Tab Bar View")),
        ],
        controller: _tabController,
      ),
    );
  }

  notificationTab(){
    final notifyme = Provider.of<NotificationService>(context);
    return StreamBuilder<List<NotificationModel>>(
        stream: notifyme.notifications(userId),
        builder: (context, snapshot){
          return snapshot.data == null || snapshot.connectionState == ConnectionState.none
          ? Center(widthFactor: 20, heightFactor: 20, child: CircularProgressIndicator())
          : ListView.builder(
            padding: EdgeInsets.only(top: 20.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: ListTile(
                    leading: Image(
                      image: AssetImage('assets/images/cadeau.png'),
                      height: 100,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snapshot.data[index].notificationTitle,
                          style: TextStyle(
                            fontFamily: 'SamBold',
                            fontSize: 16,
                            color: Colors.black,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          "il y'a 2 jours",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Text(
                          snapshot.data[index].notificationMessage,
                          style: TextStyle(
                              fontFamily: 'SamRegular',
                              fontSize: 13,
                              color: Colors.black,
                              letterSpacing: 1.0
                          ),
                        ),
                        SizedBox(height: 5,),
                        getdivider(),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       "Mel.com",
                        //       style: TextStyle(
                        //           fontFamily: 'SamBold',
                        //           color: secondcolor
                        //       ),
                        //     ),
                        //     Text(
                        //       "il y'a 2 jours",
                        //       style: TextStyle(
                        //         fontSize: 12,
                        //       ),
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }
  getdivider(){
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
