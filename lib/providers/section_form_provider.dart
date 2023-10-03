import 'package:domas_ecommerce/models/models.dart';
import 'package:flutter/material.dart';

class SectionFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Section section;

  SectionFormProvider(this.section);

  updateAvailability(bool value) {
    section.enable = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
