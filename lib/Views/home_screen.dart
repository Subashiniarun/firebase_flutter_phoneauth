import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/Views/login_screen.dart';

class HomeScreen extends StatefulWidget {
  String num ="";
  HomeScreen({Key? key, required this.num}) : super(key: key);

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
            Spacer(),
            Text("Welcome",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 5),
            ),
            SizedBox(
              height: 20,
            ),
            Text(widget.num,style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 5, color:Colors.grey),
            ),
            Spacer(),

            MaterialButton(
              minWidth: MediaQuery.of(context).size.height / 2,

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
