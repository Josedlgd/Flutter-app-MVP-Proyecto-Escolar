import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {
  final Cart data;
  const CartTile({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 115,
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/jar-loading.gif'),
                    image: NetworkImage(data.image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.productName!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColor.secondary),
                        ),
                        InkWell(
                            onTap: () {
                              cart
                                  .delete(productId: data.productId!)
                                  .then((value) {
                                NotificationsService.showSnackbar(
                                    'Se eliminó del carrito', warningColor);
                              });
                              cart.removeCartItem(
                                  double.parse(data.productPrice.toString()));
                              // cart.removerCounter();
                              // cart.removeTotalPrice(
                              //     double.parse(data.productPrice.toString()));
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 206, 14, 0),
                            ))
                      ],
                    ),
                    Text(
                      "1x\$${data.initialPrice}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: AppColor.primary),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "\$${data.productPrice}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: AppColor.primary),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 39,
                          width: 95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColor.primarySoft,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    int quantity = data.quantity!;
                                    num price = data.initialPrice!;
                                    quantity--;
                                    num? newPrice = price * quantity;

                                    if (quantity > 0) {
                                      // cart.lessProduct(data.productId!,
                                      //         quantity, newPrice, double.parse(
                                      //       data.initialPrice.toString()))
                                      cart
                                          .updateQuantity(data.productId!,
                                              quantity, newPrice, )
                                          .then((value) {
                                        newPrice = 0;
                                        quantity = 0;
                                        cart.removeTotalPrice(double.parse(
                                            data.initialPrice.toString()));
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColor.primarySoft,
                                    ),
                                    child: const Text(
                                      '-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      data.quantity.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    int quantity = data.quantity!;
                                    num price = data.initialPrice!;
                                    quantity++;
                                    num? newPrice = price * quantity;

                                    cart
                                        .updateQuantity(
                                            data.productId!, quantity, newPrice)
                                        .then((value) {
                                      newPrice = 0;
                                      quantity = 0;
                                      cart.addTotalPrice(double.parse(
                                          data.initialPrice.toString()));
                                    });
                                    
                                  },
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColor.primarySoft,
                                    ),
                                    child: const Text(
                                      '+',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
