import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: AppColor.primary,
      elevation: 0,
      title: Row(
        children: [
          DummySearchWidget2(
            onTap: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
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
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
