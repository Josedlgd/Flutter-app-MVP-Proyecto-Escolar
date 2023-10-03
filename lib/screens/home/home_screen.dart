import 'package:domas_ecommerce/components/components.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: SizeConfig.screenWidth,
          height: double.infinity,
          child: _HomePageBody(
            selectedMenuOpt: uiProvider.selectedMenuOpt,
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  final int selectedMenuOpt;

  const _HomePageBody({required this.selectedMenuOpt});

  @override
  Widget build(BuildContext context) {
    final currentIndex = selectedMenuOpt;

    switch (currentIndex) {
      case 0:
        return const Body();
      case 1:
        return const AllProductsScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const Body();
    }
  }
}
