// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'story.model.dart';

class Category {
  int? id;
  String name;
  bool isBlocked;
  List<Story> stories = [];
  List<int> stories_ids = [];
  Category({
    this.id,
    required this.name,
    required this.isBlocked,
    required this.stories,
    required this.stories_ids
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'isBlocked': isBlocked,
      'stories': stories.map((x) => x.toMap()).toList(),
      'stories_ids':stories_ids
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String,
      isBlocked: map['isBlocked'] is bool?map['isBlocked']:map['isBlocked'] == 1,
      stories: map['stories'] == null
          ? []
          : List<Story>.from(
              (map['stories'] as List<dynamic>).map<dynamic>(
                (x) => Story.fromMap(x as Map<String, dynamic>),
              ),
            ),
            stories_ids:map['stories_ids']==null?[]:(map['stories_ids'] as List<dynamic>).map((e) => e as int).toList()
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}
