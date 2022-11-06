// ignore: file_names
// ignore: file_names
import 'dart:convert';
import 'package:backend/core/database/db_configuration.dart';
import 'package:backend/core/dependecy_injector/injectors.dart';
import 'package:backend/header.dart';
import 'package:backend/models/category.model.dart';
import 'package:backend/models/products.dart';
import 'package:backend/models/story.model.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

class CategoryState {
  CategoryState({required this.response});
  Response response;
}

class CategoryStateSucess extends CategoryState {
  CategoryStateSucess({required Response response}) : super(response: response);
}

class CategoryStateError extends CategoryState {
  CategoryStateError({required Response response}) : super(response: response);
}

class CategoryController {
  final _di = Injects.initialize();

  Future<CategoryState> getCategoryById(int id) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results categoryResult =
        await conexao.query("SELECT * FROM categories WHERE id=$id");

    if (categoryResult.isEmpty) {
      String responseBody = jsonEncode({
        'error': 'categoria não existe',
      });
      return CategoryStateError(
          response: Response(
        404,
        body: responseBody,
        headers: Header.header,
      ));
    }
    try {
      Category category = Category.fromMap(categoryResult.first.fields);
      Results storiesResult =
          await conexao.query("SELECT * FROM stories WHERE id=${category.id}");

      for (var element in storiesResult) {
        category.stories.add(Story.fromMap(element.fields));
      }

      for (var element in category.stories) {
        Results productsResult = await conexao
            .query("SELECT * FROM products WHERE story_id=${element.id}");
        element.productList =
            productsResult.map((e) => Product.fromMap(e.fields)).toList();
      }

      return CategoryStateSucess(
          response: Response(
        200,
        body: category.toJson().toString(),
        headers: Header.header,
      ));
    } catch (e, _) {
      print(_);
      return CategoryStateError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }

  Future<CategoryState> getAll() async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results categoryResult = await conexao.query("SELECT * FROM categories");

    if (categoryResult.isEmpty) {
      String responseBody = jsonEncode({
        'error': 'categoria esta vazia',
      });
      return CategoryStateError(
          response: Response(
        200,
        body: responseBody,
        headers: Header.header,
      ));
    }
    try {
      List<Category> categories = [];
      for (var result in categoryResult) {
        Category category = Category.fromMap(result.fields);
        Results storiesResult = await conexao
            .query("SELECT * FROM stories WHERE category_id=${category.id}");

        for (var element in storiesResult) {
          category.stories.add(Story.fromMap(element.fields));
        }

        for (var element in category.stories) {
          Results productsResult = await conexao
              .query("SELECT * FROM products WHERE story_id=${element.id}");
          element.productList =
              productsResult.map((e) => Product.fromMap(e.fields)).toList();
        }
        categories.add(category);
      }
      return CategoryStateSucess(
          response: Response(
        200,
        body: categories.map((e) => e.toJson()).toList().toString(),
        headers: Header.header,
      ));
    } catch (e, _) {
      print(_);
      return CategoryStateError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }
}
