// ignore: file_names
// ignore: file_names
import 'dart:convert';
import 'package:backend/controller/categoryController/categoryController.dart';
import 'package:backend/core/database/db_configuration.dart';
import 'package:backend/core/dependecy_injector/injectors.dart';
import 'package:backend/header.dart';
import 'package:backend/models/category.model.dart';
import 'package:backend/models/products.dart';
import 'package:backend/models/story.model.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

import '../../models/receipt.dart';
import '../storyController/storyController.dart';

class ReceiptState {
  ReceiptState({required this.response, this.data});
  Response response;
  dynamic data;
}

class ReceiptStateSucess extends ReceiptState {
  ReceiptStateSucess({required Response response, dynamic data})
      : super(response: response, data: data);
}

class ReceiptStateError extends ReceiptState {
  ReceiptStateError({required Response response}) : super(response: response);
}

class ReceiptController {
  final _di = Injects.initialize();

  Future<ReceiptState> getReceiptById(int id) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    late Results receiptResult;
    try {
      receiptResult =
          await conexao.query("SELECT * FROM receipts WHERE id=$id");
          Receipt receipt = Receipt.fromMap(receiptResult.last.fields);
          receipt.attributes.stories = await getStoriesWithReceiptId(id,conexao);
      return ReceiptStateSucess(
          response: Response(
            200,
            body: receipt.toJson().toString(),
            headers: Header.header,
          ),
          data: Receipt);
    } catch (e) {
      if (receiptResult.isEmpty) {
        String responseBody = jsonEncode({
          'error': 'receipt não existe',
        });
        return ReceiptStateError(
            response: Response(
          404,
          body: responseBody,
          headers: Header.header,
        ));
      }
    }
    return ReceiptStateError(
        response: Response(
      500,
      body: '{"sucess":false}',
      headers: Header.header,
    ));
  }

Future<ReceiptState> getUserReceipts(int id) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results receiptsResult = await conexao.query("select * from receipts where user_id =$id");

    try {
      List<Receipt> receipts = [];
      for (var result in receiptsResult) {
        Receipt receipt = Receipt.fromMap(result.fields);
        receipts.add(receipt);
      }
      return ReceiptStateSucess(
          response: Response(
            200,
            body:
                receipts.map((e) => json.encode(e.toMap())).toList().toString(),
            headers: Header.header,
          ),
          data: receipts);
    } catch (e, _) {
      print('receipts error [ mika]');
      print(e);
      print(_);
      return ReceiptStateError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }

Future<ReceiptState> getUserReceiptsByDate(int id,String start,String end) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results receiptsResult = await conexao.query("select * from receipts where user_id =$id and dt_criacao BETWEEN $start and $end");

    try {
      List<Receipt> receipts = [];
      for (var result in receiptsResult) {
        Receipt receipt = Receipt.fromMap(result.fields);
        receipts.add(receipt);
      }
      return ReceiptStateSucess(
          response: Response(
            200,
            body:
                receipts.map((e) => json.encode(e.toMap())).toList().toString(),
            headers: Header.header,
          ),
          data: receipts);
    } catch (e, _) {
      print('receipts error [ mika]');
      print(e);
      print(_);
      return ReceiptStateError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }


  Future<ReceiptState> getAll() async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results receiptsResult = await conexao.query("SELECT * FROM receipts");

    try {
      List<Receipt> receipts = [];
      for (var result in receiptsResult) {
        Receipt receipt = Receipt.fromMap(result.fields);
        receipts.add(receipt);
      }
      return ReceiptStateSucess(
          response: Response(
            200,
            body:
                receipts.map((e) => json.encode(e.toMap())).toList().toString(),
            headers: Header.header,
          ),
          data: receipts);
    } catch (e, _) {
      print('receipts error [ mika]');
      print(e);
      print(_);
      return ReceiptStateError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }

Future<ReceiptState> getAllByUserId(int id) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results receiptsResult = await conexao.query("SELECT * FROM receipts where user_id = $id");

    try {
      List<Receipt> receipts = [];
      for (var result in receiptsResult) {
        Receipt receipt = Receipt.fromMap(result.fields);
        receipts.add(receipt);
      }
      return ReceiptStateSucess(
          response: Response(
            200,
            body:
                receipts.map((e) => json.encode(e.toMap())).toList().toString(),
            headers: Header.header,
          ),
          data: receipts);
    } catch (e, _) {
      print('receipts error [ mika]');
      print(e);
      print(_);
      return ReceiptStateError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }


  Future<ReceiptState> getLast() async {
    try {
      var conexao = await _di.get<DbConfiguration>().connection;

      Results receiptResult = await conexao
          .query("SELECT * FROM receipts ORDER BY ID DESC LIMIT 1");
      Receipt receipt = Receipt.fromMap(receiptResult.first.fields);

      return ReceiptStateSucess(
          response: Response(
            200,
            body: receipt.toJson().toString(),
            headers: Header.header,
          ),
          data: receipt);
    } catch (e, _) {
      print('receipts error [ mika]');
      print(e);
      print(_);
      return ReceiptStateError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }

  Future<ReceiptState> setReceipt(Receipt receipt) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    Map<String,dynamic> stories = {};
    stories['stories'] = receipt.attributes.stories.map((e) => e.toJson()).toList();
    print(json.encode(stories));
    try {
      Results categoryResult = await conexao.query(
          "insert into receipts (observation,paymentType,category_id,user_id,totalPrice,attributes) values (?,?,?,?,?,?)",
          [receipt.observation,
          receipt.paymentType,
           receipt.category_id,
           receipt.user_id,
            receipt.totalPrice,
            json.encode(stories),
            ]);

      return ReceiptStateSucess(
          response: Response(
            200,
            body: receipt.toJson().toString(),
            headers: Header.header,
          ),
          data: receipt);
    } catch (e,_) {
           print('receipts error [ mika]');
      print(e);
      print(_);
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return ReceiptStateError(
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
      StoreState state = await storyController.updateMultReceiptStory(data);
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

  Future<List<Story>> getStoriesWithReceiptId(int id,MySqlConnection conexao) async {
    try {
      StoryController storyController = StoryController();
      Results storiesResult = await conexao.query(
          "select distinct * from stories x inner join receipts_join_stories sc on sc.receipt_id = ${id} and x.id=sc.story_id;");
      List<Story> stories = [];
      for (var result in storiesResult) {
        Story story = Story.fromMap(result.fields);
        story.productList =
            await storyController.getProductsByStoryId(story.id,conexao);
        stories.add(story);
      }
      return stories;
    } catch (e,_) {
      print(e);
      print(_);
      return [];
    }
  }
  Future<ReceiptState> deletReceipt(
    int id,
  ) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    try {
      Results categoryResult =
          await conexao.query('Delete from receipts where id=?', [id]);

      return ReceiptStateSucess(
        response: Response(
          200,
          body: '{"sucess":true}',
          headers: Header.header,
        ),
      );
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return ReceiptStateError(
          response: Response(
        500,
        body: responseBody,
        headers: Header.header,
      ));
    }
  }

  List<dynamic> getStoryWithReceiptMap(
      int receipt_id, List<dynamic> stories_ids) {
    return stories_ids
        .map(
          (e) => {'story_id': e as int, 'receipt_id': receipt_id},
        )
        .toList();
  }
}
