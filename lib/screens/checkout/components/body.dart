import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/controllers/index.dart';
import 'package:domas_ecommerce/models/direction.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/providers/stripe_provider.dart';
import 'package:domas_ecommerce/screens/home/home_screen.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/general.dart';
import 'package:domas_ecommerce/ui/text_styles.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

enum Paymethods { card, cash }

class _BodyState extends State<Body> {
  CartProvider get cartData => GetIt.instance<CartProvider>();
  StripeService get serverStripeProvider => GetIt.instance<StripeService>();
  PaymentIntentsService get ordersProvider =>
      GetIt.instance<PaymentIntentsService>();

  PaymentIntentsService get orderService =>
      GetIt.instance<PaymentIntentsService>();

  late Future<DateTime?> selectedDate;
  String date = "-";

  late Future<TimeOfDay?> selectedTime;
  String time = "-";

  void _showDialogTimePicker(BuildContext context) {
    // Show the time picker dialog and return the selected time as a Future.
    selectedTime = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        // Customize the look and feel of the dialog using a custom theme.
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              // primary: MyColors.primary,
              primary: AppColor.primary,
              onPrimary: primaryLightColor,
              surface: primaryLightColor,
              onSurface: primaryColorStrong,
            ),
            //.dialogBackgroundColor:Colors.blue[900],
          ),
          child: child!,
        );
      },
    );
    // When the user selects a time, update the state of the widget with the new time value.
    selectedTime.then((value) {
      setState(() {
        if (value == null) return;
        time = "${value.hour} : ${value.minute}";
        orderService.sessionPaymentIntent!.schedule!.hour = value.hour;
        orderService.sessionPaymentIntent!.schedule!.minute = value.minute;
      });
    }, onError: (error) {
      // Handle any errors that occur when selecting a time (e.g. user cancels).
      if (kDebugMode) {
        debugPrint(error);
      }
    });
  }

  DateTime? selected;

  _selectDate(BuildContext context) {
    selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: new DateTime.now().add(new Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primary, // <-- SEE HERE
              onPrimary: primaryColor, // <-- SEE HERE
              onSurface: primaryColorStrong, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColor.primary, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    selectedDate.then((value) {
      setState(() {
        if (value == null) return;
        date = "${value.day} / ${value.month} / ${value.year}";
        orderService.sessionPaymentIntent!.schedule!.day = value;
      });
    }, onError: (error) {
      // Handle any errors that occur when selecting a time (e.g. user cancels).
      if (kDebugMode) {
        debugPrint(error);
      }
    });
  }

  buildWidgetChooseDirections() {
    return SizedBox(
      width: (SizeConfig.screenWidth / 4) * 3,
      height: SizeConfig.screenHeight / 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text('Mis direcciones', style: txtStyleSubTitlePurpleStrong),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    directionSelected = almacenes[index];
                    ordersProvider.directionSelected = almacenes[index];
                    orderService.sessionPaymentIntent!.direction =
                        almacenes[index];

                    orderService.sessionPaymentIntent!.shippingType =
                        'deliver_home';
                  });
                  Navigator.of(context).pop(false);
                },
                child: SizedBox(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.defaultSize,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: paddingVertical),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${userApp.addresses[index].street} #${userApp.addresses[index].numberExt}',
                          style: txtStyleBodyGrayStrong,
                          overflow: TextOverflow.clip,
                        ),
                        Text(
                          '${userApp.addresses[index].neighborhood} CP:${userApp.addresses[index].zipCode}',
                          style: txtStyleBodyGrayStrong,
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ),
                ),
              );

              // return RadioListTile(
              //     title: Text(
              //       '${userApp.addresses[index].street} #${userApp.addresses[index].numberExt}',
              //       style: txtStyleBodyGrayStrong,
              //       overflow: TextOverflow.clip,
              //     ),
              //     subtitle: Text(
              //       '${userApp.addresses[index].neighborhood} CP:${userApp.addresses[index].zipCode}',
              //       style: txtStyleBodyGrayStrong,
              //       overflow: TextOverflow.clip,
              //     ),
              //     value: userApp.addresses[index],
              //     selected: userApp.addresses[index] == directionSelected,
              //     groupValue: directionSelected,
              //     onChanged: (Address? value) {
              //       setState(() {
              //         directionSelected = value;
              //       });
              //       Navigator.of(context).pop(false);
              //     });
            },
            separatorBuilder: (context, index) => const Divider(
                thickness: 1.0, color: AppColor.primary, height: 4),
            itemCount: userApp.addresses.length,
          ),
          const Divider(
            color: primaryColorStrong,
            thickness: 3.0,
            height: 10,
          ),
          const Text('Almacen', style: txtStyleSubTitlePurpleStrong),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    directionSelected = almacenes[index];
                    orderService.sessionPaymentIntent!.shippingType =
                        'warehous';
                  });
                  Navigator.of(context).pop(false);
                },
                child: SizedBox(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.defaultSize,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: paddingVertical),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${almacenes[index].street} #${almacenes[index].numberExt}',
                          style: txtStyleBodyGrayStrong,
                          overflow: TextOverflow.clip,
                        ),
                        Text(
                          '${almacenes[index].neighborhood} CP:${almacenes[index].zipCode}',
                          style: txtStyleBodyGrayStrong,
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
                thickness: 1.0, color: AppColor.primary, height: 4),
            itemCount: almacenes.length,
          ),
        ],
      ),
    );
  }

  List<Widget> getWidgetListPaymethod() {
    return [
      RadioListTile<Paymethods>(
        value: Paymethods.card,
        groupValue: paymethod,
        onChanged: (Paymethods? value) {
          setState(() {
            paymethod = value;
            serverStripeProvider.paymethod = 'card';
          });
        },
        title: Row(
          children: const [
            Expanded(
                flex: 3,
                child: Icon(Icons.credit_card_off_sharp,
                    color: primaryColorStrong)),
            Expanded(
                flex: 9,
                child:
                    Text('Tarjeta de Crédito', style: txtStyleBodyGrayStrong)),
          ],
        ),
      ),
      RadioListTile<Paymethods>(
        value: Paymethods.cash,
        groupValue: paymethod,
        onChanged: (Paymethods? value) {
          setState(() {
            paymethod = value;
            serverStripeProvider.paymethod = 'cash';
          });
        },
        title: Row(
          children: const [
            Expanded(
                flex: 3,
                child: Icon(Icons.payment_outlined, color: primaryColorStrong)),
            Expanded(
                flex: 9,
                child: Text('Pago en efectivo', style: txtStyleBodyGrayStrong)),
          ],
        ),
      ),
    ];
  }

  String getStringDirectionSelected() {
    String res = '';

    if (directionSelected!.street != null && directionSelected!.street != '') {
      res = '$res${directionSelected!.street}';
    }

    if (directionSelected!.numberExt != null &&
        directionSelected!.numberExt! > -1) {
      res = '$res #${directionSelected!.numberExt}';
    }

    if (directionSelected!.numberInt != null &&
        directionSelected!.numberInt! > -1) {
      res = '$res Int #${directionSelected!.numberInt}';
    }

    if (directionSelected!.neighborhood != null &&
        directionSelected!.neighborhood != '') {
      res = '$res ${directionSelected!.neighborhood}';
    }

    return res;
  }

  buildWidgetResponse() {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: paddingVertical * 2),
          child: Text(
            'Información de envío',
            style: txtStyleTitleSecondaryColor,
          ),
        ),
        // Section 2 - Shipping Information
        Container(
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 20),
          decoration: BoxDecoration(
            color: AppColor.primarySoft,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColor.border, width: 1),
          ),
          child: Column(
            children: [
              // Name

              // Address
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      child:
                          SvgPicture.asset('assets/icons/Home.svg', width: 18),
                    ),
                    Expanded(
                      child: Text(
                        getStringDirectionSelected(),
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => onWillPop(
                          widgetToShow: buildWidgetChooseDirections(),
                          context: context,
                          actions: [],
                          icon: const Icon(
                            Icons.directions,
                            color: primaryColorStrong,
                          ),
                          titleAlert: 'Selecciona una direccion',
                          txtContentAlert: 'Selecciona una direccion'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColor.primary,
                        shape: const CircleBorder(),
                        backgroundColor: AppColor.border,
                        elevation: 0,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/Pencil.svg',
                        width: 16,
                        color: AppColor.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Phone Number
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    child:
                        SvgPicture.asset('assets/icons/Profile.svg', width: 18),
                  ),
                  Expanded(
                    child: Text(
                      '${userApp.name} ${userApp.lastName}',
                      style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Section 3 - Select Shipping method
        Container(
          margin: const EdgeInsets.only(top: 24),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColor.border, width: 1),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: const BoxDecoration(
                  color: AppColor.primarySoft,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                // Content
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Selecciona el método de entrega',
                            style: TextStyle(
                                color: AppColor.secondary.withOpacity(0.7),
                                fontSize: 10)),
                        const Text('Envío',
                            style: TextStyle(
                              color: AppColor.secondary,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    Text(
                        directionSelected!.isAlmacen != null &&
                                directionSelected!.isAlmacen!
                            ? 'Sin envío'
                            : 'Pagar envío',
                        style: const TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: paddingVertical),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 4,
                            child: Text(
                              'Envío',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.secondary),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              directionSelected!.isAlmacen != null &&
                                      directionSelected!.isAlmacen!
                                  ? 'Recoger en almacen'
                                  : '1-2 Días',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColor.secondary.withOpacity(0.7)),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              directionSelected!.isAlmacen != null &&
                                      directionSelected!.isAlmacen!
                                  ? '\$0'
                                  : '\$50',
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Text(
                            'Productos',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.secondary),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            '${cartItems.length} Productos',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColor.secondary.withOpacity(0.7)),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            '\$${getTotalOfProductsCart()}',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.primary),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: paddingVertical),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 4,
                            child: Text('Total', style: txtStyleBodyGrayStrong),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColor.secondary.withOpacity(0.7)),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              '\$${getTotalOrder()}',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: paddingVertical * 2),
          child: Text(
            'Fecha y hora de entrega',
            style: txtStyleTitleSecondaryColor,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
          child: ElevatedButton(
            onPressed: () => _selectDate(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontal / 2),
                          child: Icon(
                            Icons.date_range,
                            size: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(date,
                            style: txtStyleSubTitleWhite,
                            overflow: TextOverflow.ellipsis),
                      ],
                    )
                  ],
                ),
                const Text("  Elegir Fecha",
                    style: txtStyleSubTitleWhite,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
          child: ElevatedButton(
            onPressed: () => _showDialogTimePicker(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontal / 2),
                          child: Icon(
                            Icons.access_time,
                            size: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          time,
                          style: txtStyleSubTitleWhite,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  ],
                ),
                const Text("  Elegir Hora",
                    style: txtStyleSubTitleWhite,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),

        // SECTION 4 ITEMS

        const Padding(
          padding: EdgeInsets.symmetric(vertical: paddingVertical * 2),
          child: Text(
            'Método de pago',
            style: txtStyleTitleSecondaryColor,
          ),
        ),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return getWidgetListPaymethod()[index];
          },
          separatorBuilder: (context, index) => const Divider(
              thickness: 1.0, color: AppColor.primary, height: 16),
          itemCount: getWidgetListPaymethod().length,
        ),

        const Padding(
          padding: EdgeInsets.only(top: paddingVertical * 2),
          child: Text(
            'Resumen de compra',
            style: txtStyleTitleSecondaryColor,
          ),
        ),

        Container(
          margin: const EdgeInsets.only(top: 24),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CartTileCheckout(
                data: cartItems[index],
              );
            },
            separatorBuilder: (context, index) => const Divider(
                thickness: 3.0, color: AppColor.primary, height: 16),
            itemCount: cartItems.length,
          ),
        ),
      ],
    );
  }

  String getTotalOfProductsCart() {
    num total = 0.0;
    for (var item in cartItems) {
      total += item.productPrice!;
    }
    return total.toString();
  }

  @override
  void initState() {
    serverStripeProvider.paymethod = 'card';
    super.initState();
  }

  String getTotalOrder() {
    final resProducts = double.parse(getTotalOfProductsCart());
    final resEnvio =
        directionSelected!.isAlmacen != null && directionSelected!.isAlmacen!
            ? 0.0
            : 50.0;
    return (resProducts + resEnvio).toString();
  }

  AuthFirebaseService get userProvider => GetIt.instance<AuthFirebaseService>();

  late UserApp userApp;
  late List<Cart> cartItems;
  late List<Address> almacenes;

  Address? _directionSelected;

  Address? get directionSelected => _directionSelected;

  set directionSelected(Address? value) {
    _directionSelected = value;
  }

  Paymethods? paymethod = Paymethods.card;

  Future<bool> retrieveDataToCheckout() async {
    userApp = await userProvider.getUserData();
    cartItems = await cartData.getData();
    almacenes = await userProvider.retrieveAlmacenes();

    if (directionSelected == null) {
      if (userApp.addresses.isNotEmpty) {
        directionSelected = userApp.addresses[0];
      } else if (almacenes.isNotEmpty) {
        directionSelected = almacenes[0];
      } else {
        directionSelected = example_adress;
      }

      orderService.sessionPaymentIntent!.direction = directionSelected;
      orderService.sessionPaymentIntent!.shippingType =
          directionSelected!.isAlmacen != null && directionSelected!.isAlmacen!
              ? 'deliver_home'
              : 'warehous';
      serverStripeProvider.amount = double.parse(getTotalOrder());
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: retrieveDataToCheckout(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Future resolved check if it has error
            if (snapshot.hasError) {
              // showErrorAlert(
              //     context, 'Error al acceder a mis, Intenta mas tarde');
              return const Center(
                child: Text("Error en extracción de información"),
              );
            } else if (snapshot.hasData) {
              //NOTE: isEmpty can only be used on Maps and Strings
              if (snapshot.data is bool && snapshot.data == true) {
                return buildWidgetResponse();
              }
              return buildWidgetEmptyData();
            } else {
              // Error screen
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Center(
                      child: CircularProgressIndicator(
                    color: primaryColorStrong,
                    strokeWidth: 10.0,
                    value: 1.0,
                  )),
                ],
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // Future in progress
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Center(
                      child: CircularProgressIndicator(
                    color: primaryColorStrong,
                    strokeWidth: 10.0,
                    value: 1.0,
                  )),
                ],
              ),
            );
          } else {
            return Text("State: ${snapshot.connectionState}");
          }
        });
  }

  buildWidgetEmptyData() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          const Image(
            image: NetworkImage(
                'https://cdni.iconscout.com/illustration/premium/thumb/empty-cart-2130356-1800917.png'),
          ),
          const SizedBox(
            height: 20,
          ),
          Text('Tu carrito se encuentra vacío 😌',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 48),
            child: Text(
                'Explora nuestros productos y \ncompra tus artículos favoritos',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: AppColor.border,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              'Regresar al inicio',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: AppColor.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
