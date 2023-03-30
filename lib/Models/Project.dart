class Project {
  final int? id;
  final String? name;
  final String? initialDate;
  final String? finalDate;
  final String? documentLink;

  const Project({
    this.id,
    required this.name,
    required this.initialDate,
    required this.finalDate,
    this.documentLink,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['nome'],
      initialDate: json['dt_inicial'],
      finalDate: json['dt_final'],
      documentLink: json['link_documento'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['nome'] = name;
    data['dt_inicial'] = initialDate;
    data['dt_final'] = finalDate;
    data['link_documento'] = documentLink;

    return data;
  }
}
