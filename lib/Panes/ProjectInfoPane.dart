import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ProjectRequirementsPane.dart';

class ProjectInfoPane extends StatefulWidget {
  const ProjectInfoPane({Key? key}) : super(key: key);

  @override
  State<ProjectInfoPane> createState() => _ProjectInfo();
}

class _ProjectInfo extends State<ProjectInfoPane> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _initialDatePickerController =
      TextEditingController();
  final TextEditingController _estimatedDatePickerController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    String formattedDate =
        DateFormat('dd-MMM-yyyy', "pt_br").format(DateTime.now());
    _initialDatePickerController.text = formattedDate;
    _estimatedDatePickerController.text = formattedDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Text(
                    "Requisitos do Projeto",
                    style: TextStyle(fontSize: 26),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text("Informe os dados do seu projeto :D",
                      style: TextStyle(fontSize: 15)),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(25),
                  height: 350,
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
                            keyboardType: TextInputType.multiline,
                            controller: _projectNameController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              label: const Text(
                                "Nome do projeto:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              focusedErrorBorder: createBorder(Colors.red),
                              errorBorder: createBorder(Colors.red),
                              focusedBorder: createBorder(Colors.purpleAccent),
                              enabledBorder: createBorder(Colors.purpleAccent),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        createDataWidget(
                            "Data inicial", _initialDatePickerController),
                        createDataWidget(
                            "Data final", _estimatedDatePickerController),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              splashFactory: NoSplash.splashFactory,
                              backgroundColor: Colors.purpleAccent,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (isEstimatedHigher(
                                    _initialDatePickerController.text,
                                    _estimatedDatePickerController.text)) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const ProjectRequirementsPane()));
                                }
                              }
                            },
                            child: const Text(
                              'Tela de requisitos ->',
                            ),
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

  createDataWidget(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          icon: const Icon(Icons.calendar_month_outlined, color: Colors.white),
          label: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          focusedBorder: createBorder(Colors.purpleAccent),
          enabledBorder: createBorder(Colors.purpleAccent),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              locale: const Locale("pt", "BR"),
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100));
          if (pickedDate != null) {
            String formattedDate =
                DateFormat('dd-MMM-yyyy', "pt").format(pickedDate);
            setState(
              () {
                controller.text = formattedDate;
              },
            );
          }
        },
      ),
    );
  }

  createBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.elliptical(10.0, 10.0),
      ),
      borderSide: BorderSide(color: color, width: 2),
    );
  }
}

bool isEstimatedHigher(String initial, String estimated) {
  DateTime dt1 = DateTime.parse(convertDate(initial));
  DateTime dt2 = DateTime.parse(convertDate(estimated));

  if (dt2.compareTo(dt1) > 0) {
    return true;
  }
  return false;
}

convertDate(String date) {
  var inputFormat = DateFormat('dd-MMM-yyyy', 'pt');
  var inputDate = inputFormat.parse(date);

  var outputFormat = DateFormat('yyyy-MM-dd', 'pt');
  return outputFormat.format(inputDate);
}
