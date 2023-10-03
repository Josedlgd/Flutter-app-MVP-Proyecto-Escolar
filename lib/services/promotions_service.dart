import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:flutter/material.dart';

class PromotionsService extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final List<Promotion> promotions = [];

  PromotionsService() {
    getPromotions();
  }

  getPromotions() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('offers').get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      promotions.add(
          Promotion.fromJson(documentSnapshot.data() as Map<String, dynamic>));
    }

    notifyListeners();
  }
}
