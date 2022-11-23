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
        story.productList = await getProductsByStoryId(story.id!,conexao);
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


Future<StoreState> getLast() async {
    try {
        var conexao = await _di.get<DbConfiguration>().connection;

    Results storyResult = await conexao.query("SELECT * FROM stories ORDER BY ID DESC LIMIT 1");
       Story story = Story.fromMap(storyResult.first.fields);

      return StoryStateSucess(
          response: Response(
        200,
        body: story.toJson().toString(),
        headers: Header.header,
      ),data:story );
    } catch (e, _) {
      print('stories error [ mika]');
      print(e);
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
          "insert into stories (name,pix,paymentType,totalPrice,isBlocked) values (?,?,?,?,?)",
          [
            story.name,
            story.pix,
            story.paymentType,
            story.totalPrice,
            story.isBlocked
          ]);
           StoreState lastStory =  await getLast();
          Story newStory = lastStory.data;
          List<dynamic> storiesCategories = getStoryWithProductsMap(newStory.id!,story.products_ids);
      await setProducts(storiesCategories,conexao);
      return getAll();
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
    print(data);
    var conexao = await _di.get<DbConfiguration>().connection;
    StoreState storyState = await getStoryById(data['id']);
    Story story = storyState.data as Story;
    try {
      Results categoryResult = await conexao.query(
          'Update stories set name =?, pix =?, paymentType =?, totalPrice =?, isBlocked =? where id =?',
          [
            data['name'] ?? story.name,
            data['pix'] ?? story.pix,
            data['paymentType'] ?? story.paymentType,
            data['totalPrice'] ?? story.totalPrice,
            data['isBlocked'] ?? story.isBlocked,
            data['id']
          ]);
       Results storyRemove = await conexao.query('Delete from products_join_stories where story_id=?', [data['id']]);
       List<dynamic> storiesWithProductsMap = getStoryWithProductsMap(data['id'],data['products_ids']??[]);
      await setProducts(storiesWithProductsMap,conexao);
       return StoryStateSucess(
          response: Response(
        200,
        body: getResultMapString(ResultResponse.updated),
        headers: Header.header,
      ));
    } catch (e,_) {
      print(e);
      print(_);
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

    Future<StoreState> updateMultCategoryStory(
    List<dynamic> data,
  ) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    try {
      List<Results> categoryResult = await conexao.queryMulti(
          'INSERT INTO story_join_category (story_id,category_id) VALUES(?, ?);',
          data.map((e) => [e['story_id'],e['category_id']]).toList()
         );
         
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

    Future<StoreState> updateMultReceiptStory(
    List<dynamic> data,
  ) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    try {
      List<Results> receiptsResult = await conexao.queryMulti(
          'INSERT INTO receipts_join_stories (story_id,receipt_id) VALUES(?, ?);',
          data.map((e) => [e['story_id'],e['receipt_id']]).toList()
         );
         
        return StoryStateSucess(
          response: Response(
        200,
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

  Future<List<Product>> getProductsByStoryId(int? id,MySqlConnection conexao) async {
    if (id == null) {
      return [];
    }
    ProductController productController = ProductController();
    ProductState state = await productController.getAllByStoreId(id,conexao);
    if (state is ProductStateSucess) {
      return state.data as List<Product>;
    } else {
      return [];
    }
  }
    List<dynamic> getStoryWithProductsMap(int store_id,List<dynamic> products_ids) {
    return products_ids
        .map(
          ( e) => {'product_id': e as int, 'story_id': store_id},
        )
        .toList();
  }
  Future<StoreState> setProducts(List<dynamic> data,MySqlConnection conexao) async {
    try {
      ProductController productController = ProductController();
      ProductState state = await productController.updateMultCategoryStory(data,conexao);
      if (state is ProductStateSucess) {
        return StoryStateSucess(
            response: Response(
          200,
          body: {'sucess': true}.toString(),
          headers: Header.header,
        ));
      }
      return StoryStateError(
          response: Response(
        500,
        body: await state.response.readAsString(),
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

   Future<StoreState> setMultStories(List<Story> stories)async{
  var conexao = await _di.get<DbConfiguration>().connection;
  ProductController productController = ProductController();
    try {
      await Future.wait(stories.map((e) => Future.wait(e.productList!.map((e) async=> 
      await productController.setProduct(e)))));
      await Future.wait(stories.map((e) => setStory(e)));
         
        return StoryStateSucess(
          response: Response(
        200,
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
}
