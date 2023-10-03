import 'package:domas_ecommerce/components/components.dart';
import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/controllers/general.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/providers/stripe_provider.dart';
import 'package:domas_ecommerce/screens/checkout/components/stripe_checkout.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import 'components/body.dart';

class CheckoutScreen extends StatefulWidget {
  static String routeName = "/cart";
  CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    // INIT PAYMENT INTENT
    final fromHour = TimeOfDay.now();
    //SECTION //! INIT PAYMENT INTENT

    orderService.sessionPaymentIntent = PaymentIntent();
    orderService.sessionPaymentIntent!.paymentType = 'card';
    orderService.sessionPaymentIntent!.schedule = Schedule(
      day: DateTime.now(),
      hour: fromHour.hour,
      minute: fromHour.minute,
    );
    orderService.sessionPaymentIntent!.orderResume = OrderResume(
        cupon: '',
        descount: 0,
        idCupon: '',
        quantityProducts: 0,
        shipping: 0,
        total: 0,
        totalProducts: 0);
    orderService.sessionPaymentIntent!.products = [];
  }

  StripeService get serverStripeProvider => GetIt.instance<StripeService>();

  PaymentIntentsService get ordersProvider =>
      GetIt.instance<PaymentIntentsService>();

  AuthFirebaseService get userProvider => GetIt.instance<AuthFirebaseService>();

  CartProvider get cartData => GetIt.instance<CartProvider>();

  PaymentIntentsService get orderService =>
      GetIt.instance<PaymentIntentsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: const [
            Text('Checkout',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColor.primarySoft,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColor.border, width: 1))),
        child: ElevatedButton(
          onPressed: () async {
            bool res = false;
            final user = await userProvider.getUserData();
            // final products = await cartData.getProductCarts();

            //NOTE //!DETAILS FOR PAYMENT INTENT
            orderService.sessionPaymentIntent!.details = Details(
              creationDate: DateTime.now(),
              email: user.email,
              name: '${user.name} ${user.lastName}',
              telephone: user.phoneNumbers.isNotEmpty
                  ? user.phoneNumbers[0].phoneNumber.toString()
                  : 'No number',
              userId: user.id,
            );

            //NOTE  //! PAYMENT TYPE
            orderService.sessionPaymentIntent!.paymentType =
                serverStripeProvider.paymethod;

            //NOTE  //! PRODUCTS CART
            orderService.sessionPaymentIntent!.products =
                await cartData.getData();

            final totalProducts = cartData.getTotalOfCheckout();
            final totalDescountProducts = cartData.getTotalDescountOfCheckout();
            final totalDelivery =
                orderService.sessionPaymentIntent!.shippingType ==
                        'deliver_home'
                    ? 50.0
                    : 0.0;

            //NOTE //!ORDER RESUMEN FOR PAYMENT INTENT
            orderService.sessionPaymentIntent!.orderResume = OrderResume(
              cupon: null,
              descount: totalDescountProducts,
              idCupon: null,
              quantityProducts: cartData.getQuantityProducts(),
              shipping: totalDelivery,
              total: totalProducts + totalDelivery,
              totalProducts: totalProducts,
            );

            //SECTION - //! STRIPE CHECKOUT
            if (serverStripeProvider.paymethod == 'card') {
              //NOTE //! CREATES THE CHECKOUT FOR STRIPE
              serverStripeProvider.sessionId =
                  await serverStripeProvider.createCheckout(
                amount: serverStripeProvider.amount!.toString(),
                type_paymethod: 'card',
              );

              debugPrint('session id: ${serverStripeProvider.sessionId!}');

              if (serverStripeProvider.sessionId != null) {
                bool resCheckout =
                    await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => CheckoutStripe(
                      sessionId: serverStripeProvider.sessionId ?? '',
                      paymethod: serverStripeProvider.paymethod ?? 'card'),
                ));

                if (resCheckout) {
                  orderService.sessionPaymentIntent!.status =
                      'pending_ship_paid_done';
                  res = await ordersProvider.createOrder();
                  if (res) {
                    final authFirebaseService = AuthFirebaseService();
                    await authFirebaseService.sendEmail(
                        address: getStringDirectionSelected(),
                        paymentDetail: serverStripeProvider.paymethod == 'card'
                            ? 'Pago con tarjeta de credito o debito'
                            : 'Pago en efectivo cuando se entregue mercancia',
                        totalPrice: orderService
                            .sessionPaymentIntent!.orderResume!.total!
                            .toDouble());
                    final bool resDelete = await cartData.deleteCartForUser();
                    if (resDelete) {
                      cartData.removeTotalPrice(cartData.getTotalPrice());
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OrderSuccessScreen()));
                    } else {
                      await onWillPop(
                          actions: [
                            DefaultButton(
                              text: 'Entendido',
                              press: () => Navigator.of(context).pop(false),
                            ),
                          ],
                          context: context,
                          icon: const Icon(Icons.error_outline,
                              color: primaryColorStrong),
                          titleAlert: 'Error en carrito',
                          txtContentAlert:
                              'Parece que los productos de tu carrito no estan disponibles por el momento, verifica e intenta nuevamente');
                    }
                  } else {
                    await onWillPop(
                        actions: [
                          DefaultButton(
                            text: 'Entendido',
                            press: () => Navigator.of(context).pop(false),
                          ),
                        ],
                        context: context,
                        icon: const Icon(Icons.error_outline,
                            color: primaryColorStrong),
                        titleAlert: 'Error al crear registro',
                        txtContentAlert:
                            'El pago ha sido procesado pero no hemos podido generar tu orden de compra. Contacta con soporte para mas información');
                  }
                } else {
                  await onWillPop(
                      actions: [
                        DefaultButton(
                          text: 'Entendido',
                          press: () => Navigator.of(context).pop(false),
                        ),
                      ],
                      context: context,
                      icon: const Icon(Icons.error_outline,
                          color: primaryColorStrong),
                      titleAlert: 'Ups! Transacción no finalizada',
                      txtContentAlert:
                          'Parece que no has terminado la transacción');
                }
              }
            } else if (serverStripeProvider.paymethod == 'cash') {
              orderService.sessionPaymentIntent!.status =
                  'pending_ship_not_paid';
              final bool resDelete = await cartData.deleteCartForUser();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const OrderSuccessScreen()));
              // CREAR ORDEN DE PAGO
              res = await ordersProvider.createOrder();
              if (res) {
                // EMAI
                final authFirebaseService = AuthFirebaseService();
                await authFirebaseService.sendEmail(
                    address: getStringDirectionSelected(),
                    paymentDetail: serverStripeProvider.paymethod == 'card'
                        ? 'Pago con tarjeta de credito o debito'
                        : 'Pago en efectivo cuando se entregue mercancia',
                    totalPrice: orderService
                        .sessionPaymentIntent!.orderResume!.total!
                        .toDouble());
                // ELIMINAR CARRO Y PRECIO
                final bool resDelete = await cartData.deleteCartForUser();
                if (resDelete) {
                  // cartData.getTotalPrice();
                  // cartData.removeTotalPrice(cartData.getTotalPrice());

                  setState(() {
                    cartData.totalPrice;
                  });
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OrderSuccessScreen()));
                } else {
                  await onWillPop(
                      actions: [
                        DefaultButton(
                          text: 'Entendido',
                          press: () => Navigator.of(context).pop(false),
                        ),
                      ],
                      context: context,
                      icon: const Icon(Icons.error_outline,
                          color: primaryColorStrong),
                      titleAlert: 'Error en carrito',
                      txtContentAlert:
                          'Parece que los productos de tu carrito no estan disponibles por el momento, verifica e intenta nuevamente');
                }
              } else {
                await onWillPop(
                    actions: [
                      DefaultButton(
                        text: 'Entendido',
                        press: () => Navigator.of(context).pop(false),
                      ),
                    ],
                    context: context,
                    icon: const Icon(Icons.error_outline,
                        color: primaryColorStrong),
                    titleAlert: 'Error en orden de pago',
                    txtContentAlert:
                        'Al intentar crear la orden de pago hubo un error, intenta nuevamente y si el problema persiste contacta con nuestro equipo de soporte');
              }
            } else {
              await onWillPop(
                  actions: [
                    DefaultButton(
                      text: 'Entendido',
                      press: () => Navigator.of(context).pop(false),
                    ),
                  ],
                  context: context,
                  icon: const Icon(Icons.error_outline,
                      color: primaryColorStrong),
                  titleAlert: 'Error en método de pago',
                  txtContentAlert: 'Selecciona un método de pago válido');
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
            backgroundColor: AppColor.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Flexible(
                flex: 12,
                child: Text(
                  'Hacer pedido',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: const SafeArea(child: Body()),
    );
  }

  String getStringDirectionSelected() {
    String res = '';

    if (orderService.sessionPaymentIntent!.direction!.street != null &&
        orderService.sessionPaymentIntent!.direction!.street != '') {
      res = '$res${orderService.sessionPaymentIntent!.direction!.street}';
    }

    if (orderService.sessionPaymentIntent!.direction!.numberExt != null &&
        orderService.sessionPaymentIntent!.direction!.numberExt! > -1) {
      res = '$res #${orderService.sessionPaymentIntent!.direction!.numberExt}';
    }

    if (orderService.sessionPaymentIntent!.direction!.numberInt != null &&
        orderService.sessionPaymentIntent!.direction!.numberInt! > -1) {
      res =
          '$res Int #${orderService.sessionPaymentIntent!.direction!.numberInt}';
    }

    if (orderService.sessionPaymentIntent!.direction!.neighborhood != null &&
        orderService.sessionPaymentIntent!.direction!.neighborhood != '') {
      res =
          '$res ${orderService.sessionPaymentIntent!.direction!.neighborhood}';
    }

    return res;
  }
}
