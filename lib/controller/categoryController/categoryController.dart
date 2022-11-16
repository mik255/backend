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
  CategoryState({required this.response,this.data});
  Response response;
  dynamic data;
}

class CategoryStateSucess extends CategoryState {
  CategoryStateSucess({required Response response,dynamic data}) : super(response: response,data: data);
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

        Results storiesResult = await conexao.query(
            "select distinct * from stories x inner join story_join_category sc on sc.category_id = ${category.id} and x.id=sc.story_id;");

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
        body: categories.map((e) => json.encode(e.toMap())).toList().toString(),
        headers: Header.header,
      ),data:categories );
    } catch (e, _) {
      print('category error [ mika]');
      print(e);
      print(_);
      return CategoryStateError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }

Future<CategoryState> getLast() async {
  

    try {
        var conexao = await _di.get<DbConfiguration>().connection;

    Results categoryResult = await conexao.query("SELECT * FROM categories ORDER BY ID DESC LIMIT 1");
       Category category = Category.fromMap(categoryResult.first.fields);

      return CategoryStateSucess(
          response: Response(
        200,
        body: category.toJson().toString(),
        headers: Header.header,
      ),data:category );
    } catch (e, _) {
      print('category error [ mika]');
      print(e);
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
    print(category.toJson());
    try {
      Results categoryResult = await conexao.query(
          "insert into categories (name,isBlocked) values (?,?)",[category.name, category.isBlocked ? 1 : 0]);
          CategoryState lastCategory =  await getLast();
          Category newCategory = lastCategory.data;
          List<dynamic> storiesCategories = getStoryWithCategoryMap(newCategory.id!,category.stories_ids);
      await setStories(storiesCategories);
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
          [data['name'], data['isBlocked'] ? 1 : 0, data['id']]);
        
       Results categoryRemove = await conexao.query('Delete from story_join_category where category_id=?', [data['id']]);
       List<dynamic> storiesCategories = getStoryWithCategoryMap(data['id'],data['stories_ids']);
      await setStories(storiesCategories);
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

  Future<CategoryState> setStories(List<dynamic> data) async {
    try {
      StoryController storyController = StoryController();
      StoreState state = await storyController.updateMultCategoryStory(data);
      if (state is StoryStateSucess) {
        return CategoryStateSucess(
            response: Response(
          200,
          body: {'sucess': true}.toString(),
          headers: Header.header,
        ));
      }
      return CategoryStateError(
          response: Response(
        500,
        body: await state.response.readAsString(),
        headers: Header.header,
      ));
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

  List<dynamic> getStoryWithCategoryMap(int category_id,List<dynamic> stories_ids) {
    return stories_ids
        .map(
          ( e) => {'story_id': e as int, 'category_id': category_id},
        )
        .toList();
  }
}
