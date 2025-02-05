import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'ecommerce.db');
    return openDatabase(
      path,
      version: 2,  // Increment the version if you change the schema
      onCreate: (db, version) {
        db.execute(''' 
        CREATE TABLE cart (
          id INTEGER PRIMARY KEY, 
          title TEXT, 
          price REAL, 
          thumbnail TEXT,
          quantity INTEGER
        )
      ''');
        db.execute(''' 
        CREATE TABLE favorites (
          id INTEGER PRIMARY KEY, 
          title TEXT, 
          price REAL, 
          thumbnail TEXT
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        // Handle schema changes if necessary
        if (oldVersion < 2) {
          // Example: Add new column or modify schema if needed
        }
      },
    );
  }



  static Future<void> addToCart(Product product) async {
    try {
      final db = await database;
      final existingProduct = await db.query(
        "cart",
        where: "id = ?",
        whereArgs: [product.id],
      );

      if (existingProduct.isEmpty) {
        await db.insert("cart", {
          "id": product.id,
          "title": product.title,
          "price": product.price,
          "thumbnail": product.thumbnail,
          "quantity": 1,
        });
      } else {
        await db.update(
          "cart",
          {"quantity": (existingProduct[0]['quantity'] as int) + 1},
          where: "id = ?",
          whereArgs: [product.id],
        );
      }
    } catch (e) {
      print("Error adding to cart: $e");  // Debugging line
    }
  }
  static Future<bool> isProductFavorite(int productId) async {
    final db = await database;

    // Query the favorites table to check if the product ID already exists
    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [productId],
    );

    return result.isNotEmpty;
  }

  static Future<void> markAsFavorite(Product product) async {
    try {
      final db = await database;
      await db.insert(
        'favorites',
        {
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'thumbnail': product.thumbnail,
        },
        conflictAlgorithm: ConflictAlgorithm.replace, // Ensures data is updated properly
      );
      print("Product marked as favorite: ${product.title}");
    } catch (e) {
      print("Error marking as favorite: $e");
    }
  }



  static Future<List<Product>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> items = await db.query("cart");

    // Print the length of items and the actual data
    print("Cart Items: ${items.length}");
    items.forEach((item) => print(item));

    return items.map((e) => Product.fromJson(e)).toList();
  }


  static Future<void> removeFromCart(int productId) async {
    final db = await database;
    await db.delete("cart", where: "id = ?", whereArgs: [productId]);
  }
  static Future<void> updateCartQuantity(int productId, int change) async {
    final db = await database;
    final List<Map<String, dynamic>> existingProduct = await db.query(
      "cart",
      where: "id = ?",
      whereArgs: [productId],
    );

    if (existingProduct.isNotEmpty) {
      int newQuantity = (existingProduct[0]['quantity'] as int) + change;

      if (newQuantity > 0) {
        await db.update(
          "cart",
          {"quantity": newQuantity},
          where: "id = ?",
          whereArgs: [productId],
        );
      } else {
        await db.delete("cart", where: "id = ?", whereArgs: [productId]);
      }
    }
  }



  static Future<List<Product>> getFavoriteItems() async {
    final db = await database;
    final List<Map<String, dynamic>> items = await db.query("favorites");
    return items.map((e) => Product.fromJson(e)).toList();
  }

  static Future<void> removeFromFavorites(int productId) async {
    final db = await database;
    await db.delete("favorites", where: "id = ?", whereArgs: [productId]);
  }
}
