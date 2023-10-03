import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
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
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
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
                  } else {
                    return Expanded(
                      child: ListView.separated(
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            return CartTile(
                              data: snapshot.data![index],
                            );
                          }),
                    );
                  }
                }
                return const Text('');
              }),
        ],
      ),
    );
  }
}
