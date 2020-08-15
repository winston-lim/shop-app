// Attaching Provider to root widget by using ChangeNotifierProvider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import "./providers/products_provider.dart";
import "./providers/cart.dart";
import "./screens/cart_screen.dart";
import "./providers/orders.dart";
import "./screens/orders_screen.dart";
import "./screens/user_products_screen.dart";
import "./screens/edit_product_screen.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            // We wrap your material app with provider, and one of the more common one is ChangeNotifierProvider()
            // By wrapping it with a provider, you attach the provider to MaterialApp
            // By attaching the provider to Material App, any of its children can listen to the provider now
            create: (ctx) => Products()),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(create: (ctx) => Orders())
      ],
      // create provides an instace of Products(), which is the data provider
      // so this instance is provided for all children of MaterialApp who wish to listen to the instance of the class
      // so whenever we change something in Products(), children who are listenting to it will be rebuilt
      child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          initialRoute: "/",
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          }),
    );
  }
}
