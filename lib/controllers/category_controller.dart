import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:market_sphere_vendor/core/constants.dart';

import '../../models/category/category_model.dart';

class CategoryController {
  //LOAD THE UPLOADED CATEGORIES
  Future<List<CategoryModel>> loadCategories() async {
    try {
      http.Response response = await http.get(Uri.parse('$URI/api/categories'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<CategoryModel> categoryList = data
            .map(
              (category) => CategoryModel.fromJson(category),
            )
            .toList();
        return categoryList;
      } else {
        throw Exception("Failed to load Categories");
      }
    } catch (e) {
      throw Exception('Error : $e');
    }
  }
}
