import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SectionService extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  List<Section> sections = [];
  late Section selectedSection;
  bool isLoading = true;
  bool isSaving = false;
  File? newIconFile;

  SectionService() {
    loadSections();
  }

  Future<List<Section>> loadSections() async {
    isLoading = true;
    if (sections.isNotEmpty) {
      sections.clear();
    }

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('product_types').get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      sections.add(
          Section.fromJson(documentSnapshot.data() as Map<String, dynamic>));
    }

    isLoading = false;
    notifyListeners();
    return sections;
  }

  void updateSelectedCategoryImage(String path) {
    selectedSection.icon = path;
    newIconFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String> createSection({required Section section}) async {
    try {
      final data = await db.collection('product_types').add(section.toJson());

      section.id = data.id;

      final updateData = db.collection('product_types').doc(data.id);

      updateData.update({"id": data.id}).then(
          (value) => print("Section id successfully updated!"),
          onError: (e) => print("Error updating section document $e"));

      sections.add(section);
      return section.id ?? '';
    } catch (e) {
      return "Error creating section";
    }
  }

  Future<String> updateSection({required Section section}) async {
    await FirebaseFirestore.instance
        .collection('product_types')
        .doc(section.id)
        .update(section.toJson());

    final index = sections.indexWhere((element) => element.id == section.id);
    sections[index] = section;

    return section.id!;
  }

  Future saveOrCreateSection(Section section) async {
    isSaving = true;
    notifyListeners();

    if (section.id == null) {
      await createSection(section: section);
    } else {
      await updateSection(section: section);
    }

    isSaving = false;
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

  List<ProductDB> _productsBySection = [];

  List<ProductDB> get productsBySection => _productsBySection;

  set productsBySection(List<ProductDB> value) {
    _productsBySection = value;
  }

  Future<List<ProductDB>> getProductsBySectionId(
      {required String sectionID}) async {
    if (productsBySection.isNotEmpty) {
      productsBySection = [];
    }

    // NOTE //* SEARCH CATEGORY BY ID
    final snapshotCateory = await FirebaseFirestore.instance
        .collection('product_types')
        .doc(sectionID)
        .get();

    Section sectionToSplit =
        Section.fromJson(snapshotCateory.data() as Map<String, dynamic>);

    // NOTE //* SEACH ALL PRODUCTS

    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();

    for (DocumentSnapshot documentSnapshot in snapshot.docs) {
      ProductDB productToAdd =
          ProductDB.fromJson(documentSnapshot.data() as Map<String, dynamic>);

      if (productToAdd.sections != null &&
          productToAdd.sections!.any((section) => section.id == sectionID)) {
        productsBySection.add(productToAdd);
        debugPrint('Agregado');
      }
    }

    debugPrint(productsBySection.length.toString());

    return productsBySection;
  }

}
