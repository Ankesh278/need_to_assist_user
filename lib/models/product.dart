class Product {
  final String id;
  final String productName;
  final String price;
  final String time;
  final String productImage;

  Product({
    required this.id,
    required this.productName,
    required this.price,
    required this.time,
    required this.productImage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      productName: json['name'].trim(),
      price: json['price'],
      time: json['time'],
      productImage: 'http://15.207.112.43:8080/${json['image']}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': productName,
      'price': price,
      'time': time,
      'image': productImage.replaceAll('http://15.207.112.43:8080/', ''),
    };
  }
}
