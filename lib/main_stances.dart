


import 'package:mysql1/mysql1.dart';

import 'core/database/db_configuration.dart';
import 'core/dependecy_injector/injectors.dart';

class MainStances{
  static final di = Injects.initialize();
  static MySqlConnection? conexao;
  static initialize()async{
  await getConnection();
  }
  static Future<MySqlConnection> getConnection()async{
    MainStances.conexao ??= await MainStances.di.get<DbConfiguration>().connection;
    return MainStances.conexao!;
  }
}

