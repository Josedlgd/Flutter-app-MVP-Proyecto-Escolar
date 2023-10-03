import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToCartModal extends StatefulWidget {
  const AddToCartModal({super.key, required this.product});
  final ProductDB product;

  @override
  State<AddToCartModal> createState() => _AddToCartModalState();
}

class _AddToCartModalState extends State<AddToCartModal> {
  int _stockSelected = 0;

  int get stockSelected => _stockSelected;

  set stockSelected(int value) {
    _stockSelected = value;
  }

  @override
  void initState() {
    if (widget.product.stock != null && widget.product.stock! > 0) {
      stockSelected = 1;
    }
    // TODO: implement initState
    super.initState();
  }

  String calculatePrice() {
    num? totalProduct = widget.product.price;
    if (widget.product.descount != null) {
      if (widget.product.descountType == 'percent') {
        totalProduct = widget.product.price ??
            0.0 * ((100 - (widget.product.descount ?? 0.0)) / 100);
      } else {
        totalProduct =
            (widget.product.price ?? 0.0) - (widget.product.descount ?? 0.0);
      }
    }
    return (stockSelected * totalProduct!).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Container(
      height: 210,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 20),
      child: (widget.product.stock != null && widget.product.stock! > 0)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ----------
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColor.primarySoft,
                  ),
                ),
                // Section 1 - increment button
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 6),
                          child: Text(
                            widget.product.name!,
                            style: TextStyle(
                                color: const Color(0xFF0A0E2F).withOpacity(0.5),
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (stockSelected - 1 > 0) {
                                setState(() {
                                  stockSelected--;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColor.primary,
                              shape: const CircleBorder(),
                              backgroundColor: AppColor.border,
                              padding: const EdgeInsets.all(0),
                            ),
                            child: const Icon(Icons.remove,
                                size: 20, color: Colors.black),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              stockSelected.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (stockSelected + 1 <= widget.product.stock!) {
                                setState(() {
                                  stockSelected++;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColor.primary,
                              shape: const CircleBorder(),
                              backgroundColor: AppColor.border,
                              padding: const EdgeInsets.all(0),
                            ),
                            child: const Icon(Icons.add,
                                size: 20, color: Colors.black),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // Section 2 - Total and add to cart button
                if (stockSelected == widget.product.stock!)
                  Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const Text(
                        'Has llegado al máximo de stock',
                        style: TextStyle(color: Colors.red),
                      )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 18),
                  padding: const EdgeInsets.all(4),
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColor.primarySoft,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 7,
                        child: Container(
                          padding: const EdgeInsets.only(left: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Total',
                                  style: TextStyle(fontSize: 10)),
                              Text('\$${calculatePrice()}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: ElevatedButton(
                          onPressed: () {
                            if (stockSelected <= widget.product.stock!) {
                              // cart
                              //     .insert(Cart(
                              //         image: widget.product.images![0],
                              //         price:
                              //             double.parse(calculatePrice()),
                              //         productId: widget.product.id!,
                              //         productName: widget.product.name!,
                              //         productPrice:
                              //             double.parse(calculatePrice()),
                              //         quantity: stockSelected))
                              //     .then((value) {
                              //   cart.addCounter();
                              //   Navigator.pop(context);
                              //   NotificationsService.showSnackbar(
                              //       'Se ha agregado al carrito', sucessColor);
                              // }).onError((error, stackTrace) {
                              //   Navigator.pop(context);
                              //   NotificationsService.showSnackbar(
                              //       'Ya se ha agregado al carrito', errorColor);
                              // });
                              cart
                                  .insert(
                                Cart(
                                    image: widget.product.images![0],
                                    productPrice:
                                        double.parse(calculatePrice()),
                                    productId: widget.product.id!,
                                    productName: widget.product.name!,
                                    quantity: stockSelected,
                                    initialPrice:
                                        widget.product.price!.toDouble()),
                              )
                                  .then((value) {
                                cart.addTotalPrice(
                                  double.parse(calculatePrice()),
                                );
                                cart.addCounter();
                                Navigator.pop(context);
                                NotificationsService.showSnackbar(
                                    '¡Se ha agregado al carrito!', sucessColor);
                              }).onError((error, stackTrace) {
                                NotificationsService.showSnackbar(
                                    'Ya se ha agregado al carrito', errorColor);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Añadir al Carrito',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ----------
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColor.primarySoft,
                  ),
                ),

                Container(
                  height: SizeConfig.defaultSize,
                  width: SizeConfig.defaultSize,
                  margin: const EdgeInsets.symmetric(
                      vertical: paddingVertical, horizontal: paddingHorizontal),
                  child: const Center(
                      child: Text(
                          '¡Ups! Parece no haber mas productos por el momento ')),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Seguir comprando',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
