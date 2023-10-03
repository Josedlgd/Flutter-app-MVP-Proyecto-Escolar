import 'package:flutter/material.dart';

class AddressFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String neighborhood = '';
  int numberExt = 0;
  int numberInt = -1;
  String street = '';
  int zipCode = 0;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
