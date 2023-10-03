import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:flutter/material.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:get_it/get_it.dart';

class ProductsScreen extends StatefulWidget {
  static String routeName = "/products";
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // final productsService = Provider.of<ProductsService>;
  ProductsService get productsService => GetIt.instance<ProductsService>();

  Widget buildWidgetResponse() {
    return RefreshIndicator(
      onRefresh: () async {
        productsService.products = await productsService.loadProducts();
        setState(() {});
      },
      child: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: ((context, index) => GestureDetector(
              onTap: () {
                productsService.init();
                productsService.product = productsService.products[index];
                productsService.setImages();
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const ProductScreen(),
                  ),
                );
              },
              child: ProductCard(
                product: productsService.products[index],
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de productos'),
        centerTitle: true,
      ),
      drawer: const SideMenu(),
      body: FutureBuilder(
          future:
              // productsService.getProductsByCategoryId(
              //     categoryID: 'hwNKxG7kUemTSN7MYaBQ'),
              productsService.loadProducts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Future resolved check if it has error
              if (snapshot.hasError) {
                // showErrorAlert(
                //     context, 'Error al acceder a mis, Intenta mas tarde');
                return const Center(
                  child: Text("Error in query, an irrupcion appears"),
                );
              } else if (snapshot.hasData) {
                //NOTE: isEmpty can only be used on Maps and Strings
                if (snapshot.data != null && snapshot.data is List) {
                  return buildWidgetResponse();
                }
                return const Center(
                  child: Text("Data Received, but is empty"),
                );
              } else {
                return const Center(
                  child: Text("Error Data"),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              // Future in progress
              return Center(child: CircularProgressIndicator());
            } else {
              return Text("State: ${snapshot.connectionState}");
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColorStrong,
        onPressed: () {
          initProduct();
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const ProductScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  initProduct() {
    setState(() {
      productsService.isLoading = true;
      productsService.isSaving = false;
      productsService.selectedPicture = null;
      productsService.selectedPictureForDetails = null;
      productsService.errorMessage = null;
      productsService.selectedPictures = [];
      productsService.selectedPicturesForDetails = [];
      productsService.labelsForDetails = [];
      productsService.product = ProductDB(
          name: '',
          description: '',
          id: '',
          isPopular: false,
          available: true,
          descountType: 'percent',
          descount: 0.0,
          price: 0.0,
          stock: 0,
          images: [],
          sections: [],
          categories: []);
    });
  }
}
