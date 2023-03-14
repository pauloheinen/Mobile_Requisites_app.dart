import 'package:flutter/cupertino.dart';

class Requisite {
  final int? id;
  final String? name;
  final String? description;
  final String? dtRegister;
  final String? estimatedDuration;
  final String? accomplishedDuration;
  double? priority;
  double? dificulty;
  final int refProject;
  final RequisiteControllers? controllers;

  Requisite({
    this.id,
    required this.name,
    required this.description,
    required this.dtRegister,
    required this.estimatedDuration,
    required this.accomplishedDuration,
    required this.priority,
    required this.dificulty,
    required this.refProject,
    this.controllers,
  });

  factory Requisite.fromJson(Map<String, dynamic> json) {
    return Requisite(
      id: json['id'],
      name: json['nome'],
      description: json['descricao'],
      dtRegister: json['dt_registro'],
      estimatedDuration: json['duracao_estimada'],
      accomplishedDuration: json['duracao_realizada'],
      priority: json['prioridade'].toDouble(),
      dificulty: json['dificuldade'].toDouble(),
      refProject: json['ref_projeto'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['nome'] = name;
    data['descricao'] = description;
    data['dt_registro'] = dtRegister;
    data['duracao_estimada'] = estimatedDuration;
    data['duracao_realizada'] = accomplishedDuration;
    data['prioridade'] = priority;
    data['dificuldade'] = dificulty;
    data['ref_projeto'] = refProject;

    return data;
  }
}

class RequisiteControllers {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  TextEditingController _registerMoment = TextEditingController();
  final TextEditingController _estimatedTime = TextEditingController();
  final TextEditingController _accomplishedTime = TextEditingController();
  final TextEditingController _priority = TextEditingController(text: "1.0");
  final TextEditingController _dificulty = TextEditingController(text: "1.0");

  TextEditingController get accomplishedTime => _accomplishedTime;

  TextEditingController get estimatedTime => _estimatedTime;

  TextEditingController get registerMoment => _registerMoment;

  TextEditingController get description => _description;

  TextEditingController get name => _name;

  TextEditingController get priority => _priority;

  TextEditingController get dificulty => _dificulty;

  set registerMoment(TextEditingController value) {
    _registerMoment = value;
  }
}
