import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/screens/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            const Text('Tu Carrito',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            Text('Tus productos',
                style: TextStyle(
                    fontSize: 10, color: Colors.black.withOpacity(0.7))),
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
          onPressed: () {
            if (cartData.getTotalPrice() > 0.0) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CheckoutScreen()));
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                flex: 6,
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                width: 2,
                height: 26,
                color: Colors.white.withOpacity(0.5),
              ),
              if (cartData.getTotalPrice() > 0.0)
                Flexible(
                  flex: 6,
                  child: Text(
                    '\$${cartData.getTotalPrice()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              if (cartData.getTotalPrice() <= 0.0)
                const Flexible(
                  flex: 6,
                  child: Text(
                    'No tienes productos',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
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
}
