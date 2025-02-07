class ProfileModel {
  String name;
  String imageUrl;

  ProfileModel({required this.name, required this.imageUrl});

  // Convert ProfileModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  // Convert Firestore data to ProfileModel
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
