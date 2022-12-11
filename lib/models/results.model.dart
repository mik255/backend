// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserResults {
  double g20total;
  int totalOrders;
  double marginProfit;
  double ticket;
  double priceSquare;
  double g20Price;
  int user_id;
  UserResults(
      {  required this.g20total,
        required this.totalOrders,
        required this.marginProfit,
        required this.ticket,
        required this.priceSquare,
        required this.g20Price,
        required this.user_id,
      });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'g20total': g20total,
      'totalOrders': totalOrders,
      'marginProfit': marginProfit,
      'ticket': ticket,
      'priceSquare': priceSquare,
      'g20Price': g20Price,
      'user_id': user_id,
    };
  }

  factory UserResults.fromMap(Map<String, dynamic> map) {
    return UserResults(
     g20total: map['g20total'] as double,
     totalOrders: map['totalOrders'] as int,
      marginProfit:map['marginProfit'] as double,
     ticket: map['ticket'] as double,
     priceSquare: map['priceSquare'] as double,
      g20Price:map['g20Price'] as double,
     user_id: map['user_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserResults.fromJson(String source) => UserResults.fromMap(json.decode(source) as Map<String, dynamic>);
}
