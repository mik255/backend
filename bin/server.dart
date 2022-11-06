import 'dart:io';
import 'package:backend/controller/categoryController/categoryHandler.dart';
import 'package:backend/controller/userController/handle.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  var port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  var cascade = Cascade()
      .add((request) => UserHandle().handler(request))
      .add((request) => CategoryHandle().handler(request))
      .handler;
  final server = await shelf_io.serve(cascade, '0.0.0.0', port);
  print('Serving at http://${server.address.host}:${server.port}');
}
