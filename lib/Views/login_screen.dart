
/// firebase phone authentication
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

  MobileVerficationState currentState = MobileVerficationState
      .show_mbl_form_state;
  final phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String verificationId;
  bool showLoading = false;
  //int _forceResendingToken = 0;


  getMobileFormWidget(context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Phone number verification", style: TextStyle(fontSize: 25),),

          SizedBox(
            height: 20,
          ),
          Text("Enter mobile number with country code (+91 '10 digit numbers')", textAlign:TextAlign.center ,style: TextStyle(fontSize: 18, color: Colors.grey, letterSpacing:1),),


          SizedBox(
            height: 50,
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
                hintText: "phone number"
            ),
          ),
          SizedBox(
            height: 20,
          ),

          MaterialButton(
              minWidth: MediaQuery.of(context).size.height / 2,
            color: Colors.amberAccent,
            child: Text("Verify"),
            onPressed: () async {
              setState(() {
                showLoading = true;
              });

                await _auth.verifyPhoneNumber(
                    timeout: Duration(seconds: 15),
                    phoneNumber: phoneController.text,
                    verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
                      setState(() {
                        showLoading = false;
                        showSnackBar(context, "Verification Completed");
                      });
                    },
                    verificationFailed: (FirebaseAuthException exception) async {
                      showSnackBar(context, exception.toString());
                    },
                    codeSent: (String verificationId, [int? forceResendingToken]) async {
                      setState(() {
                        showLoading = false;
                        currentState = MobileVerficationState.show_otp_form_state;
                        this.verificationId = verificationId;
                        showSnackBar(
                            context, "Verification Code sent on the phone number");

                      });
                    },
                    codeAutoRetrievalTimeout: (String verificationId) async {
                      setState(() {
                        this.verificationId = verificationId;
                        showSnackBar(context, "Time out");
                        print("Time out");
                      });
                    },
                );
              }


              //without forceResendingToken

              /*await _auth.verifyPhoneNumber(
                 phoneNumber: _phoneController.text,
                 forceResendingToken: _forceResendingToken,

                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                //signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                verificationFailed: (verificationFailed) async{
                  _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(verificationFailed.message.toString())));
                },
                 // Normal otp sending format
                //codeSent: (verificationId, resendingToken) async{
                  codeSent: (String verificationId, [int? forceResendingToken]) async{
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
                 timeout: Duration(seconds: 30));*/

          ),
        ],
      ),
    );
  }

  getOtpFormWidget(context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Enter OTP", style: TextStyle(fontSize: 30),),
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
            color: Colors.amberAccent,
            onPressed: () async {
              PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider
                  .credential(
                  verificationId: verificationId, smsCode: _otpController.text);
              signInWithPhoneAuthCredential(phoneAuthCredential);
            },
            child: Text("send"),
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
        padding: const EdgeInsets.only(left: 25, right: 25,),
        child: showLoading
            ? Center(child: CircularProgressIndicator(),)
            : currentState == MobileVerficationState.show_mbl_form_state
            ? getMobileFormWidget(context)
            : getOtpFormWidget(context),
      ),
    );
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential = await _auth.signInWithCredential(
          phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen(num: phoneController.text,)));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      _scaffoldKey.currentState!.showSnackBar(
          SnackBar(content: Text(e.message.toString())));
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}