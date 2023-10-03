import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MainAppBar(
      ),
      body: SafeArea(child: Body()),
    );
  }
}
