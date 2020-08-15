import "dart:convert";
import "package:http/http.dart" as http;
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  // We change our Product from just a model to a DATA provider by adding "with ChangeNotifier" so that we can notifylisteners() when a property changes
  // in this case, the property of relevance is isFavourite. When someone favourites an item, we want to rebuild widgets that render the Product class
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });
  Future<void> toggleFavouriteStatus() async {
    var url =
        "https://flutter-shop-app-a81ac.firebaseio.com/products/$id/.json";
    try {
      http.patch(url, body: json.encode({"isFavourite": !isFavourite}));
    } catch (error) {
      throw error;
    }
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
