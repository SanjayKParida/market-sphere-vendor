// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {
  final String productName;
  final int productPrice;
  final int quantity;
  final String description;
  final String category;
  final String vendorId;
  final String fullName;
  final String subCategory;
  final List<String> images;

  ProductModel(
      {required this.productName,
      required this.productPrice,
      required this.quantity,
      required this.description,
      required this.category,
      required this.vendorId,
      required this.fullName,
      required this.subCategory,
      required this.images});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'description': description,
      'category': category,
      'vendorId': vendorId,
      'fullName': fullName,
      'subCategory': subCategory,
      'images': images,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
        productName: map['productName'] as String,
        productPrice: map['productPrice'] as int,
        quantity: map['quantity'] as int,
        description: map['description'] as String,
        category: map['category'] as String,
        vendorId: map['vendorId'] as String,
        fullName: map['fullName'] as String,
        subCategory: map['subCategory'] as String,
        images: List<String>.from(
          (map['images'] as List<String>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}