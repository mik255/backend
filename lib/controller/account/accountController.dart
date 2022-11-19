
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

import '../../core/database/db_configuration.dart';
import '../../core/dependecy_injector/injectors.dart';
import '../../header.dart';
import '../../models/user.dart';

class AccountState{
  AccountState({required this.response});
  Response response;
}
class AccountLoginSucess extends AccountState{
  AccountLoginSucess({required Response response}) : super(response: response);

}
class AccountLoginError extends AccountState{
  AccountLoginError({required Response response}) : super(response: response);
}

class AccountController {
    final _di = Injects.initialize();
  Future<AccountState> login(User user) async {
    var conexao = await _di.get<DbConfiguration>().connection;

    Results results = await conexao.query("select * from users where password = '${user.password}' and cnpj = ${user.cnpj};");

    try {

      if (results.fields.isNotEmpty) {
      return AccountLoginSucess(
          response: Response(
            200,
            body: '{"sucess":true}',
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
} 