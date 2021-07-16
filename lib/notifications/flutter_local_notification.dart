import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNotifi extends StatefulWidget {
  @override
  _LocalNotifiState createState() => _LocalNotifiState();
}

class _LocalNotifiState extends State<LocalNotifi> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
            print("$payload");
          }

        } );
  }

  /*onSelectNotification(String payload)  {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff394141),
      appBar: new AppBar(
        backgroundColor: Color(0xff5bb462),
        title: new Text('Flutter Local Notification',style: TextStyle(color: Color(0xff394141), fontSize: 20)),
        centerTitle: true,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 200,),
            Center(
              child: IconButton(
                icon: Icon(Icons.play_circle_filled_rounded, color:Color(0xff5bb462),),
                iconSize: 80, onPressed: showNotification,
              ),
            ),
            /*Center(
              child: IconButton(
                icon: Icon(Icons.play_circle_filled_rounded, color:Color(0xff5bb462),),
                iconSize: 80,
                onPressed: showNotificationMediaStyle,
              ),
            ),*/
            SizedBox(height: 50,),
            Text('Tap play button to get a notification',style: TextStyle(color: Color(0xff8fd974), fontSize: 18)),
            Spacer()
          ],
          /*new Text( Theme.of(context).textTheme.button
            'Tap To Get a Notification',
            style:,
          ),*/
        ),
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        color: Colors.red,
        enableLights: true,
        //largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
        //styleInformation: MediaStyleInformation(),
        priority: Priority.high,importance: Importance.high
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        1, 'Music Player', 'Thank you for choose the song', platform,
        payload: 'Welcome to the Local Notification demo');
  }
  /*showNotificationMediaStyle() async {
    var android= AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      'media channel description',
      color: Colors.red,
      enableLights: true,
        priority: Priority.high, importance: Importance.high,

      styleInformation: MediaStyleInformation(),
    );
    var platformChannelSpecifics =
    NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
        0, 'notification title', 'notification body', platformChannelSpecifics, payload: 'Welcome to the Local Notification demo');
  }*/
}