import '../Database/DB.dart';
import '../Models/Requisite.dart';

class RequisiteRepository {
  static const String table = "requisitos";

  static const createTable = ''' create table requisitos
                                (
                                    id                INTEGER
                                        primary key autoincrement,
                                    nome              TEXT    not null,
                                    descricao         TEXT,
                                    dt_registro       DATE    not null,
                                    duracao_estimada  TEXT    not null,
                                    duracao_realizada TEXT    not null,
                                    prioridade        REAL    not null,
                                    dificuldade       REAL    not null,
                                    gps_posicao       TEXT    not null,
                                    requisito_imagem1 TEXT    not null,
                                    requisito_imagem2 TEXT    not null,
                                    ref_projeto       INTEGER not null
                                        references projetos
                                );''';

  static Future<bool> addRequisite(
      int projectId, Map<String, dynamic> jsonRequisite) async {
    int? addedId;

    DB db = DB.instance;
    addedId = await db.insert(table, jsonRequisite);

    return addedId == null;
  }

  static Future<List<Requisite>> getRequisites(int projectId) async {
    DB db = DB.instance;
    dynamic json = List.empty(growable: true);

    String sql = '''
                 select * from
                 requisitos
                 where
                 requisitos.ref_projeto == $projectId ;
                 ''';

    json = await db.execute(sql);

    return List.generate(json.length, (i) {
      return Requisite.fromJson(json[i]);
    });
  }

  static void updateRequisite(Requisite requisite) {
    DB db = DB.instance;

    String sql = '''
                 update 
                 requisitos
                 set
                 nome = '${requisite.name}',
                 descricao = '${requisite.description}',
                 dt_registro = '${requisite.dtRegister}',
                 duracao_estimada = '${requisite.estimatedDuration}',
                 duracao_realizada = '${requisite.accomplishedDuration}',
                 prioridade = ${requisite.priority},
                 dificuldade = ${requisite.dificulty},
                 gps_posicao = '${requisite.gpsPosition}',
                 requisito_imagem1 = '${requisite.requisiteImage1}',
                 requisito_imagem2 = '${requisite.requisiteImage2}'
                 where
                 id = ${requisite.id} ;
                 ''';

    db.execute(sql);
  }
}
