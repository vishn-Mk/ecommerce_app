import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../provider/cart_provider.dart';
import '../provider/favorite_provider.dart';
import '../services/api_services.dart';

import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _products;
  List<Product> _filteredProducts = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load favorites when HomeScreen initializes
    Provider.of<FavoritesProvider>(context, listen: false).loadFavoriteItems();

    _products = ApiService.fetchProducts();
    _products.then((value) {
      setState(() {
        _filteredProducts = value;
      });
    });
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = [];
      });
      return;
    }

    setState(() {
      _filteredProducts = _filteredProducts
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag, color: Colors.green),
            SizedBox(width: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Shop",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Change to your preferred color
                      fontSize: 25,
                    ),
                  ),
                  TextSpan(
                    text: "Easy",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red, // Change to your preferred color
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
        centerTitle: true, // Ensures the title stays centered
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search products",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                contentPadding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.black),
                  onPressed: () {
                    _searchController.clear();
                    _filterProducts('');
                  },
                )
                    : null,
              ),
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              onChanged: (query) {
                _filterProducts(query);
              },
            ),
          ),
        ),
      ),

      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load products"));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 4,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          product.thumbnail,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("\$${product.price}",
                                style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Consumer<FavoritesProvider>(
                              builder: (context, favoritesProvider, child) {
                                bool isFavorite =
                                    favoritesProvider.isFavorite(product.id);

                                return IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        isFavorite ? Colors.red : Colors.black,
                                  ),
                                  onPressed: () async {
                                    if (isFavorite) {
                                      await favoritesProvider
                                          .removeFromFavorites(product.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "${product.title} removed from Favorites",style: TextStyle(color: Colors.red),)),
                                      );
                                    } else {
                                      await favoritesProvider
                                          .addToFavorites(product);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "${product.title} added to Favorites",)),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await Provider.of<CartProvider>(context, listen: false)
                                      .addToCart(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("${product.title} added to Cart")),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                                ),
                                icon: Icon(Icons.add_shopping_cart, color: Colors.white,size: 15,),  // Cart Icon added
                                label: FittedBox(
                                  child: Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
