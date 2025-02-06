import 'package:get/get.dart';

class CartItem {
  final String name;
  final String imagePath;
  final double price;
  final int quantity;
  bool isOrdered;

  CartItem({
    required this.name,
    required this.imagePath,
    required this.price,
    this.quantity = 1,
    this.isOrdered = false,
  });
}

class CartModel extends GetxController {
  var items = <CartItem>[].obs; // Observable list of CartItem

  void addItem(CartItem item) {
    items.add(item);
  }

  void removeItem(int index) {
    items.removeAt(index);
  }

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get totalOrderedPrice {
    return items
        .where((item) => item.isOrdered)
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}