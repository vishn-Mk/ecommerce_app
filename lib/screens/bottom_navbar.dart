import 'package:flutter/material.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/screens/favorite_screen.dart';
import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CartScreen(),
    FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home_outlined),
            title: Text("Home"),
            selectedColor: Colors.blue, // Customize selected color
            unselectedColor: Colors.black, // Customize unselected color
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            title: Text("Cart"),
            selectedColor: Colors.green,
            unselectedColor: Colors.black,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            title: Text("Favorites"),
            selectedColor: Colors.red,
            unselectedColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
