import 'package:domas_ecommerce/size_config.dart';
import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 800),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenWidth(10)),
      elevation: 0,
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
