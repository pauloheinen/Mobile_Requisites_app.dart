import 'dart:core';

import 'package:flutter/material.dart';
import 'package:it_requires_app/Utils/Dates/DateUtil.dart';

import '../../Models/Project.dart';
import '../RequirementsPanes/CreateRequirementsPane.dart';

class CreateProjectPane extends StatefulWidget {
  const CreateProjectPane({Key? key}) : super(key: key);

  @override
  State<CreateProjectPane> createState() => _CreateProject();
}

class _CreateProject extends State<CreateProjectPane> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _initialDatePickerController =
  TextEditingController();
  final TextEditingController _estimatedDatePickerController =
  TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    String formattedDate = DateUtil.formatDateToDDMMMYYYY(DateTime.now());
    _initialDatePickerController.text = formattedDate;
    _estimatedDatePickerController.text = formattedDate;
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
                        Flexible(
                          child: TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  _projectNameController.text.isEmpty) {
                                return 'O campo deve ser preenchido!';
                              }
                              return null;
                            },
                            controller: _projectNameController,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              focusedErrorBorder: _createBorder(Colors.red),
                              errorBorder: _createBorder(Colors.red),
                              focusedBorder: _createBorder(Colors.purpleAccent),
                              enabledBorder: _createBorder(Colors.purpleAccent),
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                              label: const Text(
                                "Nome:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        _createDateWidget(
                            "Data inicial", _initialDatePickerController),
                        _createDateWidget(
                            "Data final", _estimatedDatePickerController),
                        _createConfigureRequirementsButton(
                            "Configurar requisitos", context),
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

  _createDateWidget(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: TextFormField(
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              DateUtil.higherDate(_initialDatePickerController.text,
                  _estimatedDatePickerController.text) ==
                  "1") {
            return 'A data inicial deve ser menor que a final!';
          }
          return null;
        },
        controller: controller,
        style: const TextStyle(fontSize: 20),
        readOnly: true,
        decoration: InputDecoration(
          enabledBorder: _createBorder(Colors.purpleAccent),
          focusedBorder: _createBorder(Colors.purpleAccent),
          errorBorder: _createBorder(Colors.red),
          focusedErrorBorder: _createBorder(Colors.red),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          icon: const Icon(Icons.calendar_month_outlined, color: Colors.white),
          label: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100));
          if (pickedDate != null) {
            setState(
                  () {
                controller.text = DateUtil.formatDateToDDMMMYYYY(pickedDate);
              },
            );
          }
        },
      ),
    );
  }

  _createConfigureRequirementsButton(String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          splashFactory: NoSplash.splashFactory,
          backgroundColor: Colors.purpleAccent,
        ),
        onPressed: () async {
          if (canConfigureRequirements()) {
            String name = _projectNameController.text;
            String initialDate = _initialDatePickerController.text;
            String finalDate = _estimatedDatePickerController.text;

            Project newProject = Project(
                name: name, initialDate: initialDate, finalDate: finalDate);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    CreateRequirementsPane(project: newProject)));
          }
        },
        child: const Text(
          'Configurar requisitos',
        ),
      ),
    );
  }

  _createBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.elliptical(10.0, 10.0),
      ),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  bool canConfigureRequirements() {
    String initialDate = _initialDatePickerController.text;
    String finalDate = _estimatedDatePickerController.text;

    return (_formKey.currentState!.validate() &&
        DateUtil.higherDate(initialDate, finalDate) == "2");
  }
}
