// Mixins
// HTTP Post request from http.dart package, json.encode() and .decode() from dart:convert library
// optimistic udpating
// status codes
import "dart:convert";

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import "../models/http_exception.dart";
import 'product_provider.dart';

class Products with ChangeNotifier {
  // Mixins is abit like extending, the main difference is instead of inheriting, you are merging
  // ChangeNotifier is related to the InheritedWidget, and helps establish a way for this provider class and other classes/widgets
  // Not that any data within this class should only be changed within this class and not in widgets/classes that use the data
  // This is so that when data is changed, notifyListeners() is called to update all widgets in the tree that use this data.
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  List<Product> get items {
    // This is why, we have to return a copy of the list as a getter, so that classes that use this data do not directly edit the list, but a copy of it.
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavourite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url = "https://flutter-shop-app-a81ac.firebaseio.com/products.json";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(
          Product(
              id: productId,
              title: productData["title"],
              price: productData["price"],
              imageUrl: productData["imageUrl"],
              description: productData["description"],
              isFavourite: productData["isFavourite"]),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    // .get() fetches data, and requires no extra configurations unlike .post()
  }

  Future<void> addProduct(Product product) async {
    // the async keyword automatically wraps all code in the function and returns it as a Future object
    const url = "https://flutter-shop-app-a81ac.firebaseio.com/products.json";
    try {
      // try clause works with the catch clause.
      // If any error occurs in body of code in {try} then the {catch} clause is executed, with error being what is returned from the {try} clause
      final response = await http.post(
        // await works with async to turn asynchronous("skipped" first and executed finish later on) code into a form that seems synchronous(executed line by line downwards)
        // await (code) indicates that this code should execute finish first before any other code is executed
        // the body of code that comes after the await block is invisibly wrapped in a .then() method behind the scenes to support {await}
        url,
        body: json.encode(
          {
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "isFavourite": product.isFavourite,
          },
        ),
      );
      // stores local product data
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)["id"],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      // catch is followed by an identifier which is what is returned in the {try} clause
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url =
          "https://flutter-shop-app-a81ac.firebaseio.com/products/$id/.json";
      await http.patch(url,
          body: json.encode({
            "title": updatedProduct.title,
            "description": updatedProduct.description,
            "imageUrl": updatedProduct.imageUrl,
            "price": updatedProduct.price,
          }));
      _items[productIndex] = updatedProduct;
      notifyListeners();
    } else {
      print("...");
    }
    notifyListeners();
  }

  // shows optimisting updating, where we re-add an element in the event of an error in deleting it
  Future<void> deleteProduct(String id) async {
    final url =
        "https://flutter-shop-app-a81ac.firebaseio.com/products/$id/.json";
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    // we store the existing product index and data into a variable so that it does not get lost from memory
    // we can then refer to it again when an error is thrown in .catchError()
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      // by default for most http requests, if the statusCode returned is greater than 400, an error is thrown.
      // For .delete() an error is not automatically thrown, so we must throw our our error with an Exception widget
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
    existingProduct = null;
  }
}
