import 'package:domas_ecommerce/models/models.dart';
import 'package:flutter/material.dart';

class PaymentIntent {
  PaymentIntent({
    this.details,
    this.direction,
    this.id,
    this.orderResume,
    this.paymentType,
    this.products,
    this.schedule,
    this.shippingType,
    this.status,
  });
  Details? details;
  Address? direction;
  String? id;
  OrderResume? orderResume;
  String? paymentType;
  List<Cart>? products;
  Schedule? schedule;
  String? shippingType;
  String? status;

  PaymentIntent.fromJson(Map<String, dynamic> json) {
    details = Details.fromJson(json['details']);
    direction = Address.fromJson(json['direction']);
    id = json['id'];
    orderResume = OrderResume.fromJson(json['order_resume']);
    paymentType = json['payment_type'];
    products =
        List.from(json['products']).map((e) => Cart.fromJson(e)).toList();
    schedule = Schedule.fromJson(json['schedule']);
    shippingType = json['shipping_type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['details'] = details!.toJson();
    _data['direction'] = direction!.toJson();
    _data['id'] = id;
    _data['order_resume'] = orderResume!.toJson();
    _data['payment_type'] = paymentType;
    _data['products'] = products!.map((e) => e.toJson()).toList();
    _data['schedule'] = schedule!.toJson();
    _data['shipping_type'] = shippingType;
    _data['status'] = status;
    return _data;
  }
}

class Details {
  Details({
    required this.creationDate,
    required this.email,
    required this.name,
    required this.telephone,
    required this.userId,
  });
  DateTime? creationDate;
  String? email;
  String? name;
  String? telephone;
  String? userId;

  Details.fromJson(Map<String, dynamic> json) {
    creationDate = json['creation_date'] != null
        ? json['creation_date'] is String
            ? DateTime.tryParse(json['creation_date'])
            : DateTime.parse(json['creation_date'].toDate().toString())
        : null;
    email = json['email'];
    name = json['name'];
    telephone = json['telephone'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['creation_date'] = creationDate;
    _data['email'] = email;
    _data['name'] = name;
    _data['telephone'] = telephone;
    _data['user_id'] = userId;
    return _data;
  }
}

class OrderResume {
  OrderResume({
    required this.cupon,
    required this.descount,
    required this.idCupon,
    required this.quantityProducts,
    required this.shipping,
    required this.total,
    required this.totalProducts,
  });
  String? cupon;
  num? descount;
  String? idCupon;
  num? quantityProducts;
  num? shipping;
  num? total;
  num? totalProducts;

  OrderResume.fromJson(Map<String, dynamic> json) {
    cupon = json['cupon'];
    descount = json['descount'];
    idCupon = json['id_cupon'];
    quantityProducts = json['quantity_products'];
    shipping = json['shipping'];
    total = json['total'];
    totalProducts = json['total_products'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cupon'] = cupon;
    _data['descount'] = descount;
    _data['id_cupon'] = idCupon;
    _data['quantity_products'] = quantityProducts;
    _data['shipping'] = shipping;
    _data['total'] = total;
    _data['total_products'] = totalProducts;
    return _data;
  }
}

class Schedule {
  Schedule({
    required this.day,
    required this.hour,
    required this.minute,
  });
  DateTime? day;
  int? hour;
  int? minute;

  Schedule.fromJson(Map<String, dynamic> json) {
    day = json['day'] != null
        ? json['day'] is String
            ? DateTime.tryParse(json['day'])
            : DateTime.parse(json['day'].toDate().toString())
        : null;
    minute = json['minute'];
    hour = json['hour'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['day'] = day;
    _data['hour'] = hour;
    _data['minute'] = minute;

    return _data;
  }
}

PaymentIntent order_example = PaymentIntent.fromJson({
  "details": {
    "creation_date": "2023-05-07 14:36:54.507086",
    "email": "ulises.uudp@gmail.com",
    "name": "Ulises Uriel Dominguez",
    "telephone": "4445095492",
    "user_id": "user123123123123"
  },
  "direction": {
    "colony": "colonia 1",
    "description": "dafsdfsadafs",
    "number_ext": "123",
    "number_int": "123",
    "street": "calle 1",
    "street_btw1": "street 1",
    "street_btw2": "street 2"
  },
  "id": "GBw6aRkJ7IYBsK3tetAy",
  "order_resume": {
    "cupon": "coupon name",
    "descount": 123,
    "id_cupon": "id_cupon",
    "quantity_products": 10,
    "shipping": 12312,
    "total": 123123,
    "total_products": 12312312
  },
  "payment_type": "card",
  "products": [
    {
      "available": true,
      "descount": 10,
      "id": "XlsNHnBRYRYisF2kzqhPClone",
      "image":
          "https://res.cloudinary.com/walmart-labs/image/upload/d_default.jpg/w_960,dpr_auto,f_auto,q_auto:best/gr/images/product-images/img_large/00750107220231L.jpg",
      "name": "Producto de ejemplo",
      "price": 100,
      "quantity": 3
    }
  ],
  "schedule": {"day": "2023-05-24", "from_hour": "12:20:00"},
  "shipping_type": "domicilio",
  "status": "pending"
});
