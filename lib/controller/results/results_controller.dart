import 'dart:convert';

import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

import '../../header.dart';
import '../../main_stances.dart';
import '../../models/receipt.dart';
import '../../models/results.model.dart';
import '../receipts/receiptsControoler.dart';

class ResultsState {
  ResultsState({required this.response, this.data});
  Response response;
  dynamic data;
}

class ResultsStateSucess extends ResultsState {
  ResultsStateSucess({required Response response, dynamic data})
      : super(response: response, data: data);
}

class ResultsStateError extends ResultsState {
  ResultsStateError({required Response response}) : super(response: response);
}

class ResultsController {
  var conexao = MainStances.conexao!;
  ReceiptController receiptController = ReceiptController();
  Future getUserResults(int id,int startDate,int endDate) async {
    UserResults userResults = UserResults(
        g20Price: 0,
        g20total: 0,
        ticket: 0,
        totalOrders: 0,
        priceSquare: 0,
        marginProfit: 0,
        user_id: id);
       DateTime s =DateTime.fromMillisecondsSinceEpoch(startDate);
       DateTime e =  DateTime.fromMillisecondsSinceEpoch(endDate);
       String start = s.year.toString()+s.month.toString()+s.day.toString();
      String end = e.year.toString()+e.month.toString()+(e.day+1).toString();

    List<Receipt> receipts =
        (await receiptController.getUserReceiptsByDate(id,start,end) as ReceiptStateSucess)
            .data;
    int totalOrders = 0;
    receipts.forEach(
      (Receipt element) {
        totalOrders++;
        element.attributes.stories.forEach((element) {
          element.productList?.forEach((element) {
            userResults.g20Price += element.price.toDouble();
            userResults.priceSquare += element.squerePrice.toDouble();
          });
        });
      },
    );
    if(receipts.isNotEmpty){
      userResults.g20total = userResults.g20Price;
    userResults.marginProfit =
        double.parse(((userResults.g20Price * 100) / userResults.priceSquare).toStringAsFixed(2));
    userResults.totalOrders = totalOrders;
    userResults.ticket = double.parse((userResults.g20total / totalOrders).toStringAsFixed(2));
    }
    return ResultsStateSucess(
        response: Response(
          200,
          body: userResults.toJson(),
          headers: Header.header,
        ),
        data: receipts);
  }
}
