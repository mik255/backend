import 'dart:convert';

import 'package:backend/controller/productController/products_controller.dart';
import 'package:backend/models/category.model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/products.dart';

class ProductHandle {
  Handler get handler {
    Router router = Router();
    ProductController productController = ProductController();
    router.get('/product', (Request request) async {
      String requestData = await request.readAsString();
      Map<String, dynamic> data = json.decode(requestData);

      return (await productController.getProductById(data['id'])).response;
    });
    router.get('/product/all', (Request request) async {
      return (await productController.getAll()).response;
    });
    router.post('/product/create', (Request request) async {
      String requestData = await request.readAsString();

      final Product product = Product.fromJson(requestData);

      return (await productController.setProduct(product)).response;
    });
    router.put('/product/update', (Request request) async {
      String requestData = await request.readAsString();

      final data = json.decode(requestData) as Map<String, dynamic>;

      return (await productController.updateProduct(data)).response;
    });

    router.delete('/product/delete', (Request request) async {
      String requestData = await request.readAsString();

      final data = json.decode(requestData) as Map<String, dynamic>;

      return (await productController.deletCategory(data['id'])).response;
    });
    return router;
  }
}
