import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckUserCompleted extends StatelessWidget {
  static String routeName = "/checkUserCompleted";
  const CheckUserCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    final authFirebaseService = Provider.of<AuthFirebaseService>(context);
    return FutureBuilder<bool>(
      future: authFirebaseService.checkUserExist(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data == true) {
          return const HomeScreen();
        } else {
          return const CompleteProfileScreen();
        }
      },
    );
  }
}
