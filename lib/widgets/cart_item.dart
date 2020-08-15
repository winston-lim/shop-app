// Dismissible() widget
// Dialog() widget
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/cart.dart";

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      // right to left swipe only
      confirmDismiss: (direction) {
        return showDialog(
          // show Dialog returns a Future when it is closed, and therefore can be used in confirmDismiss, which has to return a Future
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Are you sure?"),
            content: Text("Do you want to remove this item from cart?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                  // showDialog returns a Future, but confirmDismissed returns a Future<bool>.
                  // we can configure what showDialog returns, with Navigator.pop() as mentioned in the devdocs
                  // "Returns a [Future] that resolves to the value (if any) that was passed to [Navigator.pop] when the dialog was closed."
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(
          productId,
        );
      },
      child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          child: Padding(
            padding: EdgeInsets.all(3),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: FittedBox(child: Text("\$$price")),
                ),
              ),
              title: Text(title),
              subtitle: Text("Total: \$${price * quantity}"),
              trailing: Text("$quantity x"),
            ),
          )),
    );
  }
}
