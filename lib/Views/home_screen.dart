import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/Views/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox( height: 20,),
            MaterialButton(

              color:Colors.amberAccent ,
              onPressed: () async{
                await _auth.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
              },
              child: Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
