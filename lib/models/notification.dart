class NotificationModel{

  final String notificationId;
  final String notificationTitle;
  final String notificationMessage;
  final String notificationContent;
  final String notificationSender;
  final String notificationImage;
  final DateTime notificationCreateDate;

  NotificationModel({this.notificationId, this.notificationTitle, this.notificationMessage, this.notificationContent, this.notificationSender, this.notificationImage, this.notificationCreateDate});

  factory NotificationModel.fromJson(Map<String, dynamic> json){
    return NotificationModel(
     notificationId: json['notificationId'] == null ? "" : json['notificationId'],
    notificationTitle: json['notificationTitle'] == null ? "" : json['notificationTitle'],
    notificationMessage: json['notificationMessage'] == null ? "" : json['notificationMessage'],
    notificationContent: json['notificationContent'] == null ? "" : json['notificationContent'],
      notificationSender: json['notificationSender'] == null ? "" : json['notificationSender'],
    notificationImage: json['notificationImage'] == null ? "" : json['notificationImage'],
        notificationCreateDate: json['notificationCreateDate'] == null ? DateTime.now() : json['notificationCreateDate'].toDate()
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'notificationId' : notificationId,
      'notificationTitle' : notificationTitle,
      'notificationMessage' : notificationMessage,
      'notificationContent' : notificationContent,
      'notificationSender' : notificationSender,
      'notificationImage' : notificationImage,
      'notificationCreateDate' : notificationCreateDate
    };
  }

}