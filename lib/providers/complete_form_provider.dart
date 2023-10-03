import 'package:flutter/material.dart';

class CompleteFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String lastName = '';
  String name = '';
  String neighborhood = '';
  int numberExt = 0;
  int numberInt = -1;
  String street = '';
  int zipCode = 0;
  String contactName = '';
  int phoneNumber = 0;

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
