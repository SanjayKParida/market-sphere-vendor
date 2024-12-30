import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:market_sphere_vendor/models/product/product_model.dart';
import 'package:market_sphere_vendor/services/manage_http_response.dart';
import 'package:market_sphere_vendor/services/snackbar_service.dart';

import '../core/constants.dart';

class ProductController {
  Future<void> uploadProduct(
      {required String productName,
      required int productPrice,
      required int quantity,
      required String description,
      required String category,
      required String vendorId,
      required String fullName,
      required String subCategory,
      required List<File>? pickedImages,
      required context}) async {
    if (pickedImages != null) {
      final cloudinary =
          CloudinaryPublic("dclpagbgi", "market_sphere_cloudinary");

      List<String> images = [];

      //LOOP THROUGH EACH IMAGE IN PICKED IMAGES
      for (var i in pickedImages) {
        CloudinaryResponse imageResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(i.path, folder: productName),
        );

        //ADD THE SECURE URL
        images.add(imageResponse.secureUrl);
      }

      if (category.isNotEmpty && subCategory.isNotEmpty) {
        final ProductModel product = ProductModel(
          productName: productName,
          productPrice: productPrice,
          quantity: quantity,
          description: description,
          category: category,
          vendorId: vendorId,
          fullName: fullName,
          subCategory: subCategory,
          images: images,
        );
        //MAKING THE POST REQUEST FOR UPLOADING PRODUCT
        http.Response response = await http.post(
            Uri.parse('$URI/api/add-product'),
            body: product.toJson(),
            headers: <String, String>{
              "Content-Type": "application/json; charset=UTF-8"
            });

        //MANAGING HTTP RESPONSE
        manageHttpResponse(
            response: response,
            context: context,
            onSuccess: () {
              showSnackbar(context, 'Product Uploaded Successfully!!');
            });
      } else {
        showSnackbar(context, 'Select Category!!');
      }
    } else {
      showSnackbar(context, 'Select image!!');
    }
  }
}
