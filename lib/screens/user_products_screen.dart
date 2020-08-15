import "package:flutter/material.dart";

import "package:provider/provider.dart";

import "../providers/products_provider.dart";
import '../widgets/user_product_item.dart';
import "../widgets/app_drawer.dart";
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/userProductScreen";
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, index) => Column(children: [
              UserProductItem(
                id: productsData.items[index].id,
                imageUrl: productsData.items[index].imageUrl,
                title: productsData.items[index].title,
              ),
              Divider(),
            ]),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
