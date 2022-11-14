import 'dart:convert';

import 'package:backend/models/category.model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'categoryController.dart';

class CategoryHandle {
  Handler get handler {
    Router router = Router();
    CategoryController categoryController = CategoryController();
    router.get('/category/id', (Request request) async {
      String requestData = await request.readAsString();
      Map<String, dynamic> data = json.decode(requestData);

      return (await categoryController.getCategoryById(data['id'])).response;
    });
    router.get('/category', (Request request) async {
      return (await categoryController.getAll()).response;
    });
    router.post('/category', (Request request) async {
      String requestData = await request.readAsString();

      final Category category = Category.fromJson(requestData);

      return (await categoryController.setCategory(category)).response;
    });
    router.put('/category', (Request request) async {
      String requestData = await request.readAsString();

      final data = json.decode(requestData) as Map<String, dynamic>;

      return (await categoryController.updateCategory(data)).response;
    });

    router.delete('/category', (Request request) async {
      String requestData = await request.readAsString();

      final data = json.decode(requestData) as Map<String, dynamic>;

      return (await categoryController.deletCategory(data['id'])).response;
    });
    return router;
  }
}
