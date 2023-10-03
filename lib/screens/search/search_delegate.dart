import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Busca un producto';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    } else {
      final productsProvider =
          Provider.of<ProductsService>(context, listen: false);

      return FutureBuilder(
        future: productsProvider.searchProducts(query),
        builder: ((_, AsyncSnapshot<List<ProductDB>> snapshot) {
          if (!snapshot.hasData) {
            return _emptyContainer();
          } else {
            final products = snapshot.data!;
            return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) => _ProductItem(
                      product: products[index],
                    ));
          }
        }),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    } else {
      final productsProvider =
          Provider.of<ProductsService>(context, listen: false);

      return FutureBuilder(
        future: productsProvider.searchProducts(query),
        builder: ((_, AsyncSnapshot<List<ProductDB>> snapshot) {
          if (!snapshot.hasData) {
            return _emptyContainer();
          } else {
            final products = snapshot.data!;
            return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) => _ProductItem(
                      product: products[index],
                    ));
          }
        }),
      );
    }
  }

  Widget _emptyContainer() {
    return const Center(
      child: Icon(
        Icons.search_off_rounded,
        color: Colors.black38,
        size: 130,
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final ProductDB product;

  const _ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FadeInImage(
        placeholder: const AssetImage('assets/no-image.png'),
        image: NetworkImage(product.images![0]),
        width: 50,
        fit: BoxFit.contain,
      ),
      title: Text(product.name ?? 'No name'),
      subtitle: Text(product.description),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SingleProductScreen(product: product)));
      },
    );
  }
}
