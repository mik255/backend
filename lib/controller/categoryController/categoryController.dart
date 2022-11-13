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

import '../storyController/storyController.dart';

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

    try {
      List<Category> categories = [];
      for (var result in categoryResult) {
        Category category = Category.fromMap(result.fields);

        Results storiesResult = await conexao
            .query("SELECT * FROM stories WHERE category_id=${category.id}");

        for (var storyData in storiesResult) {
          Story story = Story.fromMap(storyData.fields);
          Results productsResult = await conexao
              .query("SELECT * FROM products WHERE store_id=${story.id}");
          story.productList =
              productsResult.map((e) => Product.fromMap(e.fields)).toList();
          category.stories.add(story);
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

  Future<CategoryState> setCategory(Category category) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    try {
      Results categoryResult = await conexao.query(
          "insert into categories (name,isBlocked) values (?,?)",
          [category.name, category.isBlocked]);
      return getAll();
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return CategoryStateError(
          response: Response(
        500,
        body: responseBody,
        headers: Header.header,
      ));
    }
  }

  Future<CategoryState> updateCategory(
    Map<String, dynamic> data,
  ) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    try {
      Results categoryResult = await conexao.query(
          'Update categories set name =? , isBlocked =?  where id =?',
          [data['name'], data['isBlocked'], data['id']]);

      return getAll();
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return CategoryStateError(
          response: Response(
        500,
        body: responseBody,
        headers: Header.header,
      ));
    }
  }

  Future<CategoryState> deletCategory(
    int id,
  ) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    try {
      Results categoryResult =
          await conexao.query('Delete from categories where id=?', [id]);

      return getAll();
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return CategoryStateError(
          response: Response(
        500,
        body: responseBody,
        headers: Header.header,
      ));
    }
  }
}
