
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service.dart';


class CloudNotify extends StatefulWidget {
  CloudNotify({Key? key}) : super(key: key);

  @override
  _CloudNotifyState createState() => _CloudNotifyState();
}

class _CloudNotifyState extends State<CloudNotify> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FlutterLocal.initialize(context);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        final myRoute =message.data["route"];
        print(myRoute);
        Navigator.of(context).pushNamed(myRoute);
      }
    }
    );

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        print(message.notification!.title);
        print(message.notification!.body);
      }
     FlutterLocal.display(message);
    });
    ///backround
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final myRoute =message.data["route"];
      print(myRoute);
      Navigator.of(context).pushNamed(myRoute);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff394141),
      appBar: new AppBar(
        backgroundColor: Color(0xff5bb462),
        title: new Text('Flutter Cloud Notification',style: TextStyle(color: Color(0xff394141), fontSize: 20)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Firebase cloud push notification with both foreground & background",style: TextStyle(color: Color(0xff8fd974), fontSize: 18))),
        ],
      ),

    );
  }
}

