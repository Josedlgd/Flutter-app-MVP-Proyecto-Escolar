import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/home/components/discount_banner.dart';
import 'package:domas_ecommerce/screens/home/components/home_header.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'categories.dart';
import 'special_offers.dart';
import 'popular_product.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  CategoriesService get categoryService => GetIt.instance<CategoriesService>();
  ProductsService get productService => GetIt.instance<ProductsService>();

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  set errorMessage(String value) {
    _errorMessage = value;
  }

  _getDataToHomeScreen() async {
    if (!await categoryService.loadCategoriesAvailable()) {
      errorMessage =
          'Error al buscar categorías, por el momento no tenemos datos disponibles';
      return false;
    }

    if (!await productService.loadProductsAvailableAndLastAdded()) {
      errorMessage =
          'Error al buscar categorías, por el momento no tenemos datos disponibles';
      return false;
    }

    if (!await productService.loadProductsAvailableInOffer()) {
      errorMessage =
          'Error al buscar categorías, por el momento no tenemos datos disponibles';
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDataToHomeScreen(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Future resolved check if it has error
            if (snapshot.hasError) {
              // showErrorAlert(
              //     context, 'Error al acceder a mis, Intenta mas tarde');
              return const Center(
                child: Text("Error en extracción de información"),
              );
            } else if (snapshot.hasData) {
              //NOTE: isEmpty can only be used on Maps and Strings
              if (snapshot.data is bool && snapshot.data == true) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const HomeHeader(),
                      Categories(categoryData: categoryService.categories),
                      const SpecialOffers(),
                      PopularProducts(
                        popularProducts:
                            productService.productsLatestAddedAndAvailable,
                      ),
                      SizedBox(height: getProportionateScreenWidth(10)),
                    ],
                  ),
                );
              }
              return const Center(
                child: Text("Data Received, but is empty"),
              );
            } else {
              // Error screen
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Center(
                      child: CircularProgressIndicator(
                    color: primaryColorStrong,
                    strokeWidth: 10.0,
                    value: 1.0,
                  )),
                ],
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // Future in progress
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Center(
                      child: CircularProgressIndicator(
                    color: primaryColorStrong,
                    strokeWidth: 10.0,
                    value: 1.0,
                  )),
                ],
              ),
            );
          } else {
            return Text("State: ${snapshot.connectionState}");
          }
        });
  }
}
