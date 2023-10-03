import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/home/home_screen.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  PaymentIntentsService get ordersService =>
      GetIt.instance<PaymentIntentsService>();

  Map<String, List<PaymentIntent>> _orderList = {};

  Map<String, List<PaymentIntent>> get orderList => _orderList;

  set orderList(Map<String, List<PaymentIntent>> value) {
    _orderList = value;
  }

  buildWidgetResponse({required List<OrderUser>? orderList}) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, bottom: 8),
                child: Text(
                  'Tus pedidos',
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.5),
                      letterSpacing: 6 / 100,
                      fontWeight: FontWeight.w600),
                ),
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  return OrderTile(
                    data: orderList[index],
                    onTap: () {},
                  );
                },
                itemCount: orderList!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<OrderUser> listNotification = OrderUserService.listNotification;

    return FutureBuilder(
        future: ordersService.loadUserOrders(),
        builder: (context, snapshot) {
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
              if (snapshot.data!.isNotEmpty) {
                return buildWidgetResponse(orderList: snapshot.data);
              } else {
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
                      Text('Tu registro de compras se encuentra vacío 😌',
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
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColor.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          backgroundColor: AppColor.border,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text(
                          'Regresar al inicio',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColor.secondary),
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return const Center(
                child: Text("Data Received, but is empty"),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // Future in progress
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColorStrong,
                strokeWidth: 5.0,
              ),
            );
          } else {
            return Text("State: ${snapshot.connectionState}");
          }
        });
  }
}
