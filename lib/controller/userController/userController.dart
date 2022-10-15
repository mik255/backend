// ignore: file_names
// ignore: file_names
import 'dart:convert';
import 'package:backend/header.dart';
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
  LoginState login(Credentials credentials) {
    if (credentials.cnpj == 123 && credentials.password == '321') {
      String data = jsonEncode(credentials.toJson());
      return LoginSucess(
          response: Response(
        200,
        body: data,
        headers: Header.header,
      ));
    }
    return LoginError(
        response: Response(
      404,
      body: 'error',
    ));
  }
}
