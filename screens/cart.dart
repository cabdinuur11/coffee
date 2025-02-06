import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartModel cartModel = Get.find(); // Get the CartModel instance

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Obx(() => cartModel.items.isEmpty
          ? Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartModel.items.length,
                    itemBuilder: (context, index) {
                      final item = cartModel.items[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.asset(
                            item.imagePath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item.name),
                          subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  item.isOrdered ? Icons.cancel : Icons.add_shopping_cart,
                                  color: item.isOrdered ? Colors.red : Colors.green,
                                ),
                                onPressed: () {
                                  _showOrderOptions(context, item);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmation(context, index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total Ordered Price: \$${cartModel.totalOrderedPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0), // Add some spacing
                      ElevatedButton(
                        onPressed: () {
                          _showCheckoutConfirmation(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Green background
                          foregroundColor: Colors.white, // White text
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0), // Button padding
                        ),
                        child: Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            )),
    );
  }

  void _showOrderOptions(BuildContext context, CartItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.isOrdered ? 'Cancel Order' : 'Order Now'),
          content: Text(item.isOrdered
              ? 'Are you sure you want to cancel the order for ${item.name}?'
              : 'Do you want to order ${item.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final cartModel = Get.find<CartModel>(); // Get the CartModel instance
                if (item.isOrdered) {
                  // Cancel the order
                  item.isOrdered = false;
                } else {
                  // Place the order
                  item.isOrdered = true;
                }
                cartModel.items.refresh(); // Refresh the observable list
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(item.isOrdered ? 'Cancel Order' : 'Order Now'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final cartModel = Get.find<CartModel>(); // Get the CartModel instance
                cartModel.removeItem(index);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Checkout'),
          content: Text('Your order has been placed and will be delivered soon.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}