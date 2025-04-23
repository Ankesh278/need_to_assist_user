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
      categoryName: json['categoryName'].trim(),
      categoryDesc: json['categoryDesc'],
      categoryImage: 'http://needtoassist.com/${json['categoryImage']}',
      backgroundImage: 'http://needtoassist.com/${json['backgroundImage']}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'categoryName': categoryName,
      'categoryDesc': categoryDesc,
      'categoryImage': categoryImage.replaceAll('http://needtoassist.com/', ''),
      'backgroundImage': backgroundImage.replaceAll('http://needtoassist.com/', ''),
    };
  }
}
