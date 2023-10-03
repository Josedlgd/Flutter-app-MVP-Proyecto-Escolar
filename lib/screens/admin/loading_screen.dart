import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  static String routeName = "/loading";
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.black87,
        ),
      ),
    );
  }
}
