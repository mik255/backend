// ignore: file_names
// ignore: file_names
import 'dart:convert';
import 'package:backend/core/database/db_configuration.dart';
import 'package:backend/core/dependecy_injector/injectors.dart';
import 'package:backend/header.dart';
import 'package:backend/models/user.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

import '../../models/credentials.dart';

class UserState {
  UserState({required this.response});
  Response response;
}

class UserSucess extends UserState {
  UserSucess({required Response response}) : super(response: response);
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


}
