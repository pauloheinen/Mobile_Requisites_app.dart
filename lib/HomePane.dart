import 'package:flutter/material.dart';
import 'package:it_requires_app/Panes/ProjectInfoPane.dart';

class HomePane extends StatefulWidget {
  const HomePane({Key? key}) : super(key: key);

  @override
  State<HomePane> createState() => _HomePaneState();
}

class _HomePaneState extends State<HomePane> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("IT Requirements")),
        body: const ProjectInfoPane());
  }
}
