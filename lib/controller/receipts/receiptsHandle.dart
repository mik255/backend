import 'dart:convert';

import 'package:backend/controller/productController/products_controller.dart';
import 'package:backend/controller/receipts/receiptsControoler.dart';
import 'package:backend/models/category.model.dart';
import 'package:backend/models/receipt.dart';
import 'package:backend/models/story.model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/products.dart';


class ReceiptHandle {
  Handler get handler {
    Router router = Router();
    ReceiptController receiptController = ReceiptController();
    router.post('/receipts/id', (Request request) async {
      String requestData = await request.readAsString();
      Map<String, dynamic> data = json.decode(requestData);

      return (await receiptController.getReceiptById(data['id'])).response;
    });
    router.get('/receipts', (Request request) async {
      return (await receiptController.getAll()).response;
    });
     router.post('/receipts/user', (Request request) async {
      String requestData = await request.readAsString();
      Map<String, dynamic> data = json.decode(requestData);
      return (await receiptController.getUserReceipts(data['id'])).response;
    });
    router.post('/receipts', (Request request) async {
      String requestData = await request.readAsString();

      final Receipt receipt = Receipt.fromJson(requestData);

      return (await receiptController.setReceipt(receipt)).response;
    });
    
    // router.put('/receipts', (Request request) async {
    //   String requestData = await request.readAsString();
    //   final data = json.decode(requestData) as Map<String, dynamic>;
    //   return (await receiptController.updateReceipt(data)).response;

    // });

    router.delete('/receipts', (Request request) async {
      String requestData = await request.readAsString();

      final data = json.decode(requestData) as Map<String, dynamic>;

      return (await receiptController.deletReceipt(data['id'])).response;
    });
    return router;
  }
}
