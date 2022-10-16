import 'dart:convert';

import 'package:backend/models/credentials.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'userController.dart';

class UserHandle {
  Handler get handler {
    Router router = Router();
    router.post('/login', (Request request) async {
      UserController userController = UserController();

      String requestData = await request.readAsString();
      Map<String, dynamic> data = json.decode(requestData);

      final Credentials credentials = Credentials.fromJson(data);

      return (await userController.login(credentials)).response;
    });
    return router;
  }
}
