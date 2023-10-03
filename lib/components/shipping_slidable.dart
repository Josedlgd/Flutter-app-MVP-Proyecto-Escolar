import 'package:domas_ecommerce/components/components.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/controllers/index.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/admin/dashboard/dashboard_screen.dart';
import 'package:domas_ecommerce/screens/admin/sales/sales_details.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class ShippingSlidable extends StatefulWidget {
  ShippingSlidable({super.key, required this.orderToShow});
  PaymentIntent orderToShow;
  @override
  State<ShippingSlidable> createState() => _ShippingSlidableState(orderToShow);
}

class _ShippingSlidableState extends State<ShippingSlidable> {
  _ShippingSlidableState(this._orderToShow);
  PaymentIntent _orderToShow;

  PaymentIntent get orderToShow => _orderToShow;

  set orderToShow(PaymentIntent value) {
    _orderToShow = value;
  }

  PaymentIntentsService get ordersService =>
      GetIt.instance<PaymentIntentsService>();

  @override
  Widget build(BuildContext context) {
    return Slidable(
        enabled: true,
        closeOnScroll: false,
        key: const ValueKey(1),
        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        tooltip: 'Detalles',
                        onPressed: () {
                          debugPrint(DateFormat.yMMMd().format(DateTime.now()));
                          debugPrint('Acceder a detalles de venta');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SaleDetails(
                                      title: 'Detalles de venta',
                                      orderToShow: widget.orderToShow,
                                    )),
                          );
                        },
                        icon: const Icon(
                          Icons.info_outlined,
                          color: primaryColorStrong,
                        )),
                    const Text('Detalles',
                        style: txtStyleBodyPrimaryColorStrong,
                        overflow: TextOverflow.ellipsis)
                  ],
                ),
              ),
            ),
            if (orderToShow.status != 'complete')
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () async {
                            await onWillPop(
                                actions: [
                                  DefaultButton(
                                      text: 'Si, cancelar',
                                      press: () async {
                                        if (await ordersService
                                            .changeStatusOrder(
                                                id: orderToShow.id!,
                                                newStatus: 'cancel')) {
                                          Navigator.of(context).pop(false);
                                          buildSnackBarToState(
                                              txtBody:
                                                  '¡Éxito! pedido CANCELADO',
                                              context: context);
                                        }
                                      }),
                                  DefaultButton(
                                    text: 'No, conservar',
                                    press: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                ],
                                context: context,
                                icon: const Icon(Icons.warning,
                                    color: primaryColorStrong),
                                titleAlert: 'Cancelar pedido',
                                txtContentAlert:
                                    '¿Estás seguro de marcar como CANCELADO el pedido? Le comunicaremos al usuario de su cancelación');
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: primaryColorStrong,
                          )),
                      const Text('Cancelar',
                          style: txtStyleBodyPrimaryColorStrong,
                          overflow: TextOverflow.ellipsis)
                    ],
                  ),
                ),
              ),
            if (orderToShow.status != 'complete')
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () async {
                            await onWillPop(
                                actions: [
                                  DefaultButton(
                                      text: 'Si, completar',
                                      press: () async {
                                        if (await ordersService
                                            .changeStatusOrder(
                                                id: orderToShow.id!,
                                                newStatus: 'complete')) {
                                          Navigator.of(context).pop(false);
                                          buildSnackBarToState(
                                              txtBody:
                                                  '¡Éxito! Al COMPLETAR pedido',
                                              context: context);
                                        }
                                      }),
                                  DefaultButton(
                                    text: 'No, conservar',
                                    press: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                ],
                                context: context,
                                icon: const Icon(Icons.warning,
                                    color: primaryColorStrong),
                                titleAlert: 'Completar pedido',
                                txtContentAlert:
                                    '¿Estás seguro de marcar como COMPLETADO el pedido? Le comunicaremos al usuario');
                          },
                          icon: const Icon(
                            Icons.done_rounded,
                            color: primaryColorStrong,
                          )),
                      const Text('Completar',
                          style: txtStyleBodyPrimaryColorStrong,
                          overflow: TextOverflow.ellipsis)
                    ],
                  ),
                ),
              ),
          ],
        ),
        child: SizedBox(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight / 5,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: paddingHorizontal, vertical: paddingVertical),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Center(
                                    child: Text(
                                      'Entrega: ',
                                      style: txtStyleSubTitleBlack,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                  child: Text(
                                    '${orderToShow.toJson()['shipping_type']}',
                                    style: txtStyleBodyBlack,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                              ],
                            )),
                        Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Center(
                                    child: Text(
                                      'A partir de:',
                                      style: txtStyleSubTitleBlack,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                  child: Text(
                                    '${orderToShow.schedule!.hour} : ${orderToShow.schedule!.minute!}',
                                    style: txtStyleBodyBlack,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                              ],
                            )),
                        Expanded(
                            flex: 4,
                            child: Center(
                              child: Text(
                                orderToShow.details!.name.toString(),
                                style: txtStyleBodyGrayStrong,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Center(
                                      child: Text(
                                    'Total: ',
                                    style: txtStyleBodyBlackStrong,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                ),
                                Expanded(
                                  child: Center(
                                      child: Text(
                                    '\$${orderToShow.orderResume!.total!}',
                                    style: txtStyleBodyBlack,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                ),
                              ],
                            )),
                        if (orderToShow.toJson()['order_resume']['descount'] >
                            0)
                          Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Center(
                                        child: Text(
                                      'Descuento: ',
                                      style: txtStyleBodyBlackStrong,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                  ),
                                  Expanded(
                                    child: Center(
                                        child: Text(
                                      '\$${orderToShow.orderResume!.descount!}',
                                      style: txtStyleBodyBlack,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                  ),
                                ],
                              )),
                        Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Center(
                                      child: Text(
                                    'Productos: ',
                                    style: txtStyleBodyBlackStrong,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                ),
                                Expanded(
                                  child: Center(
                                      child: Text(
                                    '${orderToShow.orderResume!.quantityProducts!}',
                                    style: txtStyleBodyBlack,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Center(
                          child: IconButton(
                              onPressed: () {
                                //navigate other route
                                debugPrint('redireccionar a detalles de venta');
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: primaryColorStrong,
                              ))))
                ],
              ),
            ),
          ),
        ));
  }
}
