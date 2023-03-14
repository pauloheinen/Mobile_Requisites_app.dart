import 'package:flutter/material.dart';
import 'package:it_requires_app/Panes/ProjectPanes/CreateProjectPane.dart';
import 'package:it_requires_app/Panes/ProjectPanes/ListProjectPane.dart';

class MenuPane extends StatefulWidget {
  const MenuPane({Key? key}) : super(key: key);

  @override
  State<MenuPane> createState() => _MenuPaneState();
}

class _MenuPaneState extends State<MenuPane> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          child: Column(
            children: [
              _createProjectButton(context),
              _listProjectButton(context),
            ],
          ),
        ),
      ),
    );
  }

  _createProjectButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        splashFactory: NoSplash.splashFactory,
        backgroundColor: Colors.purpleAccent,
      ),
      onPressed: () {
        newProject(context);
      },
      child: const Text(
        'Criar novo projeto',
      ),
    );
  }

  _listProjectButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        splashFactory: NoSplash.splashFactory,
        backgroundColor: Colors.purpleAccent,
      ),
      onPressed: () {
        listProjects(context);
      },
      child: const Text(
        'Listar projetos',
      ),
    );
  }

  void listProjects(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ListProjectPane()));
  }

  void newProject(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CreateProjectPane()));
  }
}
