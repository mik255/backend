import 'dart:convert';

import 'package:backend/models/story.model.dart';

import 'receipt_attributes.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Receipt {
  int? id;
  int user_id;
  int category_id;
  String? observation;
  String paymentType;
  num totalPrice;
  ReceiptAttributes attributes;
  DateTime? dt_criacao;
  DateTime? dt_autalizacao;
  Receipt({
    this.id,
    required this.user_id,
    required this.category_id,
    required this.observation,
    required this.paymentType,
    required this.totalPrice,
    required this.attributes,
    this.dt_criacao,
    this.dt_autalizacao,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': user_id,
      'category_id': category_id,
      'observation': observation,
      'paymentType': paymentType,
      'totalPrice': totalPrice,
      'dt_criacao': dt_criacao?.millisecondsSinceEpoch,
      'dt_autalizacao': dt_autalizacao?.millisecondsSinceEpoch,
      'attributes': attributes.toMap(),
    };
  }

  factory Receipt.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> attributes = (map['attributes']) is String
        ? json.decode(map['attributes'])
        : map['attributes'] as Map<String, dynamic>;
    return Receipt(
      id: map['id'] != null ? map['id'] as int : null,
      user_id: map['user_id'] as int,
      category_id: map['category_id'] as int,
      observation:
          map['observation'] != null ? map['observation'] as String : null,
      paymentType: map['paymentType'] as String? ?? 'none',
      dt_autalizacao: map['dt_autalizacao'] as DateTime?,
      dt_criacao: map['dt_criacao'] as DateTime?,
      totalPrice: map['totalPrice'] as num,
      attributes: ReceiptAttributes.fromMap(attributes),
    );
  }

  String toJson() => json.encode(toMap());

  factory Receipt.fromJson(String source) =>
      Receipt.fromMap(json.decode(source) as Map<String, dynamic>);
}
