import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentIntentsService extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  Address? _directionSelected;

  Address? get directionSelected => _directionSelected;

  set directionSelected(Address? value) {
    _directionSelected = value;
  }

  //! PAYMENTINTENTS
  Map<String, List<PaymentIntent>> _paymentIntentsToShip = {};

  Map<String, List<PaymentIntent>> get paymentIntentsToShip =>
      _paymentIntentsToShip;

  set paymentIntentsToShip(Map<String, List<PaymentIntent>> value) {
    _paymentIntentsToShip = value;
  }

  Map<String, List<PaymentIntent>> _paymentIntentsComplete = {};

  Map<String, List<PaymentIntent>> get paymentIntentsComplete =>
      _paymentIntentsComplete;

  set paymentIntentsComplete(Map<String, List<PaymentIntent>> value) {
    _paymentIntentsComplete = value;
  }

  late PaymentIntent selectedPaymentIntent;
  bool isLoading = true;
  bool isSaving = false;
  File? newIconFile;

  PaymentIntentsService() {
    loadPaymentIntents();
  }

  TimeOfDay getTimeFromString({required String time}) {
    DateTime dateTime = DateFormat("HH:mm").parse(time);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  //! DATE STATUS

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, 0);
  }

  DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  DateTime? firstDayOfWeek;
  DateTime? lastDayOfWeek;

  String getDayToShip({required DateTime dateToShip}) {
    //!Weekday 1-> Lunes
    String res = "Lunes";

    int weekDayDateToShip = dateToShip.weekday;

    switch (weekDayDateToShip) {
      case 1:
        res = 'Lunes';
        break;
      case 2:
        res = 'Martes';
        break;
      case 3:
        res = 'Miercoles';
        break;
      case 4:
        res = 'Jueves';
        break;
      case 5:
        res = 'Viernes';
        break;
      case 6:
        res = 'Sabado';
        break;
      case 7:
        res = 'Domingo';
        break;
      default:
        break;
    }

    return res;
  }

  Future<Map<String, Map<String, List<PaymentIntent>>>>
      loadPaymentIntents() async {
    isLoading = true;
    if (paymentIntentsToShip.isNotEmpty) {
      _paymentIntentsToShip.clear();
    }

    if (paymentIntentsComplete.isNotEmpty) {
      _paymentIntentsComplete.clear();
    }

    // debugPrint(DateFormat.yMMMd().format(DateTime.now()));
    //* DATE CONTROL -
    DateTime now = DateTime.now();
    int currentDay = now.weekday;

    firstDayOfWeek = findFirstDateOfTheWeek(now);
    lastDayOfWeek = findLastDateOfTheWeek(now);

    debugPrint('PRIMER dia de la semana: $firstDayOfWeek');
    debugPrint('ULTIMO dia de la semana: $lastDayOfWeek');
    debugPrint(DateFormat.yMMMd().format(DateTime.now()));

    QuerySnapshot ordersPending = await FirebaseFirestore.instance
        .collection('orders')
        // .where("schedule.day", isGreaterThanOrEqualTo: firstDayOfWeek)
        // .where('schedule.day', isLessThanOrEqualTo: lastDayOfWeek)
        .where('status', isEqualTo: 'pending_ship_paid_done')
        .get();

    QuerySnapshot ordersPendingNotPaid = await FirebaseFirestore.instance
        .collection('orders')
        // .where("schedule.day", isGreaterThanOrEqualTo: firstDayOfWeek)
        // .where('schedule.day', isLessThanOrEqualTo: lastDayOfWeek)
        .where('status', isEqualTo: 'pending_ship_not_paid')
        .get();

    for (DocumentSnapshot documentSnapshot in ordersPending.docs) {
      //* PAYMENT INTENT
      final paymentIntentRes = PaymentIntent.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);

      debugPrint('dia : ${paymentIntentRes.schedule!.day}');

      final keyDate = getDayToShip(
          dateToShip:
              DateTime.parse(paymentIntentRes.schedule!.day.toString()));

      _paymentIntentsToShip.update(
        keyDate,
        (value) => value + [paymentIntentRes],
        ifAbsent: () => [paymentIntentRes],
      );
    }

    for (DocumentSnapshot documentSnapshot in ordersPendingNotPaid.docs) {
      //* PAYMENT INTENT
      final paymentIntentRes = PaymentIntent.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);

      debugPrint('dia : ${paymentIntentRes.schedule!.day}');

      final keyDate = getDayToShip(
          dateToShip:
              DateTime.parse(paymentIntentRes.schedule!.day.toString()));

      _paymentIntentsToShip.update(
        keyDate,
        (value) => value + [paymentIntentRes],
        ifAbsent: () => [paymentIntentRes],
      );
    }

    QuerySnapshot ordersComplete = await FirebaseFirestore.instance
        .collection('orders')
        // .where("schedule.day", isGreaterThanOrEqualTo: firstDayOfWeek)
        // .where('schedule.day', isLessThanOrEqualTo: lastDayOfWeek)
        .where('status', isEqualTo: 'complete')
        .get();

    for (DocumentSnapshot documentSnapshot in ordersComplete.docs) {
      //* PAYMENT INTENT
      final paymentIntentRes = PaymentIntent.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);

      debugPrint('dia : ${paymentIntentRes.schedule!.day}');

      final keyDate = getDayToShip(
          dateToShip:
              DateTime.parse(paymentIntentRes.schedule!.day.toString()));

      _paymentIntentsComplete.update(
        keyDate,
        (value) => value + [paymentIntentRes],
        ifAbsent: () => [paymentIntentRes],
      );
    }

    debugPrint('Por enviar: ${paymentIntentsToShip.length}');
    debugPrint('Completadas: ${paymentIntentsComplete.length}');

    isLoading = false;
    notifyListeners();

    // #NOTE - list to show
    return {
      'list_orders_complete': paymentIntentsComplete,
      'list_orders_pending': paymentIntentsToShip
    };
  }

  Future<bool> changeStatusOrder(
      {required String newStatus, required String id}) async {
    bool res = false;
    final completer = Completer<bool>();

    final ordersComplete = await FirebaseFirestore.instance
        .collection('orders')
        .doc(id)
        .update({'status': newStatus}).then((value) {
      debugPrint("STATUS of document successfully updated!");
      res = true;
    }, onError: (e) => debugPrint("Error updating STATUS document $e"));
    completer.complete(res);
    return completer.future;
  }

  Future<bool> updateDateOrder(
      {required Map<String, dynamic> newSchedule, required String id}) async {
    bool res = false;
    final completer = Completer<bool>();
    final ordersComplete = await FirebaseFirestore.instance
        .collection('orders')
        .doc(id)
        .update({'schedule': newSchedule}).then((value) {
      debugPrint("SCHEDULE of document successfully updated!");
      res = true;
    }, onError: (e) => debugPrint("Error updating SCHEDULE document $e"));

    completer.complete(res);
    return completer.future;
  }

  Future<bool> createOrder() async {
    final completer = Completer<bool>();

    bool res = false;
    if (sessionPaymentIntent != null) {
      //NOTE //! ADD DOCUMENT
      final DocumentReference<Map<String, dynamic>> resDocument =
          await db.collection("orders").add(sessionPaymentIntent!.toJson());

      //NOTE //!UPDATE ID PRODUCT
      final updateIdDocument = db.collection("orders").doc(resDocument.id);

      updateIdDocument.update({"id": resDocument.id}).then(
          (value) => debugPrint("ProductDB id successfully updated!"),
          onError: (e) => debugPrint("Error updating document $e"));

      //NOTE //!SAVE ID
      sessionPaymentIntent!.id = resDocument.id;

      if (resDocument.id.isNotEmpty) {
        res = true;
      }
    }

    completer.complete(res);
    return completer.future;
  }

  Future<bool> deleteOrder() {
    final completer = Completer<bool>();
    completer.complete(true);
    return completer.future;
  }

  PaymentIntent? sessionPaymentIntent;

  Future<List<OrderUser>> loadUserOrders() async {
    final completer = Completer<List<OrderUser>>();
    List<OrderUser> res = [];
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot ordersQuery = await FirebaseFirestore.instance
        .collection('orders')
        .where('details.user_id', isEqualTo: user!.uid)
        .get();

    if (ordersQuery.docs.isNotEmpty) {
      for (DocumentSnapshot documentSnapshot in ordersQuery.docs) {
        //* PAYMENT INTENT
        final paymentIntentRes = PaymentIntent.fromJson(
            documentSnapshot.data() as Map<String, dynamic>);

        for (var item in paymentIntentRes.products!) {
          res.add(OrderUser(
              imageUrl: item.image!,
              title: item.productName!,
              description: item.productId!,
              dateTime: paymentIntentRes.schedule!.day!));
        }
      }
    }

    completer.complete(res);
    return completer.future;
  }
}
