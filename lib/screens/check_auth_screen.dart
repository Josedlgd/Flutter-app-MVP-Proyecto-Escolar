import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  static String routeName = "/checking";
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final authFirebaseService =
                Provider.of<AuthFirebaseService>(context);
            if (authFirebaseService.isUserAdmin()) {
              return const DashboardScreen();
            } else {
              return const CheckUserCompleted();
            }
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
