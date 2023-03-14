

class Project {
  final int? id;
  final String? name;
  final String? initialDate;
  final String? finalDate;

  const Project({
    this.id,
    required this.name,
    required this.initialDate,
    required this.finalDate,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['nome'],
      initialDate: json['dt_inicial'],
      finalDate: json['dt_final'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['nome'] = name;
    data['dt_inicial'] = initialDate;
    data['dt_final'] = finalDate;

    return data;
  }
}