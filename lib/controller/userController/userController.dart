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

class LoginState {
  LoginState({required this.response});
  Response response;
}

class LoginSucess extends LoginState {
  LoginSucess({required Response response}) : super(response: response);
}

class LoginError extends LoginState {
  LoginError({required Response response}) : super(response: response);
}

class UserController {
  final _di = Injects.initialize();

  Future<LoginState> login(Credentials credentials) async {
    var conexao = await _di.get<DbConfiguration>().connection;
    int cnpj = credentials.cnpj!;
    String password = credentials.password!;
    Results result = await conexao.query(
        "SELECT * FROM users WHERE cnpj='${cnpj.toString()}' AND password='$password'");
      print(result.first.fields);
    if (result.isEmpty) {
      String responseBody = jsonEncode({
        'error': 'senha/email incorretas ou usuário não existe',
      });
      return LoginError(
          response: Response(
        404,
        body: responseBody,
        headers: Header.header,
      ));
    }
    try {
      User user = User.fromMap(result.first.fields);

      return LoginSucess(
          response: Response(
        200,
        body: user.toJson().toString(),
        headers: Header.header,
      ));
    } catch (e, _) {
      print(_);
      return LoginError(
          response: Response(
        200,
        body: e.toString(),
      ));
    }
  }
}
