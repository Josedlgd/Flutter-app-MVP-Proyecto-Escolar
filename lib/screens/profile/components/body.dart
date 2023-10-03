import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/screens/orders/orders_screen.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final authFirebaseService = AuthFirebaseService();
    final uiProvider = Provider.of<UiProvider>(context);
    return FutureBuilder<UserApp>(
      future: Provider.of<AuthFirebaseService>(context).getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userAppData = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Profile Picture
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey,
                          image: DecorationImage(
                            image: NetworkImage(userAppData.profilePicture!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Fullname
                      Container(
                        margin: const EdgeInsets.only(bottom: 4, top: 14),
                        child: Text(
                          "${userAppData.name} ${userAppData.lastName}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                // Section 2 - Account Menu
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Cuenta',
                          style: TextStyle(
                              color: AppColor.secondary.withOpacity(0.5),
                              letterSpacing: 6 / 100,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      MenuTileWidget(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const OrdersScreen()));
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/Bag.svg',
                          color: AppColor.secondary.withOpacity(0.5),
                        ),
                        title: 'Pedidos',
                        subtitle: 'Revisa el estado de tus pedidos',
                      ),
                      MenuTileWidget(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AddressScreen()));
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/Location.svg',
                          color: AppColor.secondary.withOpacity(0.5),
                        ),
                        title: 'Direcciones',
                        subtitle: 'Ve tus direcciones, agrega y edítalas',
                      ),
                    ],
                  ),
                ),

                // Section 3 - Settings
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Configuración',
                          style: TextStyle(
                              color: AppColor.secondary.withOpacity(0.5),
                              letterSpacing: 6 / 100,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      MenuTileWidget(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, SignInScreen.routeName);
                          authFirebaseService.signOutUser();
                          uiProvider.selectedMenuOpt = 0;
                          NotificationsService.showSnackbar(
                              '¡Cerraste sesión!', sucessColor);
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/Log-out.svg',
                          color: Colors.white,
                        ),
                        iconBackground: Colors.red,
                        title: 'Cerrar sesión',
                        titleColor: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
