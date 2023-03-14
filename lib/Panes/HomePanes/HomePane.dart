import 'package:flutter/material.dart';

import '../MenuPane/MenuPane.dart';

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
        body: const Material(child: MenuPane()));
  }
}
