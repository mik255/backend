import 'dart:io';

import 'package:backend/controller/userController/handle.dart';
import 'package:backend/core/database/db_configuration.dart';
import 'package:backend/core/dependecy_injector/injectors.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;



void main() async{
  final _di = Injects.initialize();
  var conexao = await _di.get<DbConfiguration>().connection;
  var result = await conexao.query('SELECT * FROM usuarios;');
  for(ResultRow r in result){
    print(r.fields);
  }
   var port = int.tryParse(Platform.environment['PORT'] ?? '8080')??8080;
  var cascade =
      Cascade().add((request) => UserHandle().handler(request)).handler;
  final server = await shelf_io.serve(cascade, '0.0.0.0', port);
  print('Serving at http://${server.address.host}:${server.port}');
}
