import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final List<Cart> carts = [];
  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  List<Cart> cartItems = [];

  Future<List<Cart>> getData() async {
    final user = FirebaseAuth.instance.currentUser;

    Completer<List<Cart>> res = Completer<List<Cart>>();

    cartItems = [];

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('carts')
        .where('id', isEqualTo: user!.uid)
        .get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      cartItems
          .add(Cart.fromJson(documentSnapshot.data() as Map<String, dynamic>));
    }

    res.complete(cartItems);

    return res.future;
  }

  int getQuantityProducts() {
    int quantityTotal = 0;
    for (var item in carts) {
      quantityTotal += item.quantity!;
    }
    return quantityTotal;
  }

  num getTotalDescountOfCheckout() {
    num totalDescount = 0.0;
    for (var item in cartItems) {
      //NOTE //!USE DESCOUNT
      double? descount = 0;
      if (item.productDescountType != null) {
        if (item.productDescountType == 'percent' &&
            item.productDescount != null) {
          descount = item.productPrice! * (item.productDescount! / 100);
        } else {
          descount = item.productPrice! as double?;
        }
      }

      totalDescount += descount as num;
    }

    return totalDescount;
  }

  num getTotalOfCheckout() {
    num totalCheckout = 0.0;
    for (var item in cartItems) {
      //NOTE //!USE DESCOUNT
      double? descount = 0;
      if (item.productDescountType != null) {
        if (item.productDescountType == 'percent' &&
            item.productDescount != null) {
          descount = item.productPrice! * (item.productDescount! / 100);
        } else {
          descount = item.productPrice! as double?;
        }
      }

      totalCheckout += ((item.productPrice! - descount!) * item.quantity!);
    }
    return totalCheckout;
  }

  // NOTE //* ---------------------------------------------- SEARCH PRODUCT  ---------------------------------------------- //
  Future<bool> deleteCartForUser() async {
    Completer<bool> res = Completer<bool>();

    //NOTE //!SEARCH USER
    final user = FirebaseAuth.instance.currentUser;

    //NOTE //!SEARCH CART ITEMS
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('carts')
        .where('id', isEqualTo: user!.uid)
        .get();

    //NOTE //!DELETE ITEMS
    if (querySnapshot.size > 0) {
      for (var element in querySnapshot.docs) {
        final docRef = element.reference;
        await docRef.delete();
      }
    }

    //* SEARCH ITEMS AGAIN

    QuerySnapshot querySnapshotDelete = await firestore
        .collection('carts')
        .where('id', isEqualTo: user.uid)
        .get();

    // * IF QUERY EMPTY THEN RETURN
    res.complete(querySnapshotDelete.size == 0);

    return res.future;
  }

  Future<List<ProductDB>> getProductCarts() async {
    List<ProductDB> res = [];

    for (var i = 0; i < carts.length; i++) {
      final productSearch = await searchProduct(id: carts[i].productId!);
      if (productSearch != null) {
        res.add(productSearch);
      }
    }
    return res;
  }

  Future<ProductDB?> searchProduct({required String id}) {
    Completer<ProductDB?> res = Completer<ProductDB?>();
    ProductDB? product;
    final docRef = db.collection("products").doc(id);
    docRef.get().then(
      (DocumentSnapshot doc) {
        product = ProductDB.fromJson(doc.data() as Map<String, dynamic>);
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
    res.complete(product);
    return res.future;
  }

  void getCartItems() async {
    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('carts')
        .where('id', isEqualTo: user!.uid)
        .get();

    List<Cart> cartItems = [];

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      cartItems
          .add(Cart.fromJson(documentSnapshot.data() as Map<String, dynamic>));
    }

    _counter = cartItems.length;
    notifyListeners();
  }

  Future<Cart> insert(Cart cart) async {
    final user = FirebaseAuth.instance.currentUser;
    final cartRef = db
        .collection("carts")
        .where('id', isEqualTo: user!.uid)
        .where('productId', isEqualTo: cart.productId);

    final cartDoc = await cartRef.get();
    if (cartDoc.docs.isNotEmpty) {
      return Future.error('');
    }
    cart.id = user.uid;
    await db.collection("carts").add(cart.toJson());
    carts.add(cart);
    return cart;
  }

  Future<void> updateQuantity(
      String productId, int quantity, num newPrice) async {
    final user = FirebaseAuth.instance.currentUser;
    final collectionRef = FirebaseFirestore.instance.collection('carts');

    final querySnapshot = await collectionRef
        .where('id', isEqualTo: user!.uid)
        .where('productId', isEqualTo: productId)
        .get();

    if (querySnapshot.size > 0) {
      final docRef = querySnapshot.docs[0].reference;
      await docRef.update({'quantity': quantity, 'productPrice': newPrice});
    }
  }

  Future<void> delete({required String productId}) async {
    final user = FirebaseAuth.instance.currentUser;
    final collectionRef = FirebaseFirestore.instance.collection('carts');

    final querySnapshot = await collectionRef
        .where('productId', isEqualTo: productId)
        .where('id', isEqualTo: user!.uid)
        .get();

    if (querySnapshot.size > 0) {
      final docRef = querySnapshot.docs[0].reference;
      return await docRef.delete();
    }
  }

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    // notifyListeners();
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefItems();
    // notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefItems();
    // notifyListeners();
  }

  double getTotalPrice() {
    _getPrefItems();
    return _totalPrice;
  }

  void addCounter() {
    _counter++;
    _setPrefItems();
    // notifyListeners();
  }

  void removerCounter() {
    _counter--;
    _setPrefItems();
    // notifyListeners();
  }

  int getCounter() {
    getCartItems();
    return _counter;
  }

  void removeCartItem(double productPrice) {
    removerCounter();
    removeTotalPrice(productPrice);
    // notifyListeners();
  }
}
