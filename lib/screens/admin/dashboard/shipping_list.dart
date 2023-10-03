import 'package:domas_ecommerce/components/shipping_slidable.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:flutter/material.dart';

class ShippingList extends StatefulWidget {
  ShippingList({super.key, required this.salesToShip});
  List<PaymentIntent> salesToShip;
  @override
  State<ShippingList> createState() => _ShippingListState();
}

class _ShippingListState extends State<ShippingList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
        itemCount: widget.salesToShip.length,
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ShippingSlidable(orderToShow: widget.salesToShip[index]);
        },
      ),
    );
  }
}
