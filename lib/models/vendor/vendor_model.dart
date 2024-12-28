import 'dart:convert';

class VendorModel {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String role;
  final String password;
  VendorModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.role,
    required this.password,
  });

  //CONVERTING TO MAP TO EASILY CONVERT TO JSON IN ORDER TO SEND TO MONGODB
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'role': role,
      'password': password,
    };
  }

  //CONVERTING TO VENDOR MODEL TO USE IN OUR APPLICATION
  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      state: map['state'] as String,
      city: map['city'] as String,
      locality: map['locality'] as String,
      role: map['role'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());
}
