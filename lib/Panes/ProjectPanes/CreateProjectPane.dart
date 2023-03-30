import 'dart:core';

import 'package:flutter/material.dart';
import 'package:it_requires_app/Custom/Button/ElevatedButtonCustomWidget.dart';
import 'package:it_requires_app/Custom/DatePicker/DatePickerCustomWidget.dart';
import 'package:it_requires_app/Custom/TextField/TextFieldWithValidationCustomWidget.dart';
import 'package:it_requires_app/Utils/Dates/DateUtil.dart';
import 'package:it_requires_app/Utils/Launcher/LauncherUtil.dart';
import 'package:it_requires_app/Utils/Navigator/NavigatorUtil.dart';
import 'package:it_requires_app/Utils/Toast/ToastUtil.dart';

import '../../Models/Project.dart';
import '../RequirementsPanes/CreateRequirementsPane.dart';

class CreateProjectPane extends StatefulWidget {
  const CreateProjectPane({Key? key}) : super(key: key);

  @override
  State<CreateProjectPane> createState() => _CreateProject();
}

class _CreateProject extends State<CreateProjectPane> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _documentLinkController = TextEditingController();
  final TextEditingController _initialDatePickerController =
      TextEditingController();
  final TextEditingController _finalDatePickerController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    String formattedDate = DateUtil.formatDateToDDMMMYYYY(DateTime.now());
    _initialDatePickerController.text = formattedDate;
    _finalDatePickerController.text = formattedDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Text(
                    "Criação de Projeto",
                    style: TextStyle(fontSize: 26),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    "Informe os dados do seu projeto :D",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(25),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFieldWithValidationCustomWidget(
                          label: "Nome:",
                          controller: _projectNameController,
                          shouldValidate: true,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: TextFieldWithValidationCustomWidget(
                                label: "Link para documentação:",
                                controller: _documentLinkController,
                                shouldValidate: false,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                child: IconButton(
                                  enableFeedback: false,
                                  iconSize: 30,
                                  color: Colors.white,
                                  icon: const Icon(Icons.link),
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    _openInWebView(
                                        _documentLinkController.text);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        DatePickerCustomWidget(
                          label: "Data inicial",
                          controller: _initialDatePickerController,
                        ),
                        DatePickerCustomWidget(
                          label: "Data final",
                          controller: _finalDatePickerController,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: ElevatedButtonCustomWidget(
                            label: "Configurar requisitos",
                            labelSize: 16,
                            configureRequirements,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  configureRequirements() {
    if (!_canConfigureRequirements()) {
      return;
    }

    String name = _projectNameController.text;
    String initialDate = _initialDatePickerController.text;
    String finalDate = _finalDatePickerController.text;
    String documentLink = _documentLinkController.text;

    Project newProject = Project(
      name: name,
      initialDate: initialDate,
      finalDate: finalDate,
      documentLink: documentLink,
    );

    NavigatorUtil.pushTo(context, CreateRequirementsPane(project: newProject));
  }

  bool _canConfigureRequirements() {
    String initialDate = _initialDatePickerController.text;
    String finalDate = _finalDatePickerController.text;

    if (DateUtil.higherDate(initialDate, finalDate) == "1") {
      ToastUtil.warning("A data final deve ser maior que a inicial!");
      return false;
    }

    return (_formKey.currentState!.validate() &&
        DateUtil.higherDate(initialDate, finalDate) == "2");
  }

  _openInWebView(String url) async {
    if (url.isEmpty) {
      ToastUtil.warning("Não há link para seguir");
      return;
    }

    if (!await LauncherUtil.launch(url)) {
      ToastUtil.warning("Não foi possível abrir o link!");
    }
  }
}
