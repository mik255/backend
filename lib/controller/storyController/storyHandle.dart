import 'dart:convert';

import 'package:backend/controller/productController/products_controller.dart';
import 'package:backend/models/category.model.dart';
import 'package:backend/models/story.model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/products.dart';
import 'storyController.dart';

class StoryHandle {
  Handler get handler {
    Router router = Router();
    StoryController storyController = StoryController();
    router.get('/stories/id', (Request request) async {
      String requestData = await request.readAsString();
      Map<String, dynamic> data = json.decode(requestData);

      return (await storyController.getStoryById(data['id'])).response;
    });
    router.get('/stories', (Request request) async {
      return (await storyController.getAll()).response;
    });
    router.post('/stories', (Request request) async {
      String requestData = await request.readAsString();

      final Story story = Story.fromJson(requestData);

      return (await storyController.setStory(story)).response;
    });
    
    router.put('/stories', (Request request) async {
      String requestData = await request.readAsString();

      final data = json.decode(requestData) as Map<String, dynamic>;

      return (await storyController.updateStory(data)).response;
    });

    router.delete('/stories', (Request request) async {
      String requestData = await request.readAsString();

      final data = json.decode(requestData) as Map<String, dynamic>;

      return (await storyController.deletCategory(data['id'])).response;
    });
    return router;
  }
}
