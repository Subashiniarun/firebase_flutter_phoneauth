import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/stripe/services.dart';



class HomePage extends StatefulWidget {
  HomePage({ Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  late Text text;


  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 179, 134, 1.0),
        title: Text('Stripe payment via card',style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: Center(
        child: Container(

              child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(50, 40, 40, 40),
                  itemCount: 1,
                  itemBuilder: (context, index){

                    text = Text(' Pay Rs - 2,000', style: TextStyle(color: Colors.black, fontSize: 18));
                    return MaterialButton(
                      color: Color.fromRGBO(0, 179, 134, 1.0),
                        onPressed:()=>  payViaNewCard(context),//_onCustomAnimationAlertPressed(context),
                        child: text,
                    );
                  }
              )
            ),
      ),


    );
  }


  payViaNewCard(BuildContext context) async {

    var response = await StripeService.payWithNewCard(
        amount: '200000',
        currency: 'inr'
    );

    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: response.success == true ? 1100 : 3000),
        )
    );
  }

}
