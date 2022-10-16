// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'products.dart';

class Story {
  String id;
  String name;
  List<Product> productList;
  String pix;
  String? paymentType;
  double totalPrice;

  Story({
    required this.id,
    required this.name,
    required this.productList,
    required this.totalPrice,
    required this.pix,
    this.paymentType
  });


  double getTotal(){
    double total =0;
     for (var e in productList) {
      total+=(e.price*e.count);
    }
    return total;
  }


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'productList': productList.map((x) => x.toMap()).toList(),
      'pix': pix,
      'paymentType': paymentType,
      'totalPrice': totalPrice,
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'] as String,
      name: map['name'] as String,
      productList: List<Product>.from((map['productList'] as List<int>).map<Product>((x) => Product.fromMap(x as Map<String,dynamic>),),),
      pix: map['pix'] as String,
      paymentType: map['paymentType'] != null ? map['paymentType'] as String : null,
      totalPrice: map['totalPrice'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) => Story.fromMap(json.decode(source) as Map<String, dynamic>);
}
