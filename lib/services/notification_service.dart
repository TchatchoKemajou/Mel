import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/notification.dart';

class Services {

  FirebaseFirestore _db = FirebaseFirestore.instance;

  //Get Users
  Stream<List<NotificationModel>> getNotifications(String id){
    return _db
        .collection('Notifications')
        .where('notificationSender', isEqualTo: id)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => NotificationModel.fromJson(doc.data()))
        .toList());
  }
  //Upsert
  Future<void> setNotification(NotificationModel entry){
    var options = SetOptions(merge:true);

    return _db
        .collection('Notifications')
        .doc(entry.notificationId)
        .set(entry.toMap(),options);
  }

  //Delete
  Future<void> removeNotification(String entryId){
    return _db
        .collection('Notifications')
        .doc(entryId)
        .delete();
  }

}