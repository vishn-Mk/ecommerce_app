import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/db_helper.dart';

class FavoritesProvider with ChangeNotifier {
  List<Product> _favoriteItems = [];

  List<Product> get favoriteItems => _favoriteItems;

  // Load favorite items from the database and update UI
  Future<void> loadFavoriteItems() async {
    _favoriteItems = await DBHelper.getFavoriteItems();
    notifyListeners();
  }

  // Add product to favorites
  Future<void> addToFavorites(Product product) async {
    await DBHelper.markAsFavorite(product);
    _favoriteItems.add(product);
    notifyListeners();
  }

  // Remove product from favorites
  Future<void> removeFromFavorites(int productId) async {
    await DBHelper.removeFromFavorites(productId);
    _favoriteItems.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  // Check if a product is a favorite
  bool isFavorite(int productId) {
    return _favoriteItems.any((product) => product.id == productId);
  }
}
