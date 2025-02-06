import 'package:coffeee/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:coffeee/screens/cart_model.dart'; // Import CartModel
import './authentications/login.dart';
import './authentications/signup.dart';

void main() {
  Get.put(CartModel()); // Register CartModel with GetX
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Coffee App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // LoginScreen is the default screen
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
      },
    );
  }
}