import 'package:domas_ecommerce/models/models.dart';
import 'package:flutter/material.dart';


class CategoryFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Category category;

  CategoryFormProvider(this.category);

  updateAvailability(bool value) {
    category.enable = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
