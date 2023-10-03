import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

class StripeService extends GetxController {
  Map<String, dynamic>? paymentIntentData;
  String? paymethod;
  double? amount;
  //!SE NECESITA VERIFICAR TAMBIEN QUE SE HIZO EL METODO DE PAGO
  //! CREATE - SHOW - POST
  Future<void> initPayment(
      {required String amount,
      required String currency,
      required BuildContext context}) async {
    try {
      //*CREATE THE DATA THAT THE SHEET NEEDS TO SHOW
      paymentIntentData = await createPaymentIntent(amount, currency);

      //*VERIFIED IF THE PAYMENT INTENT IS NOT NULL / YOU WILL HAVE INFORMATION
      if (paymentIntentData != null) {
        //*SET DATA TO THE SHEET / RESET IF PREVIOUS RELEASE
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          // applePay: true,
          // googlePay: true,
          // testEnv: true,
          // merchantCountryCode: 'US',
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
        ));
        // displayPaymentSheet(context);
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  Future<PaymentIntentsStatus> confirmPay() async {
    final completer = Completer<PaymentIntentsStatus>();
    PaymentIntentsStatus res = PaymentIntentsStatus.RequiresConfirmation;
    final data = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntentData!['client_secret']);
    if (data != null) {
      res = data.status;
    }
    completer.complete(res);
    return completer.future;
  }

  //!DISPLAY SHEET
  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        print("Unforeseen error: ${e}");
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  //!CREATE PAYMENT INTENT
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51MfMfCK1Apnvfbhn0kuk2BJPerebK7lKedHtsqNqtkBlQDPNCsIbCiwpJiWtkSZqkobBO8m2bUEId4DdIv5M00oo00LiOhxGIM',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final int a = (double.parse(amount) * 100).toInt();
    return a.toString();
  }

  init() {
    sessionId = null;
    stripeResponseCheckOut = null;
  }

  String? sessionId;
  Map<String, dynamic>? stripeResponseCheckOut;
  Future<String?> createCheckout({
    required String amount,
    required String type_paymethod,
  }) async {
    final secretKey =
        'sk_test_51MfMfCK1Apnvfbhn0kuk2BJPerebK7lKedHtsqNqtkBlQDPNCsIbCiwpJiWtkSZqkobBO8m2bUEId4DdIv5M00oo00LiOhxGIM';
    final auth = 'Basic ${base64Encode(utf8.encode('$secretKey:'))}';
    final body = {
      'payment_method_types[]': paymethod,
      'line_items': [
        {
          'price_data': {
            'currency': 'MXN',
            'product_data': {
              'name': 'Do Mas',
            },
            'unit_amount': calculateAmount(amount)
          },
          'quantity': 1,
        }
      ],
      'mode': 'payment',
      'success_url': 'http://localhost:8080/#/success',
      'cancel_url': 'http://localhost:8080/#/cancel',
    };

    try {
      final result = await Dio().post(
        "https://api.stripe.com/v1/checkout/sessions",
        data: body,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: auth},
          contentType: "application/x-www-form-urlencoded",
        ),
      );
      if (result.data != null &&
          result.data.containsKey('id') &&
          result.data['id'] != null) {
        stripeResponseCheckOut = result.data;
        sessionId = result.data['id'];
      }
    } on DioError catch (e, s) {
      print(e.response);
      throw e;
    }

    String? res;

    res = stripeResponseCheckOut != null &&
            stripeResponseCheckOut!.containsKey('id')
        ? stripeResponseCheckOut!['id']
        : 'error_creation_paymethod';

    return res;
  }
}
