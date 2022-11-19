import 'dart:convert';

import 'package:backend/controller/account/accountController.dart';
import 'package:backend/models/user.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AccountHandle {
  Handler get handler {
    Router router = Router();
    AccountController controller = AccountController();
    router.post('/users/login', (Request request) async {
      String requestData = await request.readAsString();
      Map<String, dynamic> data = json.decode(requestData);
      User user = User.fromMap(data);
      return (await controller.login(user)).response;
    });
    return router;
  }
}
