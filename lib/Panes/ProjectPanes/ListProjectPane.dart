import 'package:flutter/material.dart';
import 'package:it_requires_app/Models/Project.dart';
import 'package:it_requires_app/Panes/RequirementsPanes/EditRequirementsPane.dart';
import 'package:it_requires_app/Panes/RequirementsPanes/ListRequirementsPane.dart';
import 'package:it_requires_app/Repository/ProjectRepository.dart';
import 'package:it_requires_app/Utils/Toast/ToastUtil.dart';

import '../MenuPane/MenuPane.dart';

class ListProjectPane extends StatefulWidget {
  const ListProjectPane({Key? key}) : super(key: key);

  @override
  State<ListProjectPane> createState() => _ListProjectPaneState();
}

class _ListProjectPaneState extends State<ListProjectPane> {
  bool _isLoaded = false;

  final Map<Project, int> _projectsAndRequisitesCount = {};

  @override
  void initState() {
    _loadProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded == false
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: _projectsAndRequisitesCount.isEmpty
                    ? Container()
                    : GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        itemCount: _projectsAndRequisitesCount.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 200,
                          crossAxisCount: 1,
                          mainAxisSpacing: 25,
                        ),
                        itemBuilder: (context, index) {
                          final project =
                              _projectsAndRequisitesCount.keys.toList()[index];
                          return _createListTile(project);
                        },
                      ),
              ),
            ),
          );
  }

  void _loadProjects() async {
    _projectsAndRequisitesCount
        .addAll(await ProjectRepository.getProjectsAndRequisitesCount());

    if (_projectsAndRequisitesCount.isEmpty) {
      ToastUtil.inform("Ainda não possui projetos listados");
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const MenuPane(),
        ),
        (route) => false,
      );
    }
    setState(() {
      _isLoaded = true;
    });
  }

  Widget _createListTile(Project project) {
    int count = _projectsAndRequisitesCount.entries
        .firstWhere((entry) => entry.key == project)
        .value;

    return ListTile(
      tileColor: Colors.black26,
      enableFeedback: false,
      isThreeLine: true,
      splashColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      title: Text(
        "Projeto: ${project.name!}",
        style: const TextStyle(fontSize: 18),
        softWrap: true,
        overflow: TextOverflow.visible,
      ),
      subtitle: Text(
        "Data inicial: ${project.initialDate}\n"
        "Data final: ${project.finalDate}\n\n"
        "Requisitos: $count",
        style: const TextStyle(fontSize: 14),
      ),
      trailing: PopupMenuButton<int>(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.blueGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          onSelected: (value) {
            if (value == 1) {
              _visualizeRequisite(project);
            } else if (value == 2) {
              _editRequisite(project);
            } else if (value == 3) {
              // _excludeRequisite();
            }
          },
          itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text(
                    "Visualizar",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 2,
                  child: Text(
                    "Editar",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 3,
                  child: Text(
                    "Deletar[not implemented]",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ]),
    );
  }

  void _visualizeRequisite(Project project) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListRequirementsPane(
              project: project,
              isLocked: true,
            )));
  }

  void _editRequisite(project) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            EditRequirementsPane(project: project, isLocked: false)));
  }
}
