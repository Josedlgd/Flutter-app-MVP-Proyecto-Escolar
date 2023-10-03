import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PaymentDetails extends StatelessWidget {
  PaymentDetails(
      {super.key, required this.order_resume, required this.payment});
  OrderResume order_resume;
  Map<String, dynamic> payment;

  Map<String, dynamic> keysForPayment = {
    'complete': 'Completado',
    'pending_ship_not_paid': 'Por enviar y cobrar',
    'pending_ship_paid_done': 'Por enviar, pagado',
    'cancel': 'Cancelado'
  };

  Map<String, dynamic> keyPaymethods = {
    'card': 'Tarjeta crédito o débito',
    'cash': 'Efectivo',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          textDirection: TextDirection.ltr,
          children: [
            Expanded(
                flex: 6,
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: paddingHorizontal / 2,
                  children: [
                    const Icon(
                      Icons.add_card,
                      color: primaryColorStrong,
                    ),
                    Text(keyPaymethods[payment['type'].toString()],
                        textDirection: TextDirection.ltr),
                  ],
                )),
            Center(
              child: Text(keysForPayment[payment['status'].toString()],
                  textDirection: TextDirection.ltr),
            )
          ],
        ),
        Row(
          children: [
            const Expanded(
                child: Text(
              'Productos',
              style: txtStyleSubTitleBlack,
            )),
            Text(
              '\$ ${order_resume.totalProducts}',
              style: txtStyleBodyBlack,
            )
          ],
        ),
        Row(
          children: [
            const Expanded(
                child: Text(
              'Envío',
              style: txtStyleSubTitleBlack,
            )),
            Text(
              '\$ ${order_resume.shipping}',
              style: txtStyleBodyBlack,
            )
          ],
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Descuento',
                style: txtStyleSubTitleBlack,
              ),
            ),
            Text(
              '\$ ${order_resume.descount}',
              style: txtStyleBodyBlack,
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: paddingVertical / 2),
          child: Divider(
            color: primaryColor,
            height: paddingVertical * 2,
            thickness: 2.0,
          ),
        ),
        Row(
          children: [
            const Expanded(
                child: Text(
              'Total',
              style: txtStyleSubTitleBlack,
            )),
            Text(
              '\$ ${order_resume.total}',
              style: txtStyleBodyBlack,
            )
          ],
        ),
      ],
    );
  }
}
