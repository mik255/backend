// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  String id;
  String name;
  double price;
  int count;
  int? stock;
  double squerePrice;
  String urlImg;
  bool isBlocked;
  bool isSelected;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.squerePrice,
    required this.urlImg,
    this.stock,
    this.count = 0,
    required this.isBlocked,
    this.isSelected = false
  });

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
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      count: map['count'] as int,
      stock: map['stock'] != null ? map['stock'] as int : null,
      squerePrice: map['squerePrice'] as double,
      urlImg: map['urlImg'] as String,
      isBlocked: map['isBlocked'] as bool,
      isSelected: map['isSelected'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
