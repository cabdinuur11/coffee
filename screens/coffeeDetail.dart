import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_model.dart';

class CoffeeDetailScreen extends StatefulWidget {
  final String name;
  final String imagePath;
  final String price;

  CoffeeDetailScreen({required this.name, required this.imagePath, required this.price});

  @override
  _CoffeeDetailScreenState createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  int _selectedSizeIndex = 0;
  int _quantity = 1;
  double _basePrice = 0.0;
  double _totalPrice = 0.0;

  final List<double> _sizeMultipliers = [1.0, 1.2, 1.5]; // Small, Medium, Large

  @override
  void initState() {
    super.initState();
    _basePrice = double.parse(widget.price.replaceAll('\$', ''));
    _updateTotalPrice();
  }

  void _updateTotalPrice() {
    setState(() {
      _totalPrice = _basePrice * _sizeMultipliers[_selectedSizeIndex] * _quantity;
    });
  }

  void _onSizeSelected(int index) {
    setState(() {
      _selectedSizeIndex = index;
      _updateTotalPrice();
    });
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _updateTotalPrice();
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _updateTotalPrice();
      });
    }
  }

  void _addToCart(BuildContext context) {
    final cartModel = Get.find<CartModel>(); // Get the CartModel instance
    cartModel.addItem(
      CartItem(
        name: widget.name,
        imagePath: widget.imagePath,
        price: _totalPrice,
        quantity: _quantity,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity ${widget.name}(s) to cart!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            '\$${_totalPrice.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text('Select Size:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _sizeOption('Small', 0, context),
              _sizeOption('Medium', 1, context),
              _sizeOption('Large', 2, context),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: _decrementQuantity,
              ),
              Text(
                '$_quantity',
                style: TextStyle(fontSize: 24),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _incrementQuantity,
              ),
            ],
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => _addToCart(context),
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }

  Widget _sizeOption(String size, int index, BuildContext context) {
    return GestureDetector(
      onTap: () => _onSizeSelected(index),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _selectedSizeIndex == index ? Colors.blue : Colors.transparent,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: _selectedSizeIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}