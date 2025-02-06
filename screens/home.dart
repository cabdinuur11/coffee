import 'package:flutter/material.dart';
import '../authentications/login.dart';
import 'cart.dart';
import 'coffeeDetail.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0; // Track the selected index for the bottom navigation bar

  // Coffee data with images
  final List<Map<String, String>> recommendations = [
    {'name': 'Espresso', 'price': '\$3.00', 'image': 'lib/assets/images/espresso.png'},
    {'name': 'Latte', 'price': '\$4.00', 'image': 'lib/assets/images/latte.png'},
    {'name': 'Cold Brew', 'price': '\$4.50', 'image': 'lib/assets/images/Cold_coffe.png'},
    {'name': 'Mocha', 'price': '\$4.00', 'image': 'lib/assets/images/mocha.png'},
  ];

  final List<Map<String, String>> morningCoffees = [
    {'name': 'Americano', 'price': '\$3.50', 'image': 'lib/assets/images/americano.png'},
    {'name': 'Cappuccino', 'price': '\$4.00', 'image': 'lib/assets/images/cappuccino.png'},
    {'name': 'Flat White', 'price': '\$4.50', 'image': 'lib/assets/images/flat_white.png'},
    {'name': 'Macchiato', 'price': '\$4.00', 'image': 'lib/assets/images/machiato.png'},
  ];

  final List<Map<String, String>> nightCoffees = [
    {'name': 'Decaf Coffee', 'price': '\$3.00', 'image': 'lib/assets/images/Decaf.png'},
    {'name': 'Herbal Coffee', 'price': '\$3.50', 'image': 'lib/assets/images/herbal.png'},
    {'name': 'Honey Latte', 'price': '\$4.00', 'image': 'lib/assets/images/honey.png'},
    {'name': 'Turmeric Latte', 'price': '\$4.50', 'image': 'lib/assets/images/turmeric.png'},
  ];

  List<Map<String, String>> filteredCoffeeList = [];

  @override
  void initState() {
    super.initState();
    filteredCoffeeList = [...recommendations, ...morningCoffees, ...nightCoffees];
  }

  void _filterCoffeeList(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCoffeeList = [...recommendations, ...morningCoffees, ...nightCoffees];
      });
    } else {
      setState(() {
        filteredCoffeeList = [
          ...recommendations.where((coffee) => coffee['name']!.toLowerCase().contains(query.toLowerCase())),
          ...morningCoffees.where((coffee) => coffee['name']!.toLowerCase().contains(query.toLowerCase())),
          ...nightCoffees.where((coffee) => coffee['name']!.toLowerCase().contains(query.toLowerCase())),
        ];
      });
    }
  }

  // Handle bottom navigation bar item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Home screen is already displayed
        break;
      case 1:
        // Navigate to Cart screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartScreen()),
        );
        break;
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
                  (route) => false, // Remove all previous routes
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filterCoffeeList('');
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.logout), // Logout icon
            onPressed: _logout, // Call logout function
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (_isSearching) {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              _filterCoffeeList('');
            });
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_isSearching)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterCoffeeList,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              _buildSectionTitle('Recommendations'),
              _buildCoffeeCardGrid(filteredCoffeeList),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Current selected index
        onTap: _onItemTapped, // Handle item selection
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCoffeeCardGrid(List<Map<String, String>> coffeeList) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
      ),
      itemCount: coffeeList.length,
      itemBuilder: (context, index) {
        return _buildCoffeeCard(coffeeList[index]['name']!, coffeeList[index]['price']!, coffeeList[index]['image']!);
      },
    );
  }

  Widget _buildCoffeeCard(String name, String price, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoffeeDetailScreen(
              name: name,
              imagePath: imagePath,
              price: price,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(price),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}