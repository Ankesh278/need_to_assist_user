class UserModel {
  String name;
  String email;
  String address;
  String phoneNumber;

  UserModel({
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
