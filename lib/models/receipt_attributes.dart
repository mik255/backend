// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'story.model.dart';

class ReceiptAttributes {
  List<Story> stories;
  ReceiptAttributes({
    required this.stories,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stories': stories.map((x) => x.toMap()).toList(),
    };
  }

  factory ReceiptAttributes.fromMap(Map<String, dynamic> map) {
    return ReceiptAttributes(
      stories: List<Story>.from((map['stories'] as List<dynamic>).map<Story>((x) => Story.fromMap(x is String?json.decode(x):x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiptAttributes.fromJson(String source) => ReceiptAttributes.fromMap(json.decode(source) as Map<String, dynamic>);
}
