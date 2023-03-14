import '../Database/DB.dart';
import '../Models/Project.dart';

class ProjectRepository {
  static const String table = "projetos";

  static const createTable = '''create table projetos
                                (
                                  id INTEGER
                                    primary key autoincrement,
                                  nome TEXT not null,
                                  dt_inicial NUMBER not null,
                                  dt_final NUMBER not null
                                );''';

  static Future<int?> addProject(Project project) async {
    int? addedId;

    DB db = DB.instance;
    addedId = await db.insert(table, project.toJson());

    return addedId;
  }

  static Future<List<Project>> getProjects() async {
    DB db = DB.instance;
    dynamic json = List.empty(growable: true);

    json = await db.getData(table);

    return List.generate(json.length, (i) {
      return Project.fromJson(json[i]);
    });
  }

  static Future<Map<Project, int>> getProjectsAndRequisitesCount() async {
    DB db = DB.instance;

    List<dynamic> json = List.empty(growable: true);

    String sql = '''
                 select                                             
                 projetos.*,            
                 count(r.ref_projeto) as contagem_requisitos
                 from projetos
                 inner join requisitos r
                 on projetos.id = r.ref_projeto
                 group by r.ref_projeto;
                 ''';

    json = await db.execute(sql);

    List<Project> projects = List.empty(growable: true);
    List<int> requisitesCount = List.empty(growable: true);

    for( int i = 0; i < json.length; i++ ) {
      projects.add(Project(
                id: json[i]['id'],
                name: json[i]['nome'],
                initialDate: json[i]['dt_inicial'],
                finalDate: json[i]['dt_final']));
            requisitesCount.add(json[i]['contagem_requisitos']);
    }

    return Map.fromIterables(projects, requisitesCount);
  }
}
