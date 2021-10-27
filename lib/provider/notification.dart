import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/notification.dart';
import 'package:flutter_app/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationService extends ChangeNotifier {

  final service = Services();

   String _notificationId;
   String _notificationTitle;
   String _notificationMessage;
   String _notificationContent;
   String _notificationSender;
   String _notificationImage;

   String _notificationTimeAgo;


  String get notificationTimeAgo => _notificationTimeAgo;
  var uuid = Uuid();

  showTimeAgo(dynamic timedate){
    DateTime dateTime = timedate;
    _notificationTimeAgo = timeago.format(timedate);
    notifyListeners();
  }

  String get notificationSender => _notificationSender;

  set ChangeNotificationSender(String value) {
    _notificationSender = value;
    notifyListeners();
  }

  String get notificationId => _notificationId;

  set ChangeNotificationId(String value) {
    _notificationId = value;
    notifyListeners();
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("ic_launcher");

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Instant Notifications
  Future instantNofitication(String title, String message) async {
    var android = AndroidNotificationDetails("id", "channel", "description");

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
        0, title, message, platform,
        payload: "Welcome to demo app");

    var newnotification = NotificationModel(notificationId: uuid.v1(), notificationTitle: _notificationTitle,
        notificationMessage: _notificationMessage, notificationContent: _notificationContent, notificationSender: _notificationSender, notificationImage: _notificationImage);
    service.setNotification(newnotification);
  }
  Stream<List<NotificationModel>>  notifications(String id) => service.getNotifications(id);

  //Image notification
  Future imageNotification() async {
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Image notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Stylish Notification
  Future stylishNotification() async {
    var android = AndroidNotificationDetails("id", "channel", "description",
        color: Colors.deepOrange,
        enableLights: true,
        enableVibration: true,
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        styleInformation: MediaStyleInformation(
            htmlFormatContent: true, htmlFormatTitle: true));

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Stylish notification", "Tap to do something", platform);
  }

  //Sheduled Notification

  Future sheduledNotification() async {
    var interval = RepeatInterval.everyMinute;
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        "Demo Sheduled notification",
        "Tap to do something",
        interval,
        platform);
  }

  //Cancel notification

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

   String get notificationTitle => _notificationTitle;

  set ChangeNotificationTitle(String value) {
    _notificationTitle = value;
    notifyListeners();
  }

   String get notificationMessage => _notificationMessage;

  set ChangeNotificationMessage(String value) {
    _notificationMessage = value;
    notifyListeners();
  }

   String get notificationContent => _notificationContent;

  set ChangeNotificationContent(String value) {
    _notificationContent = value;
    notifyListeners();
  }

   String get notificationImage => _notificationImage;

  set ChangeNotificationImage(String value) {
    _notificationImage = value;
    notifyListeners();
  }
}
