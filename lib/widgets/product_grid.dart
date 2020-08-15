// ChangeNotifierProvider() vs ChangeNotifierProvider.value()
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import '../providers/product_provider.dart';
import "./product_item.dart";
import "../providers/products_provider.dart";

class ProductGrid extends StatelessWidget {
  final showFavouritesOnly;
  ProductGrid(this.showFavouritesOnly);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavouritesOnly ? productsData.favouriteItems : productsData.items;
    // Provider is a class from provider.dart, that allows us to build a direct communication between any widget in the tree with the provider instance
    // Recall .of(context) goes up the widget tree and looks for something, and we can specify what to look for by declaring <provider_class_name>
    // In this case it looks up the widget tree to find a Provider instance of the <Products> class up the tree, only to find it all the way up in MyApp
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (ctx) => products[i] --redundant as we decide to use .value,
        // recall that create needs to have a builder function that returns an instance of the Provider class
        // in this case, we have already instantiated all Provider<Product> classes in products_provider.item
        // we do not reinstantiate but simply return that instance which can be referenced here because of the variable products = productsData.items
        value: products[i],
        // Use ChangeNot
        // In this case, in our Products provider, we already intialized multiple Product providers, so we can provide them as values instant of creating new instances.
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // FixedCrossAxisCount defines a fixed number of columns(or items in a row)
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
