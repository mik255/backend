import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'categoryController.dart';

class CategoryHandle {
  Handler get handler {
    Router router = Router();
    router.get('/category', (Request request) async {
      CategoryController categoryController = CategoryController();

      String requestData = await request.readAsString();
      Map<String, dynamic> data = json.decode(requestData);

      return (await categoryController.getCategoryById(data['id'])).response;
    });
    router.get('/category/all', (Request request) async {
      CategoryController categoryController = CategoryController();
      return (await categoryController.getAll()).response;
    });
    return router;
  }
}
