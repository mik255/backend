import 'dart:convert';

import 'package:backend/models/credentials.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'userController.dart';

class UserHandle {
  Handler get handler {
    Router router = Router();
    router.get('/users', (Request request) async {
      UserController userController = UserController();
      return (await userController.getAll()).response;
    });
    return router;
  }
}
