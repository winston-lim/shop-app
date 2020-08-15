import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import "../providers/products_provider.dart";

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
      // listen is a property from the .of() method, that allows us to declare NOT to listen to any changes to the Products<Provider> instance
      // This means that this widget will not be rebuilt when notiferlisteners() is called.
    ).findById(productId);
    return Scaffold(
        appBar: AppBar(
          title: Text(loadedProduct.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover),
              ),
              SizedBox(
                height: 10,
              ),
              Text("\$${loadedProduct.price}"),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  "${loadedProduct.description}",
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              )
            ],
          ),
        ));
  }
}
