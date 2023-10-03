import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsServiceUser extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final List<ProductDB> products = [];
  late ProductDB selectedProduct;
  final storage = const FlutterSecureStorage();
  bool isLoading = true;
  bool isSaving = false;
  File? newPictureFile;

  ProductsServiceUser() {
    loadProducts();
  }

  Future<List<ProductDB>> loadProducts() async {
    if (products.isNotEmpty) {
      products.clear();
    }

    isLoading = true;
    notifyListeners();

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    Map<String, dynamic> productsMap = {};

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      productsMap[documentSnapshot.id] = documentSnapshot.data();
    }

    productsMap.forEach(
      (key, value) {
        final tempProduct = ProductDB.fromJson(value);
        tempProduct.id = key;
        products.add(tempProduct);
      },
    );

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future saveOrCreateProduct(ProductDB product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(ProductDB product) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(product.id)
        .update(product.toJson());

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(ProductDB product) async {
    try {
      await db.collection("products").add(product.toJson());
      product.id = product.name;

      products.add(product);

      return product.id!;
    } catch (e) {
      return "Error creating product";
    }
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) {
      return null;
    } else {
      isSaving = true;
      notifyListeners();
      final url = Uri.parse(
          'https://api.cloudinary.com/v1_1/diut8vgyz/image/upload?upload_preset=flutter');
      final imageUploadRequest = http.MultipartRequest(
        'POST',
        url,
      );
      final file =
          await http.MultipartFile.fromPath('file', newPictureFile!.path);

      imageUploadRequest.files.add(file);
      final streamResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamResponse);

      if (response.statusCode != 200 && response.statusCode != 201) {
        return null;
      } else {
        newPictureFile = null;
        final decodedData = json.decode(response.body);
        return decodedData['secure_url'];
      }
    }
  }
}
