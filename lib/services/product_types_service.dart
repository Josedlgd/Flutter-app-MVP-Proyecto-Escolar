import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductTypesService extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  List<Category> categories = [];
  late Category selectedCategory;
  bool isLoading = true;
  bool isSaving = false;
  File? newIconFile;

  ProductTypesService() {
    loadCategories();
  }

  Future<bool> loadCategoriesAvailable() async {
    Completer<bool> completer = Completer<bool>();
    isLoading = true;
    if (categories.isNotEmpty) {
      categories = [];
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('enable', isEqualTo: true)
        .get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      categories.add(
          Category.fromJson(documentSnapshot.data() as Map<String, dynamic>));
    }

    isLoading = false;
    notifyListeners();

    completer.complete(categories.isNotEmpty);
    return completer.future;
  }

  Future<List<Category>> loadCategories() async {
    isLoading = true;
    if (categories.isNotEmpty) {
      categories.clear();
    }

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      categories.add(
          Category.fromJson(documentSnapshot.data() as Map<String, dynamic>));
    }

    isLoading = false;
    notifyListeners();
    return categories;
  }

  void updateSelectedCategoryImage(String path) {
    selectedCategory.icon = path;
    newIconFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newIconFile == null) {
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
      final file = await http.MultipartFile.fromPath('file', newIconFile!.path);

      imageUploadRequest.files.add(file);
      final streamResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamResponse);

      if (response.statusCode != 200 && response.statusCode != 201) {
        return null;
      } else {
        newIconFile = null;
        final decodedData = json.decode(response.body);
        return decodedData['secure_url'];
      }
    }
  }

  Future saveOrCreateCategory(Category category) async {
    isSaving = true;
    notifyListeners();

    if (category.id == null) {
      await createCategory(category);
    } else {
      await updateCategory(category);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateCategory(category) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(category.id)
        .update(category.toJson());

    final index = categories.indexWhere((element) => element.id == category.id);
    categories[index] = category;

    return category.id!;
  }

  Future<String> createCategory(category) async {
    try {
      await db.collection('categories').add(category.toJson());
      category.id = category.name;

      categories.add(category);

      return category.id;
    } catch (e) {
      return "Error creating category";
    }
  }
}
