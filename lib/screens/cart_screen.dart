// Chip() widget
// Spacer() combined with mainAxisAlignment.spaceBetween
// Using "as _prefix" and  "show Class" when using two similarly named classes/widgets
// Map.values.toList() to apply indexing when using builder functions
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/cart.dart" show Cart;
// since we are not interested in the CartItem model, which is really just used to help define Cart(), we use show to only show Cart() from this import.
import "../widgets/cart_item.dart" as ci;
// prefixes CartItem class in this import with ci so we refer to it as ci.CartItem()
import "../providers/orders.dart";

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total", style: TextStyle(fontSize: 20)),
                  Spacer(),
                  // Takes up all the avaible space for itself, forcing Chip() and FlatButton to the right
                  Chip(
                    label: Text("\$${cart.totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color)),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text("ORDER NOW"),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.clearCart();
                    },
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              // Recall ListView()s cannot be direct children of Columns, since Columns allow for infinite height, and ListView takes up all height it can take
              // The simple solution is to wrap ListView in Expanded() which ensures ListView takes up as much space as is left VS as much space as possible
              child: ListView.builder(
            itemBuilder: (context, index) => ci.CartItem(
              id: cart.items.values.toList()[index].id,
              // cart.items returns a map
              // cart.items.values returns CartItems
              // cart.items.values.toList() returns a list of CartItems
              productId: cart.items.keys.toList()[index],
              title: cart.items.values.toList()[index].title,
              quantity: cart.items.values.toList()[index].quantity,
              price: cart.items.values.toList()[index].price,
            ),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}
