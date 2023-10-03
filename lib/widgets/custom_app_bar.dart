import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../screens/screens.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.leftIcon,
    required this.rightIcon,
    required this.leftOnTap,
    required this.rightOnTap,
  });

  final String title;
  final void Function() rightOnTap, leftOnTap;
  final Widget rightIcon, leftIcon;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 54,
        margin: const EdgeInsets.only(top: 14),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ElevatedButton(
                onPressed: leftOnTap,
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: AppColor.primarySoft,
                  elevation: 0,
                  padding: const EdgeInsets.all(8),
                ),
                child: leftIcon,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 5.5 / 10,
              height: 40,
              decoration: BoxDecoration(
                  color: AppColor.primarySoft,
                  borderRadius: BorderRadius.circular(15)),
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            InkWell(
              onTap: () {
                if (cart.counter == 0) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EmptyCartScreen()));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CartScreen()));
                }
              },
              child: Center(
                child: badges.Badge(
                  showBadge: true,
                  badgeContent: Consumer<CartProvider>(
                    builder: (context, value, child) {
                      return Text(value.getCounter().toString(),
                          style: const TextStyle(color: Colors.white));
                    },
                  ),
                  badgeAnimation: const badges.BadgeAnimation.fade(),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColor.primarySoft,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/Bag.svg',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
