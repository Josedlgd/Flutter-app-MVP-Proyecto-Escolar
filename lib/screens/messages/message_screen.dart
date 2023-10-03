import 'package:flutter/material.dart';
import 'components/body.dart';

class MessagesScreen extends StatelessWidget {
  static String routeName = "/message";
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Body()),
    );
  }
}
