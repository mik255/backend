
import 'dart:convert';

import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

import '../../core/database/db_configuration.dart';
import '../../core/dependecy_injector/injectors.dart';
import '../../header.dart';
import '../../models/user.dart';

class AccountState{
  AccountState({required this.response,this.data});
  Response response;
  dynamic data;
}
class AccountLoginSucess extends AccountState{
  AccountLoginSucess({required Response response,dynamic data }) : super(response: response,data: data);

}
class AccountLoginError extends AccountState{
  AccountLoginError({required Response response}) : super(response: response);
}

class AccountController {
    final _di = Injects.initialize();
  Future<AccountState> login(User useData) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results results = await conexao.query("select * from users where password = '${useData.password}' and cnpj = ${useData.cnpj};");
   
    User user = User.fromMap(results.first.fields);

    try {

      if (results.fields.isNotEmpty) {
      return AccountLoginSucess(
          response: Response(
            200,
            body: user.toJson().toString(),
            headers: Header.header,
          ),);
    }
    
    } catch (e, _) {
      print('login error [ mika]');
      print(e);
      print(_);
      return AccountLoginError(
           response: Response(
            500,
            body: '{"sucess":false}',
            headers: Header.header,
          )
      );
    }
          return AccountLoginError(
               response: Response(
            500,
            body: '{"sucess":true}',
            headers: Header.header,
          )
          );
  }
   Future<AccountState> getLast() async {
    try {
      var conexao = await _di.get<DbConfiguration>().connection;

      Results result = await conexao
          .query("SELECT * FROM users ORDER BY ID DESC LIMIT 1");
      User user = User.fromMap(result.first.fields);
    
      return AccountLoginSucess(
          response: Response(
            200,
            body: user.toJson().toString(),
            headers: Header.header,
          ),
          data: user);
    } catch (e, _) {
      print('category error [ mika]');
      print(e);
      print(_);
      return AccountLoginError(
          response: Response(
        404,
        body: e.toString(),
      ));
    }
  }
} 