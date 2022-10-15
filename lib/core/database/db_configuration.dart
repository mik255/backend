import 'package:mysql1/mysql1.dart';

abstract class DbConfiguration{

 Future<dynamic> createConnection();
 Future<MySqlConnection> get connection;

}