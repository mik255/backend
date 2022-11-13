// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'products.dart';

class Story {
  int? id;
  int? category_id;
  int isBlocked;
  String name;
  List<Product>? productList;
  String pix;
  String? paymentType;
  double? totalPrice;

  Story(
      {required this.isBlocked,
      required this.id,
      this.category_id,
      required this.name,
      this.productList,
      this.totalPrice,
      required this.pix,
      this.paymentType});

  double getTotal() {
    if (productList == null) {
      return 0;
    }
    double total = 0;
    for (var e in productList!) {
      total += (e.price * e.count);
    }
    return total;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category_id': category_id,
      'name': name,
      'productList': productList?.map((x) => x.toMap()).toList(),
      'pix': pix,
      'paymentType': paymentType,
      'totalPrice': totalPrice,
      'isBlocked': isBlocked
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'] as int?,
      isBlocked: map['isBlocked'] as int,
      category_id: map['category_id'] as int?,
      name: map['name'] as String,
      productList: map['productList'] == null
          ? []
          : List<Product>.from(
              (map['productList'] as List<int>).map<Product>(
                (x) => Product.fromMap(x as Map<String, dynamic>),
              ),
            ),
      pix: map['pix'] as String,
      paymentType:
          map['paymentType'] != null ? map['paymentType'] as String : null,
      totalPrice: map['totalPrice'] as double?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) =>
      Story.fromMap(json.decode(source) as Map<String, dynamic>);
}
