// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  int? id;
  String name;
  num price;
  int count;
  int? stock;
  num squerePrice;
  String urlImg;
  bool isBlocked;
  bool isSelected;
  Product(
      {
        this.id,
      required this.name,
      required this.price,
      required this.squerePrice,
      required this.urlImg,
      this.stock,
      this.count = 0,
      required this.isBlocked,
      this.isSelected = false});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'count': count,
      'stock': stock,
      'squerePrice': squerePrice,
      'urlImg': urlImg,
      'isBlocked': isBlocked,
      'isSelected': isSelected,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: map['price'] as num,
      count: map['count'] as int,
      stock: map['stock'] != null ? map['stock'] as int : null,
      squerePrice: map['squerePrice'] as num,
      urlImg: map['urlImg'] as String,
      isBlocked: map['isBlocked'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
      
}
