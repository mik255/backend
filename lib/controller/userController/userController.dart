// ignore: file_names
// ignore: file_names
import 'dart:convert';
import 'package:backend/core/database/db_configuration.dart';
import 'package:backend/core/dependecy_injector/injectors.dart';
import 'package:backend/core/responseResult.dart';
import 'package:backend/header.dart';
import 'package:backend/models/user.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

import '../../models/credentials.dart';

class UserState {
  UserState({required this.response,this.data});
  Response response;
  dynamic data;
}

class UserSucess extends UserState {
  UserSucess({required Response response,dynamic data}) : super(response: response,data: data);
}

class UserError extends UserState {
  UserError({required Response response}) : super(response: response);
}

class UserController {
  final _di = Injects.initialize();

  
 Future<UserState> getAll() async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results allResult = await conexao.query("SELECT * FROM users");

    try {
      List<User> users = [];
      for (var result in allResult) {
        User user = User.fromMap(result.fields);
        users.add(user);
      }
      return UserSucess(
          response: Response(
        200,
        body: users.map((e) => e.toJson()).toList().toString(),
        headers: Header.header,
      ));
    } catch (e, _) {
      print(_);
      return UserError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }

Future<UserState> setUser(User user) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    try {
      Results setResult = await conexao.query(
          "insert into users (nome,cnpj,password) values (?,?,?)",
          [
            user.nome,
            user.cnpj,
            user.password,
          ]);
      return UserSucess(
          response: Response(
        200,
        body: user.toJson(),
        headers: Header.header,
      ));
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return UserError(
          response: Response(
        500,
        body: e.toString(),
        headers: Header.header,
      ));
    }
  }
Future<UserState> getById(int id) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results result = await conexao.query("SELECT * FROM users WHERE id=$id");

    if (result.isEmpty) {
      String responseBody = jsonEncode({
        'error': 'user não existe',
      });
      return UserError(
          response: Response(
        404,
        body: responseBody,
        headers: Header.header,
      ));
    }
    try {
      User product = User.fromMap(result.first.fields);
      return UserSucess(
          response: Response(
            200,
            body: product.toJson().toString(),
            headers: Header.header,
          ),
          data: product);
    } catch (e, _) {
      print(_);
      return UserError(
          response: Response(
        500,
        body: e.toString(),
      ));
    }
  }


Future<UserState> updateUser(
    Map<String, dynamic> data,
  ) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    User user = (await getById(data['id'])).data;

    try {
      Results categoryResult = await conexao.query(
          'Update users set nome =?, '
          'cnpj =? , password =?  where id =?',
          [
            data['nome'] ?? user.nome,
            data['cnpj'] ?? user.cnpj,
            data['password'] ?? user.password,
            data['id']
          ]);
      return UserSucess(
          response: Response(
        204,
        body: getResultMapString(ResultResponse.updated),
        headers: Header.header,
      ));
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return UserError(
          response: Response(
        500,
        body: responseBody,
        headers: Header.header,
      ));
    }
  }

  Future<UserState> delete(
    int id,
  ) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    try {
      Results categoryResult =
          await conexao.query('Delete from users where id=?', [id]);

      return UserSucess(
          response: Response(
        202,
        body: getResultMapString(ResultResponse.deleted),
        headers: Header.header,
      ));
    } catch (e) {
      String responseBody = jsonEncode({
        'error': e.toString(),
      });
      return UserError(
          response: Response(
        500,
        body: responseBody,
        headers: Header.header,
      ));
    }
  }
  
}
