import 'dart:convert';
import 'package:http/http.dart' as http;

class UserController {
  static const String baseUrl = "https://flutter-test-server.onrender.com";

  // Register a new user
  static Future<bool> registerUser(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/api/users/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return true; // Registration successful
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // Login a user
  static Future<bool> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return true; // Login successful
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }
}