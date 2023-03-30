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

  static Future<bool> addUser(User user) async {
    int? addedId;

    DB db = DB.instance;
    addedId = await db.insert(table, user.toJson());

    return addedId == null;
  }

  static Future<User?> getUser(User user) async {
    DB db = DB.instance;

    String sql = '''
                 select * from
                 usuarios
                 where
                 usuarios.nome == '${user.name}'
                 and
                 usuarios.senha == '${user.password}';
                 ''';

    List<dynamic> json = await db.execute(sql);

    if (json.isEmpty) {
      return null;
    }

    return User(
        id: json[0]['id'], name: json[0]['nome'], password: json[0]['senha']);
  }

  static Future<bool> usernameExist(String username) async {
    DB db = DB.instance;

    String sql = '''
                 Select * from usuarios where nome = '$username';
                 ''';

    List<dynamic> json = await db.execute(sql);

    return json.isEmpty;
  }
}
