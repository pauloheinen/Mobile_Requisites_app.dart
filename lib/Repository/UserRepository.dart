import 'package:it_requires_app/Database/DB.dart';

import '../Models/User.dart';

class UserRepository {
  static const String table = "usuarios";

  static String createTable = '''create table usuarios
                                 (
                                   id INTEGER
                                     primary key autoincrement,
                                   nome TEXT not null
                                     unique,
                                   senha TEXT not null
                                 );''';

  addUser(User user) async {
    var db = await DB.instance.getDatabase;

    await db?.insert(table, user.toJson());
  }

  Future<User?> getUser(User user) async {
    return null;
  }
}
