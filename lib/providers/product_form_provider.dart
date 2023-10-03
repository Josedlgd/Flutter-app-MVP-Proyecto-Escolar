import 'dart:io';

import 'package:flutter/material.dart';
import 'package:domas_ecommerce/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ProductDB product;
  File? newPictureFile;

  ProductFormProvider(this.product);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void updateSelectedProductImage(String path) {
    product.images![0] = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }
}
