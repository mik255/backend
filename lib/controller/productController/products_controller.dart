import 'dart:convert';

import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

import '../../core/database/db_configuration.dart';
import '../../core/dependecy_injector/injectors.dart';
import '../../core/responseResult.dart';
import '../../header.dart';
import '../../models/category.model.dart';
import '../../models/products.dart';

class ProductState {
  ProductState({required this.response, this.data});
  Response response;
  dynamic? data;
}

class ProductStateSucess extends ProductState {
  ProductStateSucess({required Response response, dynamic data})
      : super(response: response, data: data);
}

class ProductStateError extends ProductState {
  ProductStateError({required Response response}) : super(response: response);
}

class ProductController {
  final _di = Injects.initialize();

  Future<ProductState> getProductById(int id) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results result = await conexao.query("SELECT * FROM products WHERE id=$id");

    if (result.isEmpty) {
      String responseBody = jsonEncode({
        'error': 'produto não existe',
      });
      return ProductStateError(
          response: Response(
        404,
        body: responseBody,
        headers: Header.header,
      ));
    }
    try {
      Product product = Product.fromMap(result.first.fields);
      return ProductStateSucess(
          response: Response(
            200,
            body: product.toJson().toString(),
            headers: Header.header,
          ),
          data: product);
    } catch (e, _) {
      print(_);
      return ProductStateError(
          response: Response(
        500,
        body: e.toString(),
      ));
    }
  }

  Future<ProductState> getAllByStoreId(int id) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results allResult =
        await conexao.query("SELECT * FROM products where store_id = $id");

    try {
      List<Product> products = [];
      for (var result in allResult) {
        Product product = Product.fromMap(result.fields);
        products.add(product);
      }
      return ProductStateSucess(
          response: Response(
            200,
            body: products.map((e) => e.toJson()).toList().toString(),
            headers: Header.header,
          ),
          data: products);
    } catch (e, _) {
      print(_);
      return ProductStateError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }

  Future<ProductState> getAll() async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results allResult = await conexao.query("SELECT * FROM products");

    if (allResult.isEmpty) {
      String responseBody = jsonEncode({
        'error': 'lista de produtos esta vazia',
      });
      return ProductStateSucess(
          response: Response(
        200,
        body: responseBody,
        headers: Header.header,
      ));
    }
    try {
      List<Product> products = [];
      for (var result in allResult) {
        Product product = Product.fromMap(result.fields);
        products.add(product);
      }
      return ProductStateSucess(
          response: Response(
        200,
        body: products.map((e) => e.toJson()).toList().toString(),
        headers: Header.header,
      ));
    } catch (e, _) {
      print(_);
      return ProductStateError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }

  Future<ProductState> setProduct(Product product) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    try {
      Results setResult = await conexao.query(
          "insert into products (store_id,name,price,count,stock,squerePrice,urlImg,isBlocked) values (?,?,?,?,?,?,?,?)",
          [
            product.store_id,
            product.name,
            product.price,
            product.count,
            product.stock,
            product.squerePrice,
            product.urlImg,
            product.isBlocked,
          ]);
      return ProductStateSucess(
          response: Response(
        201,
        body: getResultMapString(ResultResponse.created),
        headers: Header.header,
      ));
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return ProductStateError(
          response: Response(
        500,
        body: e.toString(),
        headers: Header.header,
      ));
    }
  }

  Future<ProductState> updateProduct(
    Map<String, dynamic> data,
  ) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    ProductState productState = await getProductById(data['id']);
    Product product = productState.data as Product;
    try {
      Results categoryResult = await conexao.query(
          'Update products set name =?, '
          'price =? , count =? , stock =? , squerePrice =? ,urlImg =?, store_id=? where id =?',
          [
            data['name'] ?? product.name,
            data['price'] ?? product.price,
            data['count'] ?? product.count,
            data['stock'] ?? product.stock,
            data['squerePrice'] ?? product.squerePrice,
            data['urlImg'] ?? product.urlImg,
            data['store_id'] ?? product.store_id,
            data['id']
          ]);
      return ProductStateSucess(
          response: Response(
        204,
        body: getResultMapString(ResultResponse.updated),
        headers: Header.header,
      ));
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return ProductStateError(
          response: Response(
        500,
        body: responseBody,
        headers: Header.header,
      ));
    }
  }

  Future<ProductState> deletCategory(
    int id,
  ) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    try {
      Results categoryResult =
          await conexao.query('Delete from products where id=?', [id]);

      return ProductStateSucess(
          response: Response(
        202,
        body: getResultMapString(ResultResponse.deleted),
        headers: Header.header,
      ));
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return ProductStateError(
          response: Response(
        500,
        body: responseBody,
        headers: Header.header,
      ));
    }
  }
}
