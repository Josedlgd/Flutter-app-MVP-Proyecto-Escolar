import 'package:domas_ecommerce/components/components.dart';
import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Body extends StatefulWidget {
  const Body({
    super.key,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  ProductsService get productService => GetIt.instance<ProductsService>();

  late TabController tabController;

  List<ProductDB> _allProducts = [];

  List<ProductDB> get allProducts => _allProducts;

  set allProducts(List<ProductDB> value) {
    _allProducts = value;
  }

  List<ProductDB> _popularProducts = [];

  List<ProductDB> get popularProducts => _popularProducts;

  set popularProducts(List<ProductDB> value) {
    _popularProducts = value;
  }

  List<ExploreItem> listExploreItem = ExploreService.listExploreItem;
  List<ExploreUpdate> listExploreUpdateItem =
      ExploreService.listExploreUpdateItem;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  set errorMessage(String value) {
    _errorMessage = value;
  }

  Future<bool> _initList() async {
    if (await productService.loadProductsAvailable()) {
      allProducts = productService.productsAvailable;
    } else {
      errorMessage =
          'Los productos disponibles no han podido ser alcanzados por el sistema, intenta mas tarde.';
      return false;
    }
    if (await productService.loadProductsAvailableAndPopular()) {
      popularProducts = productService.productsAvailableAndPopular;
    } else {
      errorMessage =
          'Los productos populares no han podido ser alcanzados por el sistema, intenta mas tarde.';

      return false;
    }

    return true;
  }

  Widget buildWidgetResponse() {
    return IndexedStack(
      index: tabController.index,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(
              allProducts.length,
              (index) => ProductItemCard(
                product: allProducts[index],
              ),
            ),
          ),
        ),
        // Tab 2 - Explore
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(
              popularProducts.length,
              (index) => ProductItemCard(
                product: popularProducts[index],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Tabbbar
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          color: AppColor.secondary,
          child: TabBar(
            onTap: (index) {
              setState(() {
                tabController.index = index;
              });
            },
            controller: tabController,
            indicatorColor: AppColor.accent,
            indicatorWeight: 5,
            unselectedLabelColor: Colors.white.withOpacity(0.5),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            tabs: const [
              Tab(
                text: 'Todos',
              ),
              Tab(
                text: 'Populares',
              ),
            ],
          ),
        ),
        // Section 2 - Tab View
        FutureBuilder(
            future: _initList(),
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
                  if (snapshot.data == true) {
                    return buildWidgetResponse();
                  }
                  return const Center(
                    child: Text("Data Received, but is empty"),
                  );
                } else {
                  // Error screen
                  return Column(
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
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                // Future in progress
                return SizedBox(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    child: const LoadingOverlay());
              } else {
                return Text("State: ${snapshot.connectionState}");
              }
            }),
      ],
    );
  }
}
