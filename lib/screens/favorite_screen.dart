import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/favorite_provider.dart';
import '../models/product_model.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey[50],
        title: Row(
          children: [
            Icon(Icons.favorite, color: Colors.green), // Added favorite icon
            SizedBox(width: 10),
            Text(
              "Favorites",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favoriteItems = favoritesProvider.favoriteItems;

          // Handle case when no favorites are added
          if (favoriteItems.isEmpty) {
            return Center(child: Text("No favorites added"));
          }

          return ListView.builder(
            itemCount: favoriteItems.length,
            itemBuilder: (context, index) {
              final product = favoriteItems[index];

              // Display each favorite product
              return Card(
                elevation: 50,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.black, width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Product Image
                      Image.network(
                        product.thumbnail,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "\$${product.price}",
                              style: TextStyle(fontSize: 14.0, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      // Delete Icon
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          // Remove from favorites
                          await favoritesProvider.removeFromFavorites(product.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
