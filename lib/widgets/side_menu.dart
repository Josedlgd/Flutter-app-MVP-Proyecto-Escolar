import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/screens/admin/categories/categories_screen.dart';
import 'package:domas_ecommerce/screens/admin/secciones/index_section_screen.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:domas_ecommerce/services/services.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  ProductsService get productsService => GetIt.instance<ProductsService>();

  @override
  Widget build(BuildContext context) {
    final authFirebaseService =
        Provider.of<AuthFirebaseService>(context, listen: false);

    return Drawer(
      child: ListView(
        children: [
          const _DrawerHeader(),
          ListTile(
            leading: const Icon(Icons.pages_rounded),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(
                  context, DashboardScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Productos'),
            onTap: () async {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, ProductsScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.type_specimen),
            title: const Text('Secciones'),
            onTap: () async {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, SectionsScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categorías'),
            onTap: () async {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(
                  context, CategoriesScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: const Text('Cerrar sesión'),
            onTap: () {
              authFirebaseService.signOutUser();
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
              NotificationsService.showSnackbar(
                  '¡Cerraste sesión!', sucessColor);
            },
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/menu-img.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(),
    );
  }
}
