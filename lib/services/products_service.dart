import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domas_ecommerce/ui/general.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  List<ProductDB> products = [];
  final storage = const FlutterSecureStorage();

  bool isLoading = true;
  bool isSaving = false;
  File? selectedPicture;
  File? selectedPictureForDetails;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? value) {
    _errorMessage = value;
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyOptions = GlobalKey<FormState>();

  List<dynamic> selectedPictures = [];
  List<dynamic> selectedPicturesForDetails = [];
  List<String> labelsForDetails = [];

  ProductsService() {
    loadProducts();
  }

  // * PRODUCT TO ADD OR UPDATE
  ProductDB _product = ProductDB(
    name: '',
    description: '',
    id: '',
    isPopular: false,
    available: false,
    price: 0.0,
    stock: 0,
    images: [],
    categories: [],
    sections: [],
    descountType: 'percent',
  );

  setImages() {
    if (product.images != null && product.images!.isNotEmpty) {
      for (var image in product.images!) {
        selectedPictures.add(image);
      }
    }

    if (product.productOptions != null && product.productOptions!.isNotEmpty) {
      for (var productOption in product.productOptions!) {
        selectedPictures.add(productOption.imagen);
      }
    }
  }

  ProductDB get product => _product;

  set product(ProductDB value) {
    _product = value;
  }

  searchCaseForProduct() {
    List<String> substrings = [];

    String substring = "";
    for (int i = 0; i < product.name!.length; i++) {
      substring += product.name![i];
      substrings.add(substring);
    }

    //NOTE existing cases for filter list
    if (product.caseSearch != null && product.caseSearch!.isNotEmpty) {
      final List<String> filterList = substrings
          .where((element) => !product.caseSearch!.contains(element))
          .toList();
      for (var item in filterList) {
        product.caseSearch!.add(item);
      }
    } else {
      product.caseSearch = substrings;
    }
  }

  init() {
    isLoading = true;
    isSaving = false;
    selectedPicture = null;
    selectedPictureForDetails = null;
    errorMessage = null;
    selectedPictures = [];
    selectedPicturesForDetails = [];
    labelsForDetails = [];
    _product = ProductDB(
      name: '',
      description: '',
      id: '',
      isPopular: false,
      available: true,
      descountType: 'percent',
      descount: 0.0,
      price: 0.0,
      stock: 0,
      images: [],
      sections: [],
      categories: [],
    );
    return;
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void updateSelectedProductImage(String path) {
    product.images![0] = path;
    selectedPicture = File.fromUri(Uri(path: path));
  }

  // NOTE //* ---------------------------------------------- LOAD PRODUCTS ---------------------------------------------- //
  List<ProductDB> _productsOfferAndAvailable = [];

  List<ProductDB> get productsOfferAndAvailable => _productsOfferAndAvailable;

  set productsOfferAndAvailable(List<ProductDB> value) {
    _productsOfferAndAvailable = value;
  }

  Future<bool> loadProductsAvailableInOffer() async {
    //*Clear list

    Completer<bool> res = Completer<bool>();

    if (productsOfferAndAvailable.isNotEmpty) {
      productsOfferAndAvailable = [];
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('available', isEqualTo: true)
        .where('')
        .get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      _productsOfferAndAvailable.add(
          ProductDB.fromJson(documentSnapshot.data() as Map<String, dynamic>));
    }
    debugPrint(productsOfferAndAvailable.length.toString());
    res.complete(productsOfferAndAvailable.isNotEmpty);
    return res.future;
  }

  List<ProductDB> _productsAvailable = [];

  List<ProductDB> get productsAvailable => _productsAvailable;

  set productsAvailable(List<ProductDB> value) {
    _productsAvailable = value;
  }

  Future<bool> loadProductsAvailable() async {
    //*Clear list
    Completer<bool> res = Completer<bool>();

    if (productsAvailable.isNotEmpty) {
      productsAvailable = [];
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('available', isEqualTo: true)
        .get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      _productsAvailable.add(
          ProductDB.fromJson(documentSnapshot.data() as Map<String, dynamic>));
    }
    debugPrint(productsAvailable.length.toString());
    res.complete(productsAvailable.isNotEmpty);
    return res.future;
  }

  List<ProductDB> _productsLatestAddedAndAvailable = [];

  List<ProductDB> get productsLatestAddedAndAvailable =>
      _productsLatestAddedAndAvailable;

  set productsLatestAddedAndAvailable(List<ProductDB> value) {
    _productsLatestAddedAndAvailable = value;
  }

  List<ProductDB> _productsByCategory = [];

  List<ProductDB> get productsByCategory => _productsByCategory;

  set productsByCategory(List<ProductDB> value) {
    _productsByCategory = value;
  }

  Future<List<ProductDB>> getProductsByCategoryId(
      {required String categoryID}) async {
    if (productsByCategory.isNotEmpty) {
      productsByCategory = [];
    }

    // NOTE //* SEARCH CATEGORY BY ID
    final snapshotCateory = await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryID)
        .get();

    Category categoryToSplit =
        Category.fromJson(snapshotCateory.data() as Map<String, dynamic>);

    // NOTE //* SEACH ALL PRODUCTS

    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();

    for (DocumentSnapshot documentSnapshot in snapshot.docs) {
      ProductDB productToAdd =
          ProductDB.fromJson(documentSnapshot.data() as Map<String, dynamic>);

      if (productToAdd.categories != null &&
          productToAdd.categories!
              .any((category) => category.id == categoryID)) {
        productsByCategory.add(productToAdd);
        debugPrint('Agregado');
      }
    }

    debugPrint(productsByCategory.length.toString());

    return productsByCategory;
  }

  Future<bool> loadProductsAvailableAndLastAdded() async {
    Completer<bool> res = Completer<bool>();

    if (productsLatestAddedAndAvailable.isNotEmpty) {
      productsLatestAddedAndAvailable = [];
    }

    DateTime now = DateTime.now();
    DateTime before7Days = now.subtract(const Duration(days: 7));

    Timestamp time = Timestamp.fromDate(before7Days);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('available', isEqualTo: true)
        // .where('created_at', isGreaterThanOrEqualTo: time)
        .get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> dataAsMap =
          documentSnapshot.data() as Map<String, dynamic>;
      if (dataAsMap.containsKey('created_at') &&
          dataAsMap['created_at'] != null) {
        DateTime dateData =
            DateTime.parse(dataAsMap['created_at'].toDate().toString());
        if (dateData.isAfter(before7Days)) {
          if (!productsLatestAddedAndAvailable
              .contains(ProductDB.fromJson(dataAsMap))) {
            _productsLatestAddedAndAvailable.add(ProductDB.fromJson(dataAsMap));
          }
        }
      }
    }
    debugPrint(productsLatestAddedAndAvailable.length.toString());
    res.complete(productsLatestAddedAndAvailable.isNotEmpty);
    return res.future;
  }

  List<ProductDB> productsAvailableAndPopular = [];

  Future<bool> loadProductsAvailableAndPopular() async {
    Completer<bool> res = Completer<bool>();

    if (productsAvailableAndPopular.isNotEmpty) {
      productsAvailableAndPopular = [];
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('is_popular', isEqualTo: true)
        .where('available', isEqualTo: true)
        .get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      productsAvailableAndPopular.add(
          ProductDB.fromJson(documentSnapshot.data() as Map<String, dynamic>));
    }
    debugPrint(productsAvailableAndPopular.length.toString());

    res.complete(productsAvailableAndPopular.isNotEmpty);
    return res.future;
  }

  Future<List<ProductDB>> loadProducts() async {
    if (products.isNotEmpty) {
      products.clear();
    }

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      products.add(
          ProductDB.fromJson(documentSnapshot.data() as Map<String, dynamic>));
    }
    return products;
  }

  // NOTE //* ---------------------------------------------- STORE PRODUCTS ---------------------------------------------- //

  Future<bool> saveOrCreateProduct() async {
    isSaving = true;
    notifyListeners();

    // * PRODUCT CREATED
    if (product.id == '') {
      await createProduct();
    } else {
      // * UPDATE PRODUCT
      await updateProduct();
    }

    isSaving = false;
    notifyListeners();

    return true;
  }

  Future<String> updateProduct() async {
    //NOTE //*SAVE THE DATE OF CREATION IN FORMAT YYYY-MM-DD
    DateTime now = DateTime.now();
    String updatedDt = DateFormat('yyyy-MM-dd').format(now);
    product.createdAt = DateTime.parse(updatedDt);
    debugPrint(updatedDt); // 20-04-03

    await FirebaseFirestore.instance
        .collection('products')
        .doc(product.id)
        .update(product.toJson());

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct() async {
    try {
      //NOTE //*SAVE THE DATE OF CREATION IN FORMAT YYYY-MM-DD
      DateTime now = DateTime.now();
      String updatedDt = DateFormat('yyyy-MM-dd').format(now);

      product.createdAt = DateTime.parse(updatedDt);
      debugPrint(updatedDt); // 20-04-03

      // ADD DOCUMENT
      final DocumentReference<Map<String, dynamic>> res =
          await db.collection("products").add(product.toJson());

      // UPDATE ID PRODUCT
      final updateIdDocument = db.collection("products").doc(res.id);

      updateIdDocument.update({"id": res.id}).then(
          (value) => print("ProductDB id successfully updated!"),
          onError: (e) => print("Error updating document $e"));

      product.id = res.id;

      // ADD PRODUCT ID TO THE PRODUCTS
      products.add(product);

      // RETURN THE ID IF NOT NULL
      return product.id ?? 'NULL ID';
    } catch (e) {
      return "Error creating product";
    }
  }

  Future<String?> uploadImage({required File? newPictureFile}) async {
    final completer = Completer<String>();
    String? res;

    if (newPictureFile != null) {
      isSaving = true;
      final url = Uri.parse(
          'https://api.cloudinary.com/v1_1/diut8vgyz/image/upload?upload_preset=flutter');
      final imageUploadRequest = http.MultipartRequest(
        'POST',
        url,
      );
      final file =
          await http.MultipartFile.fromPath('file', newPictureFile.path);

      imageUploadRequest.files.add(file);
      final streamResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = json.decode(response.body);
        res = decodedData['secure_url'];
      }
    }

    debugPrint('url: $res');

    completer.complete(res);
    return completer.future;
  }

  Future<List<ProductDB>> searchProducts(String query) async {
    List<ProductDB> products = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('products')
        .where('case_search', arrayContains: query)
        .get();

    for (DocumentSnapshot documentSnapshot in snapshot.docs) {
      products.add(
          ProductDB.fromJson(documentSnapshot.data() as Map<String, dynamic>));
    }
    return products;
  }
}
