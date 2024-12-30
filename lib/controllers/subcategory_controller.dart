import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:market_sphere_vendor/core/constants.dart';

import '../models/subcategory/subcategory_model.dart';

class SubcategoryController {
  Future<List<SubcategoryModel>> getSubcategoriesByCategoryName(
      String categoryName) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$URI/api/categories/$categoryName/subcategories'),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        if (decodedJson.containsKey('subcategories')) {
          final List<dynamic> data = decodedJson['subcategories'];
          return data
              .map((subcategory) => SubcategoryModel.fromJson(subcategory))
              .toList();
        } else {
          print("Subcategories key not found in response");
          return [];
        }
      } else if (response.statusCode == 404) {
        print("subcategories not found");
        return [];
      } else {
        print("failed to fetch categories");
        return [];
      }
    } catch (e) {
      print("Error : $e");
      return [];
    }
  }
}
