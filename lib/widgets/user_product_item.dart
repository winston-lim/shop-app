// backgroundImage property of listtile that works with ImageProvider
import "package:flutter/material.dart";
import "../screens/edit_product_screen.dart";
import "package:provider/provider.dart";
import "../providers/products_provider.dart";

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  UserProductItem(
      {@required this.imageUrl, @required this.title, @required this.id});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id,
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                  } catch (error) {
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          "Deleting failed!",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                color: Theme.of(context).errorColor)
          ],
        ),
      ),
    );
  }
}
