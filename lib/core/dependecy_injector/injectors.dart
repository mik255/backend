import '../database/db_configuration.dart';
import '../database/mysql_db_configuration.dart';
import 'dependency_injector.dart';

class Injects {
  static DependencyInjector initialize() {
    var di = DependencyInjector();

    di.register<DbConfiguration>(() => MySqlDBConfiguration());

    return di;
  }
}