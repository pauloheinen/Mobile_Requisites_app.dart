import 'package:flutter/material.dart';
import 'package:it_requires_app/Configs/Preferences.dart';
import 'package:it_requires_app/Custom/Button/ElevatedButtonCustomWidget.dart';
import 'package:it_requires_app/Panes/HomePanes/LoginPane.dart';
import 'package:it_requires_app/Panes/ProjectPanes/CreateProjectPane.dart';
import 'package:it_requires_app/Panes/ProjectPanes/ListProjectPane.dart';
import 'package:it_requires_app/Utils/Navigator/NavigatorUtil.dart';

class MenuPane extends StatefulWidget {
  const MenuPane({Key? key}) : super(key: key);

  @override
  State<MenuPane> createState() => _MenuPaneState();
}

class _MenuPaneState extends State<MenuPane> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IT Requirements"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.purpleAccent,
          ),
          onPressed: () {
            Preferences.clearRememberMe();
            NavigatorUtil.pushAndRemoveTo(context, const LoginPane());
          },
        ),
      ),
      body: Center(
        child: SizedBox(
          height: 100,
          child: Column(
            children: [
              ElevatedButtonCustomWidget(
                label: "Criar novo projeto",
                labelSize: 16,
                moveToCreateProjectPane,
              ),
              ElevatedButtonCustomWidget(
                label: "Listar projetos",
                labelSize: 16,
                moveToListProjectPane,
              ),
            ],
          ),
        ),
      ),
    );
  }

  moveToListProjectPane() {
    NavigatorUtil.pushTo(context, const ListProjectPane());
  }

  moveToCreateProjectPane() {
    NavigatorUtil.pushTo(context, const CreateProjectPane());
  }
}
