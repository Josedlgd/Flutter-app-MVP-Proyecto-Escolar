import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Container(
      height: 190,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 26),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Encuentra lo mejor \npara tus mascotas.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      height: 150 / 100,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
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
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/icons/Bag.svg',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DummySearchWidget1(
            onTap: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
        ],
      ),
    );
  }
}
