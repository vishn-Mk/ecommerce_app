class Product {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  int quantity; // For cart

  Product({required this.id, required this.title, required this.price, required this.thumbnail, this.quantity = 1});

  // Adjust this method based on the data structure in the DB
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      thumbnail: json['thumbnail'],
      quantity: json['quantity'] ?? 1, // Use quantity from cart
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'thumbnail': thumbnail,
      'quantity': quantity,
    };
  }
}
