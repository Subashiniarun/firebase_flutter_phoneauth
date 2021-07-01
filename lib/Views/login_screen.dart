import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/Views/home_screen.dart';

enum MobileVerficationState{
  show_mbl_form_state,
  show_otp_form_state
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  MobileVerficationState currentState = MobileVerficationState.show_mbl_form_state;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String verificationId;
  bool showLoading = false;
  // int _forceResendingToken= 0;


  getMobileFormWidget(context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
              hintText: "phone number"
          ),
        ),
        SizedBox(
          height: 20,
        ),

        MaterialButton(
          color: Colors.amberAccent,
          child:Text("Verify"),
          onPressed:() async {
            setState(() {
              showLoading = true;
            });


            //forceResendingToken added

            /*await _auth.verifyPhoneNumber(
              phoneNumber: _phoneController.text,
              forceResendingToken: _forceResendingToken,
              timeout: const Duration(seconds:  20),
              verificationCompleted:(phoneAuthCredential) async
              {setState(() {
                showLoading = false;
              });
                //signInWithPhoneAuthCredential(phoneAuthCredential);

              },
              verificationFailed: (verificationFailed) async{
                _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(verificationFailed.message.toString())));

              },
              codeSent: (verificationId, [forceResendingToken]) async{
                setState(() {
                  showLoading = false;
                  currentState = MobileVerficationState.show_otp_form_state;
                  this.verificationId = verificationId;
                  _forceResendingToken =forceResendingToken!;
                });

              },
              codeAutoRetrievalTimeout:(verificationId) async{
                setState(() {
                  this.verificationId = verificationId;
                });
              },

            );
*/
            //without forceResendingToken

            await _auth.verifyPhoneNumber(
              phoneNumber: _phoneController.text,
              verificationCompleted: (phoneAuthCredential) async
              {setState(() {
                  showLoading = false;
                });
              //signInWithPhoneAuthCredential(phoneAuthCredential);
              },
              verificationFailed: (verificationFailed) async{
                _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(verificationFailed.message.toString())));
              },
              codeSent: (verificationId, resendingToken) async{
                setState(() {
                  showLoading = false;
                  currentState = MobileVerficationState.show_otp_form_state;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout:(verificationId) async{
                setState(() {
                  this.verificationId = verificationId;
                });
              },
              timeout: Duration(seconds: 30));
          },

        ),
      ],
    );
  }
  getOtpFormWidget(context){
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Enter OTP",style: TextStyle(fontSize: 30),),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _otpController,
            decoration: InputDecoration(
                hintText: "Enter OTP"
            ),
          ),
          SizedBox(
            height: 20,
          ),

          MaterialButton(
            color:Colors.amberAccent ,
            onPressed:() async{
              PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: _otpController.text);
              signInWithPhoneAuthCredential(phoneAuthCredential);
            },
            child:Text("Send"),
          ),
          SizedBox(
            height: 20,
          ),
          /*MaterialButton(
            color:Colors.amberAccent ,
            onPressed:() async{
              PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: _otpController.text);
              signInWithPhoneAuthCredential(phoneAuthCredential);
            },
            child:Text("Resend"),

          ),*/
        ],
      ),
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: const EdgeInsets.only(left:25,right: 25,),
        child: showLoading? Center(child: CircularProgressIndicator(),):currentState== MobileVerficationState.show_mbl_form_state
            ?getMobileFormWidget(context)
            :getOtpFormWidget(context),
      ),
    );

  }

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async{
    setState(() {
      showLoading = true;
    });
    try{

      final authCredential = await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if(authCredential.user != null){
        Navigator.push(context,  MaterialPageRoute(builder: (context) => HomeScreen()));

      }

    }on FirebaseAuthException catch(e){
      setState(() {
        showLoading = false;
      });
      _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }
}