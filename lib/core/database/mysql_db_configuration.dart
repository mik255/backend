

import 'package:backend/core/database/db_configuration.dart';
import 'package:mysql1/mysql1.dart';

class MySqlDBConfiguration implements DbConfiguration{
  MySqlConnection? _connection;
  @override
  Future<MySqlConnection> get connection async{
    _connection ??= await createConnection();
    if(_connection == null) {
      throw Exception('erro ao criar concexão [mika]');
    }
    return _connection!;
  }

  @override
  Future<MySqlConnection> createConnection() async{
    return await MySqlConnection.connect(
     ConnectionSettings(
      host: 'localhost',port: 3306,
      user: 'dart_user',
      password: 'dart_pass',
      db: 'dart'
    )
  );
  }

}