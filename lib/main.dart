import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/providers/stripe_provider.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/sections_service.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:flutter/material.dart';
import 'package:domas_ecommerce/routes.dart';
import 'package:domas_ecommerce/theme.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

// ignore: non_constant_identifier_names
final GetIt get_it_instance = GetIt.instance;

void initGetIt() {
  get_it_instance.registerLazySingleton<ProductFormProvider>(() =>
      ProductFormProvider(ProductDB(
          name: '',
          description: '',
          id: '',
          isPopular: false,
          available: false,
          price: 0,
          stock: 0,
          images: [],
          sections: [],
          categories: [])));
  get_it_instance
      .registerLazySingleton<ProductsService>(() => ProductsService());
  get_it_instance.registerLazySingleton<PaymentIntentsService>(
      () => PaymentIntentsService());
  get_it_instance.registerLazySingleton<CartProvider>(() => CartProvider());
  get_it_instance.registerLazySingleton<SectionService>(() => SectionService());
  get_it_instance
      .registerLazySingleton<AuthFirebaseService>(() => AuthFirebaseService());
  get_it_instance
      .registerLazySingleton<CategoriesService>(() => CategoriesService());
  get_it_instance.registerLazySingleton<StripeService>(() => StripeService());
}

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColor.primary,
      statusBarIconBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  await prefs.setBool('isFirstTime', false);

  initGetIt();
  runApp(AppState(
    isFirstTime: isFirstTime,
  ));
}

class AppState extends StatelessWidget {
  const AppState({super.key, required this.isFirstTime});
  final bool isFirstTime;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthFirebaseService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductsService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductsServiceUser(),
        ),
        ChangeNotifierProvider(
          create: (_) => SectionService(),
        ),
        ChangeNotifierProvider(
          create: (_) => PromotionsService(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoriesService(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentIntentsService(),
        ),
        ChangeNotifierProvider(
          create: (_) => UiProvider(),
        ),
      ],
      child: MyApp(
        isFirstTime: isFirstTime,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isFirstTime});
  final bool isFirstTime;
  @override
  Widget build(BuildContext context) {
    if (isFirstTime) {
      return MaterialApp(
        scaffoldMessengerKey: NotificationsService.messengerKey,
        debugShowCheckedModeBanner: false,
        title: 'DoMas ecommerce',
        theme: theme(),
        initialRoute: SplashScreen.routeName,
        routes: routes,
      );
    } else {
      return MaterialApp(
        scaffoldMessengerKey: NotificationsService.messengerKey,
        debugShowCheckedModeBanner: false,
        title: 'DoMas ecommerce',
        theme: theme(),
        initialRoute: CheckAuthScreen.routeName,
        routes: routes,
      );
    }
  }
}
