// GridTile and GridTileBar
// creating multiple providers in itembuilder for each item (creating multiple "states")
// Using Consumer instead of Provider.of
// Using Scaffold.of()
import 'package:flutter/material.dart';
import "../providers/product_provider.dart";
import "package:provider/provider.dart";
import '../screens/product_detail_screen.dart';
import "../providers/cart.dart";

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // GridTile is a Widget that looks good as a child of GridView()
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          // Widget provided for GridTiles
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
              // Consumer<Product> basically acts as a listener, to specify that only this widget gets rebuilt when notifyListeners() is called
              // note that our Provider.of has a listen: false, so that not the entire sub tree gets rebuilt, but only this widget
              // child: Text("Any widget that is not dynamic")
              // Consumer() also accepts a child: which is any widget that is not dynamic, that we do not want to rebuilt, and that child widget can be referenced
              // in your builder method which has to accept a child, so everything except child gets rebuilt
              // you pass in child as third argument of builder = but now we pass in value "_" because we dont use it in builder")
              builder: (context, product, _) => IconButton(
                    // leading is positioned left, title middle and trailing to the right
                    icon: product.isFavourite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    // label: child, -- if we passed in child as third argument and use it in returned wiget, the child will not get rebuilt although everything else does
                    color: Theme.of(context).accentColor,
                    onPressed: product.toggleFavouriteStatus,
                  )),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              // if there is an existing snackbar being displayed, this will first hide it, so that in our next .showSnackBar() call pop up will be visible
              Scaffold.of(context).showSnackBar(
                // Recall .of(context) allows us to access the nearest Scaffold class which is in products_overview_screen
                // .showSnackBar is a method from Scaffold which allows us to display a info modal
                SnackBar(
                    content: Text(
                      "Added item to cart!",
                    ),
                    duration: Duration(
                      seconds: 3,
                    ),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    )),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
