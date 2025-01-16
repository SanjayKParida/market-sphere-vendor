import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_sphere_vendor/controllers/product_controller.dart';
import 'package:market_sphere_vendor/controllers/subcategory_controller.dart';
import 'package:market_sphere_vendor/models/subcategory/subcategory_model.dart';
import 'package:market_sphere_vendor/provider/vendor_provider.dart';
import 'package:market_sphere_vendor/services/snackbar_service.dart';
import '../../../../controllers/category_controller.dart';
import '../../../../models/category/category_model.dart';

class UploadsScreen extends ConsumerStatefulWidget {
  const UploadsScreen({super.key});

  @override
  _UploadsScreenState createState() => _UploadsScreenState();
}

class _UploadsScreenState extends ConsumerState<UploadsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CategoryModel? selectedCategory;
  bool isLoading = false;
  SubcategoryModel? selectedSubcategory;
  final productController = ProductController();
  late String name, productName, description;
  late int quantity, productPrice;

  Future<List<SubcategoryModel>>? futureSubcategories;
  late Future<List<CategoryModel>> futureCategories;
  final ImagePicker _picker = ImagePicker();
  List<File> images = [];

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Add Product',
        style: GoogleFonts.lato(
          color: Colors.grey[800],
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(IconlyLight.more_circle, color: Colors.black),
          onPressed: () {
            // Add more options menu functionality here
          },
        ),
      ],
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(1),
      //   child: Container(
      //     color: Colors.grey[200],
      //     height: 1,
      //   ),
      // ),
    );
  }

  chooseImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      print('No Image picked');
    } else {
      setState(() {
        images.add(File(pickedImage.path));
      });
    }
  }

  getSubcategoryByCategoryName(value) {
    futureSubcategories =
        SubcategoryController().getSubcategoriesByCategoryName(value);
    selectedSubcategory = null;
  }

  Widget _buildTextField(
      {required String label,
      required String? Function(String?) onChanged,
      required String? Function(String?) validator,
      int? maxLines,
      TextInputType? keyboardType,
      int? maxLength,
      double? width}) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.lato(color: Colors.grey[700]),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF63A0FF), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Upload Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Images',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: images.length + 1,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            return index == 0
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                          Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: IconButton(
                                      onPressed: chooseImage,
                                      icon: const Icon(IconlyBroken.plus,
                                          color: Color(0xFF63A0FF)),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: FileImage(images[index - 1]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Form Fields
                  _buildTextField(
                    onChanged: (value) {
                      productName = value!;
                    },
                    label: "Product Name",
                    validator: (value) =>
                        value!.isEmpty ? "Enter Product Name" : null,
                  ),

                  _buildTextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value!.isNotEmpty) {
                        try {
                          productPrice = int.parse(value!);
                        } catch (e) {
                          showSnackbar(context, 'Enter valid price!!');
                        }
                      }
                    },
                    label: "Price",
                    validator: (value) =>
                        value!.isEmpty ? "Enter Product Price" : null,
                  ),

                  _buildTextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      quantity = int.parse(value!);
                    },
                    label: "Quantity",
                    validator: (value) =>
                        value!.isEmpty ? "Enter Product Quantity" : null,
                  ),

                  // Category Dropdowns
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: FutureBuilder<List<CategoryModel>>(
                      future: futureCategories,
                      builder: (context, snapshots) {
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshots.hasError) {
                          return Center(
                              child: Text('Error: ${snapshots.error}'));
                        } else if (!snapshots.hasData ||
                            snapshots.data!.isEmpty) {
                          return const Center(
                              child: Text("No Categories found!"));
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                              color: Colors.grey[50],
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<CategoryModel>(
                                value: selectedCategory,
                                hint: const Text("Select Category"),
                                isExpanded: true,
                                items: snapshots.data!
                                    .map((CategoryModel category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                  getSubcategoryByCategoryName(
                                      selectedCategory!.name);
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: FutureBuilder<List<SubcategoryModel>>(
                      future: futureSubcategories,
                      builder: (context, snapshots) {
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshots.hasError) {
                          return Center(
                              child: Text('Error: ${snapshots.error}'));
                        } else if (!snapshots.hasData ||
                            snapshots.data!.isEmpty) {
                          return const Center(child: Text("Select a category"));
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                              color: Colors.grey[50],
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<SubcategoryModel>(
                                value: selectedSubcategory,
                                hint: const Text("Select Subcategory"),
                                isExpanded: true,
                                items: snapshots.data!
                                    .map((SubcategoryModel subcategory) {
                                  return DropdownMenuItem(
                                    value: subcategory,
                                    child: Text(subcategory.subCategoryName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSubcategory = value;
                                  });
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  _buildTextField(
                    onChanged: (value) {
                      description = value!;
                    },
                    label: "Description",
                    validator: (value) =>
                        value!.isEmpty ? "Enter Product Description" : null,
                    maxLines: 3,
                    maxLength: 500,
                  ),

                  const SizedBox(height: 20),

                  // UPLOAD
                  Center(
                    child: InkWell(
                      onTap: () async {
                        final fullName = ref.read(vendorProvider)!.fullName;
                        final vendorId = ref.read(vendorProvider)!.id;
                        if (_formKey.currentState!.validate()) {
                          //START LOADING
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await productController
                                .uploadProduct(
                              id: '',
                              productName: productName,
                              productPrice: productPrice,
                              quantity: quantity,
                              description: description,
                              category: selectedCategory!.name,
                              vendorId: vendorId,
                              fullName: fullName,
                              subCategory: selectedSubcategory!.subCategoryName,
                              pickedImages: images,
                              context: context,
                            )
                                .whenComplete(() {
                              //STOP LOADING
                              setState(() {
                                isLoading = false;
                              });
                              selectedCategory = null;
                              selectedSubcategory = null;
                              images.clear();
                            });
                          } catch (e) {
                            showSnackbar(context, "Error Uploading : $e");
                          }
                        } else {
                          showSnackbar(
                              context, 'Please Enter all the fields!!');
                        }
                      },
                      child: Container(
                        height: 56,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF63A0FF), Color(0xFF102DE1)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF63A0FF).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: isLoading
                              ? SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                              : Text(
                                  "Upload Product",
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
