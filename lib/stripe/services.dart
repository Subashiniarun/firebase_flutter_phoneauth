import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({required this.message, required this.success});
}

class StripeService {

  static var paymentApiUrl = "https://api.stripe.com/v1/payment_intents";

  static String secret = 'sk_test_51JBDcCSGzErhjlIzj3kt1zueuVXozdAJ5XjCrbIttyDvwIOwlz9wn93rx1fHIrqleyv5k7eOGgMZzHwUOCDUNPQ400xmlNlpDC';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Accept': 'application/json',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(
        StripeOptions(
            publishableKey: "pk_test_51JBDcCSGzErhjlIzXSVAedo8DI7Af5xhWdm6cBagXStsl64pBYu88sp1vaEpoarONzQd3WqkTZy7CHtgKm97qYqP00iGVJX7ii",
            merchantId: "Test",
            androidPayMode: 'test'
        )
    );
  }

  static Future<StripeTransactionResponse> payWithNewCard({required String amount, required String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest()
      );

      ///Adding secure authentication
      var response =  await StripePayment.authenticatePaymentIntent(clientSecret: StripeService.secret).then((value) async{


        var paymentIntent = await StripeService.createPaymentIntent(amount, currency);

        await StripePayment.confirmPaymentIntent(
            PaymentIntent(clientSecret: paymentIntent!['client_secret'], paymentMethodId: paymentMethod.id));
        },
      );
      //var paymentIntent =
      //await StripePayment.authenticatePaymentIntent(clientSecret: StripeService.secret);


      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      return getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled ';
      print("Something went wrong $err");
    }

    return new StripeTransactionResponse(
        message: message,
        success: false
    );
  }



  /*static Future<StripeTransactionResponse> payWithNewCard({required String amount, required String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest()
      );


      var paymentIntent = await StripeService.createPaymentIntent(
          amount,
          currency
      );

      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent!['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      return getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }*/


  static Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(

          Uri.https(  'api.stripe.com' , "/v1/payment_intents" ),
          body: body,
          headers: StripeService.headers
      );
      print("my : $paymentApiUrl");
     print("my response : ${response.body.toString()}");
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }

}
