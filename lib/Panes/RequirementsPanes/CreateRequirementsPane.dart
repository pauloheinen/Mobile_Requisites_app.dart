import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:it_requires_app/Models/Requisite.dart';
import 'package:it_requires_app/Panes/MenuPane/MenuPane.dart';
import 'package:it_requires_app/Utils/Dates/DateUtil.dart';
import 'package:it_requires_app/Utils/Toast/ToastUtil.dart';

import '../../Models/Project.dart';
import '../../Repository/ProjectRepository.dart';
import '../../Repository/RequisiteRepository.dart';

class CreateRequirementsPane extends StatefulWidget {
  const CreateRequirementsPane({Key? key, required this.project})
      : super(key: key);

  final Project project;

  @override
  State<CreateRequirementsPane> createState() => _CreateRequirements();
}

class _CreateRequirements extends State<CreateRequirementsPane> {
  final List<RequisiteControllers> _requisitesControllers = [];

  @override
  void initState() {
    _requisitesControllers.add(RequisiteControllers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(6, 10, 6, 0),
          child: Stack(
            children: [
              ListView.builder(
                itemCount: _requisitesControllers.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _requisiteContainer(_requisitesControllers[index]);
                },
              ),
              Positioned(
                right: MediaQuery.of(context).devicePixelRatio /
                    MediaQuery.of(context).size.width,
                bottom: MediaQuery.of(context).devicePixelRatio /
                    MediaQuery.of(context).size.height,
                child: IconButton(
                  enableFeedback: false,
                  iconSize: 65,
                  color: Colors.green,
                  icon: const Icon(Icons.check_circle_outline),
                  splashColor: Colors.greenAccent,
                  splashRadius: 28,
                  onPressed: () {
                    _showDialog();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _requisiteContainer(RequisiteControllers controller) {
    if (controller.registerMoment.text.isEmpty) {
      controller.registerMoment.text = DateUtil.getActualMomentTimestamp();
    }

    return Column(
      children: [

        Container(
          decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _textFieldWidget("Nome:", null, null, controller.name),
              _textFieldWidget("Descrição:", "Descreva o requisito 🙂", 1500,
                  controller.description),
              _registerMomentFieldWidget(controller.registerMoment),
              _durationFieldWidget(
                  "Duração estimada:", controller.estimatedTime),
              _durationFieldWidget(
                  "Duração realizada:", controller.accomplishedTime),
              _ratingFieldWidget(
                  controller.priority, Icons.star, Colors.yellowAccent),
              const Divider(
                color: Colors.purpleAccent,
                height: 10,
                thickness: 2,
                indent: 15,
                endIndent: 25,
              ),
              _ratingFieldWidget(controller.dificulty, Icons.warning_amber, Colors.red),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  splashFactory: NoSplash.splashFactory,
                  backgroundColor: Colors.purpleAccent,
                ),
                child: const Text(
                  "Remover",
                ),
                onPressed: () {
                  if (_requisitesControllers.length == 1) {
                    return;
                  }
                  setState(() => _removeRequisite(controller));
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  splashFactory: NoSplash.splashFactory,
                  backgroundColor: Colors.purpleAccent,
                ),
                child: const Text(
                  "Adicionar",
                ),
                onPressed: () {
                  setState(() => _addRequisites(RequisiteControllers()));
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  _textFieldWidget(String label, String? hint, int? maxLength,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 25, 0),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          enabledBorder: _underlineCustomBorder(),
          focusedBorder: _underlineCustomBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12),
          label: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  _registerMomentFieldWidget(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 25, 0),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: false),
        readOnly: true,
        decoration: const InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Text(
            "Momento registrado:",
            style: TextStyle(color: Colors.white, fontSize: 16),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  _durationFieldWidget(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 25, 0),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: false),
        readOnly: true,
        decoration: InputDecoration(
          enabledBorder: _underlineCustomBorder(),
          focusedBorder: _underlineCustomBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "horas:minutos",
          hintStyle: const TextStyle(fontSize: 12),
          label: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onTap: () async {
          Duration? pickedDuration = await showDurationPicker(
            decoration: const BoxDecoration(color: Colors.transparent,),
            snapToMins: 5.0,
            context: context,
            initialTime: const Duration(
              hours: 1,
              minutes: 0,
            ),
          );
          if (pickedDuration != null) {
            String hours = (pickedDuration.inHours).toString().padLeft(2, '0');
            String minutes =
            (pickedDuration.inMinutes % 60).toString().padLeft(2, '0');

            String time = "$hours:$minutes";

            setState(() {
              controller.text = time;
            });
          }
        },
      ),
    );
  }

  _ratingFieldWidget(TextEditingController controller, IconData icon, Color color) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
        child: RatingBar.builder(
          glow: true,
          glowColor: Colors.pinkAccent,
          glowRadius: 3,
          unratedColor: Colors.white,
          initialRating: double.parse(controller.text),
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (context, _) => Icon(
            icon,
            color: color,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              controller.text = rating.toString();
            });
          },
        ),
      ),
    );
  }

  _underlineCustomBorder() {
    return const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
    );
  }

  _showDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: SizedBox(
            width: 800.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text(
                      "Concluir edição?",
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5,
                  thickness: 1,
                ),
                SizedBox(
                  height: 80,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    splashFactory: NoSplash.splashFactory,
                                    backgroundColor: Colors.purpleAccent,
                                  ),
                                  child: const Text(
                                    "Não",
                                  ),
                                  onPressed: () async {
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    splashFactory: NoSplash.splashFactory,
                                    backgroundColor: Colors.purpleAccent,
                                  ),
                                  child: const Text(
                                    "Sim",
                                  ),
                                  onPressed: () async {
                                    await _concludeRequisites();
                                    Navigator.pushAndRemoveUntil<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                        const MenuPane(),
                                      ),
                                          (route) => false,
                                    );
                                  },
                                ),
                              ],
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
        );
      },
    );
  }

  _concludeRequisites() async {
    List<Requisite> requisites = List.empty(growable: true);

    int? id = await ProjectRepository.addProject(widget.project);

    if (id == null) {
      ToastUtil.warning("Ocorreu um erro ao salvar os dados");
      return;
    }

    for (var element in _requisitesControllers) {
      requisites.add(Requisite(
          name: element.name.text,
          description: element.description.text,
          dtRegister: element.registerMoment.text,
          estimatedDuration: element.estimatedTime.text,
          accomplishedDuration: element.accomplishedTime.text,
          priority: double.parse(element.priority.text),
          dificulty: double.parse(element.dificulty.text),
          refProject: id));

    }

    for (var element in requisites) {
      RequisiteRepository.addRequisite(id, element.toJson());
    }
  }

  _addRequisites(RequisiteControllers controller) {
    _requisitesControllers.add(controller);
  }

  _removeRequisite(RequisiteControllers controller) {
    _requisitesControllers.remove(controller);
  }
}