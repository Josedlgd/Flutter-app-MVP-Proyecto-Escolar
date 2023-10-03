import 'package:domas_ecommerce/screens/screens.dart';
import 'package:flutter/widgets.dart';

import 'screens/admin/secciones/add_section_screen.dart';
import 'screens/admin/secciones/index_section_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  MessagesScreen.routeName: (context) => const MessagesScreen(),
  CheckAuthScreen.routeName: (context) => const CheckAuthScreen(),
  CheckUserCompleted.routeName: (context) => const CheckUserCompleted(),

  /** Admin screen */
  DashboardScreen.routeName: (context) => const DashboardScreen(),
  ProductScreen.routeName: (context) => const ProductScreen(),
  ProductsScreen.routeName: (context) => const ProductsScreen(),
  CategoriesScreen.routeName: (context) => const CategoriesScreen(),
  CategoryScreen.routeName: (context) => const CategoryScreen(),
  SectionsScreen.routeName: (context) => const SectionsScreen(),
  FormSectionScreen.routeName: (context) => const FormSectionScreen(),
};
