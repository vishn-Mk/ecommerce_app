import 'package:flutter/material.dart';


import '../models/product_model.dart';
import '../services/db_helper.dart';

class CartProvider with ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  // Load cart items from the database
  Future<void> loadCartItems() async {
    _cartItems = await DBHelper.getCartItems();
    notifyListeners();  // Notify listeners after loading the data
  }

  // Add to cart
  Future<void> addToCart(Product product) async {
    await DBHelper.addToCart(product);
    loadCartItems(); // Reload cart items after adding
    notifyListeners();  // Notify listeners
  }

  // Remove from cart
  Future<void> removeFromCart(int productId) async {
    await DBHelper.removeFromCart(productId);
    loadCartItems();  // Reload cart items after removing
    notifyListeners();  // Notify listeners
  }

  Future<void> increaseQuantity(int productId) async {
    await DBHelper.updateCartQuantity(productId, 1);
    loadCartItems();
  }
  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }


  Future<void> decreaseQuantity(int productId) async {
    await DBHelper.updateCartQuantity(productId, -1);
    loadCartItems();
  }
}

