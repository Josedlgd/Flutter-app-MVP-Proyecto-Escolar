import 'package:flutter/material.dart';
import 'package:domas_ecommerce/screens/splash/components/body.dart';
import 'package:domas_ecommerce/size_config.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";

  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: SafeArea(child: Body()),
    );
  }
}
