
  class Category {
  final String id;
  final String categoryName;
  final String categoryDesc;
  final String categoryImage;
  final String backgroundImage;

  Category({
  required this.id,
  required this.categoryName,
  required this.categoryDesc,
  required this.categoryImage,
  required this.backgroundImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
  return Category(
  id: json['_id'],
  categoryName: json['categoryName'].trim(), // Removes any trailing \n
  categoryDesc: json['categoryDesc'],
  categoryImage: 'http://15.207.112.43:8080/${json['categoryImage']}',  // Append base URL
  backgroundImage: 'http://15.207.112.43:8080/${json['backgroundImage']}',
  );
  }
  }
