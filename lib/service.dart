import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterLocal {
 static FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

 static void initialize(BuildContext context){
   final InitializationSettings initializationSettings= InitializationSettings(android:AndroidInitializationSettings("@mipmap/ic_launcher"));
   _localNotificationsPlugin.initialize(
       initializationSettings,
       onSelectNotification:(String? route) async{
         if(route != null){
           Navigator.of(context).pushNamed(route);

         }
   }
   );
 }
 
 static void display(RemoteMessage message) async{
   try {
     final id =DateTime.now().millisecondsSinceEpoch ~/1000;
     final NotificationDetails notificationDetails = NotificationDetails(
       android: AndroidNotificationDetails(
         "FlutterCloudNotification",
         "FlutterCloudNotification Channel",
         "Thank you selecting the channel",
         color: Colors.green,
         importance: Importance.max,
         priority: Priority.high,

       )
     );
     await _localNotificationsPlugin.show(
         id,
         message.notification!.title,
         message.notification!.body,
         notificationDetails,
         payload: message.data["route"]
     );
   } on Exception catch (e) {
     print(e);
   }
 }
}