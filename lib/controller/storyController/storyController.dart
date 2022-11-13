import 'dart:convert';

import 'package:backend/models/story.model.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

import '../../core/database/db_configuration.dart';
import '../../core/dependecy_injector/injectors.dart';
import '../../core/responseResult.dart';
import '../../header.dart';
import '../../models/category.model.dart';
import '../../models/products.dart';
import '../productController/products_controller.dart';

class StoreState {
  StoreState({required this.response, this.data});
  Response response;
  dynamic? data;
}

class StoryStateSucess extends StoreState {
  StoryStateSucess({required Response response, dynamic? data})
      : super(response: response, data: data);
}

class StoryStateError extends StoreState {
  StoryStateError({required Response response}) : super(response: response);
}

class StoryController {
  final _di = Injects.initialize();

  Future<StoreState> getStoryById(int id) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results result = await conexao.query("SELECT * FROM stories WHERE id=$id");

    if (result.isEmpty) {
      String responseBody = jsonEncode({
        'error': 'loja não existe',
      });
      return StoryStateError(
          response: Response(
        404,
        body: responseBody,
        headers: Header.header,
      ));
    }
    try {
      Story story = Story.fromMap(result.first.fields);
      return StoryStateSucess(
          response: Response(
            200,
            body: story.toJson().toString(),
            headers: Header.header,
          ),
          data: story);
    } catch (e, _) {
      print(_);
      return StoryStateError(
          response: Response(
        500,
        body: e.toString(),
      ));
    }
  }

  Future<StoreState> getAll() async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results allResult = await conexao.query("SELECT * FROM stories");

    try {
      List<Story> stories = [];
      for (var result in allResult) {
        Story story = Story.fromMap(result.fields);
        story.productList = await _getProductsByStoryId(story.id!);
        stories.add(story);
      }
      return StoryStateSucess(
          response: Response(
        200,
        body: stories.map((e) => e.toJson()).toList().toString(),
        headers: Header.header,
      ));
    } catch (e, _) {
      print(_);
      return StoryStateError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }

  Future<StoreState> setStory(Story story) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    try {
      Results setResult = await conexao.query(
          "insert into stories (name,category_id,pix,paymentType,totalPrice,isBlocked) values (?,?,?,?,?,?)",
          [
            story.name,
            story.category_id,
            story.pix,
            story.paymentType,
            story.totalPrice,
            story.isBlocked
          ]);
      return StoryStateSucess(
          response: Response(
        201,
        body: getResultMapString(ResultResponse.created),
        headers: Header.header,
      ));
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return StoryStateError(
          response: Response(
        500,
        body: e.toString(),
        headers: Header.header,
      ));
    }
  }

  Future<StoreState> updateStory(
    Map<String, dynamic> data,
  ) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    StoreState storyState = await getStoryById(data['id']);
    Story story = storyState.data as Story;
    try {
      Results categoryResult = await conexao.query(
          'Update stories set name =? , category_id =?, pix =? , paymentType =? ,totalPrice =?, isBlocked =? where id =?',
          [
            data['name'] ?? story.name,
            data['category_id'] ?? story.category_id,
            data['pix'] ?? story.pix,
            data['paymentType'] ?? story.paymentType,
            data['totalPrice'] ?? story.totalPrice,
            data['isBlocked'] ?? story.isBlocked,
            data['id']
          ]);
      return StoryStateSucess(
          response: Response(
        204,
        body: getResultMapString(ResultResponse.updated),
        headers: Header.header,
      ));
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return StoryStateError(
          response: Response(
        500,
        body: responseBody,
        headers: Header.header,
      ));
    }
  }

  Future<StoreState> deletCategory(
    int id,
  ) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    try {
      Results categoryResult =
          await conexao.query('Delete from stories where id=?', [id]);

      return StoryStateSucess(
          response: Response(
        202,
        body: getResultMapString(ResultResponse.deleted),
        headers: Header.header,
      ));
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return StoryStateError(
          response: Response(
        500,
        body: responseBody,
        headers: Header.header,
      ));
    }
  }

  Future<List<Product>> _getProductsByStoryId(int? id) async {
    if (id == null) {
      return [];
    }
    ProductController productController = ProductController();
    ProductState state = await productController.getAllByStoreId(id);
    if (state is ProductStateSucess) {
      return state.data as List<Product>;
    } else {
      return [];
    }
  }
}
