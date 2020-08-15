// methods from Map, .containsKey, .putIfAbsent, .update
import "package:provider/provider.dart";
import "package:flutter/foundation.dart";

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
// PRODUCTID AND ID IS DIFFERENT. PRODUCTID IS ID OF SPECIFIC PRODUCT, ID REFERS TO ID OF CART ITEM.
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double currentTotal = 0.0;
    _items.forEach((key, value) {
      currentTotal += value.price * value.quantity;
    });
    return currentTotal;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          // Update updates values for a certain key value in the map.
          productId,
          (existingItem) => CartItem(
              id: existingItem.id,
              price: existingItem.price,
              quantity: existingItem.quantity + 1,
              title: existingItem.title));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingItem) => CartItem(
              id: existingItem.id,
              price: existingItem.price,
              quantity: existingItem.quantity - 1,
              title: existingItem.title));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
