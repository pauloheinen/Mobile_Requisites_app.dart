import 'package:flutter/cupertino.dart';

class Requisite {
  int? id;
  String? name;
  String? description;
  String? dtRegister;
  String? estimatedDuration;
  String? accomplishedDuration;
  double? priority;
  double? dificulty;
  int refProject;
  String? gpsPosition;
  String? requisiteImage1;
  String? requisiteImage2;

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
    required this.gpsPosition,
    required this.requisiteImage1,
    required this.requisiteImage2,
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
      gpsPosition: json['gps_posicao'],
      requisiteImage1: json['requisito_imagem1'],
      requisiteImage2: json['requisito_imagem2'],
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
    data['gps_posicao'] = gpsPosition;
    data['requisito_imagem1'] = requisiteImage1;
    data['requisito_imagem2'] = requisiteImage2;

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
  final TextEditingController _gpsPosition = TextEditingController();
  final TextEditingController _requisiteImage1 = TextEditingController();
  final TextEditingController _requisiteImage2 = TextEditingController();

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

  TextEditingController get gpsPosition => _gpsPosition;

  TextEditingController get requisiteImage1 => _requisiteImage1;

  TextEditingController get requisiteImage2 => _requisiteImage2;
}
