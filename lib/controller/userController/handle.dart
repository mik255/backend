import 'dart:convert';

import 'package:backend/models/credentials.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/user.dart';
import '../results/results_controller.dart';
import 'userController.dart';

class UserHandle {
  Handler get handler {
    Router router = Router();
    router.get('/users', (Request request) async {
      UserController userController = UserController();
      return (await userController.getAll()).response;
    });
      router.post('/users/results', (Request request) async {
      ResultsController resultsController = ResultsController();
       String requestData = await request.readAsString();
      Map<String, dynamic> data = json.decode(requestData);
      return (await resultsController.getUserResults(data['id'],data['start'],data['end'])).response;
    });
       router.post('/users', (Request request) async {
        UserController userController = UserController();
       String requestData = await request.readAsString();
      User user = User.fromJson(requestData);
      return (await userController.setUser(user)).response;
    });
         router.put('/users', (Request request) async {
        UserController userController = UserController();
       String requestData = await request.readAsString();
      
      return (await userController.updateUser(json.decode(requestData))).response;
    });
         router.delete('/users', (Request request) async {
        UserController userController = UserController();
       String requestData = await request.readAsString();
      User user = User.fromJson(requestData);
      return (await userController.delete(user.id!)).response;
    });
    return router;
  }
}
