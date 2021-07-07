import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/service.dart';
import 'Views/flutter_cloud_nofification.dart';
import 'Views/flutter_local_notification.dart';
import 'Views/login_screen.dart';

Future<void> onMesHandler(RemoteMessage message) async{
 print(message.data.toString());

  print(message.notification!.title);

}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(onMesHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: CloudNotify(),//task 9
      routes: {
        "local":(_) => LocalNotifi(),
        "login":(_) => LoginScreen(),

      }
             //LocalNotifi(), //task 8
            // LoginScreen(), // task 7 (Phone auth)
    );
  }
}


