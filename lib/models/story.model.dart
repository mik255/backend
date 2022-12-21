// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'products.dart';

class Story {
  int? id;
  int isBlocked;
  String name;
  List<Product>? productList;
  String pix;
  String? paymentType;
  double? totalPrice;
  List<int> products_ids;
  Story(
      {required this.isBlocked,
      required this.id,
      required this.name,
       required this.products_ids,
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
    return totalPrice = total;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'productList': productList?.map((x) => x.toMap()).toList(),
      'pix': pix,
      'paymentType': paymentType,
      'totalPrice': totalPrice,
      'isBlocked': isBlocked,
       'products_ids': products_ids
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'] as int?,
      isBlocked: map['isBlocked'] as int? ??0,
      name: map['name'] as String? ??'',
      productList: map['productList'] == null
          ? []
          : List<Product>.from(
              (map['productList'] as List<dynamic>).map<dynamic>(
                (x) => Product.fromMap(x as Map<String, dynamic>),
              ),
            ),
      pix: map['pix'] as String? ??'',
      paymentType:
          map['paymentType'] != null ? map['paymentType'] as String : null,
      totalPrice: double.parse((map['totalPrice']??0).toString()),
      products_ids:map['products_ids']==null?[]:(map['products_ids'] as List<dynamic>).map((e) => e as int).toList()

    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) =>
      Story.fromMap(json.decode(source) as Map<String, dynamic>);
}
