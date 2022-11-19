import 'dart:convert';

import 'package:backend/models/story.model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first



class Receipt {
  int? id;
  int category_id;
  String observation;
  String paymentType;
  num totalPrice;
  List<int>? stories_ids;
  List<Story>? stories;
  Receipt({
    this.id,
    required this.category_id,
    required this.observation,
    required this.paymentType,
    required this.totalPrice,
    required this.stories_ids,
    this.stories,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category_id': category_id,
      'observation': observation,
      'paymentType': paymentType,
      'totalPrice': totalPrice,
      'stories_ids': stories_ids,
      'stories': stories?.map((x) => x.toMap()).toList(),
    };
  }

  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      id: map['id'] != null ? map['id'] as int : null,
      category_id: map['category_id'] as int,
      observation: map['observation'] as String,
      paymentType: map['paymentType'] as String? ??'',
      totalPrice: map['totalPrice'] as num,
      stories_ids: map['stories_ids'] != null ? List<int>.from((map['stories_ids'] as List<int>)) : null,
      stories: map['stories'] != null ? List<Story>.from((map['stories'] as List<int>).map<Story?>((x) => Story.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Receipt.fromJson(String source) => Receipt.fromMap(json.decode(source) as Map<String, dynamic>);
}
