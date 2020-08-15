// GridView.builder, GridTile
// PopupMenuButtton and PopupMenuItem
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import "../widgets/product_grid.dart";
import "../widgets/badge.dart";
import "../providers/cart.dart";
import "../providers/products_provider.dart";
import "../screens/cart_screen.dart";

enum Filters { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = "/";
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool showFavouritesOnly = false;
  bool _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text("Show Favourites"), value: Filters.Favourites),
              PopupMenuItem(child: Text("Show All"), value: Filters.All),
            ],
            onSelected: (Filters selectedValue) {
              setState(() {
                if (selectedValue == Filters.All) {
                  showFavouritesOnly = false;
                } else {
                  showFavouritesOnly = true;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
        title: Text('MyShop'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(showFavouritesOnly),
    );
  }
}
