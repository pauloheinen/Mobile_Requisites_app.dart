import 'package:flutter/material.dart';
import 'package:it_requires_app/Custom/Border/UnderlineBorder/UnderlineCustomBorder.dart';
import 'package:it_requires_app/Custom/Button/ElevatedButtonCustomWidget.dart';
import 'package:it_requires_app/Custom/Divider/DividerCustom.dart';
import 'package:it_requires_app/Custom/Duration/DurationCustomWidget.dart';
import 'package:it_requires_app/Custom/GPSPosition/GPSPositionCustomWidget.dart';
import 'package:it_requires_app/Custom/Image/ImageCustomWidget.dart';
import 'package:it_requires_app/Custom/Rating/RatingCustomWidget.dart';
import 'package:it_requires_app/Custom/TextField/TextFieldCustomWidget.dart';
import 'package:it_requires_app/Models/Project.dart';
import 'package:it_requires_app/Models/Requisite.dart';
import 'package:it_requires_app/Panes/ProjectPanes/ListProjectPane.dart';
import 'package:it_requires_app/Repository/RequisiteRepository.dart';
import 'package:it_requires_app/Utils/Navigator/NavigatorUtil.dart';

class EditRequirementsPane extends StatefulWidget {
  const EditRequirementsPane(
      {Key? key, required this.project, required this.isLocked})
      : super(key: key);

  final Project project;
  final bool isLocked;

  @override
  State<EditRequirementsPane> createState() => _EditRequirementsPaneState();
}

class _EditRequirementsPaneState extends State<EditRequirementsPane> {
  bool _isLoaded = false;

  final List<Requisite> _requisites = List.empty(growable: true);
  final List<RequisiteControllers> _requisitesControllers = [];

  @override
  void initState() {
    _loadRequisites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded == false
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.fromLTRB(6, 10, 6, 0),
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: _requisitesControllers.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _requisiteContainer(
                            _requisitesControllers[index]);
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
                          _concludeDialog();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _requisiteContainer(RequisiteControllers controllers) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldCustomWidget(
                  label: "Nome:",
                  hint: null,
                  controller: controllers.name,
                  enabledBorder: UnderlineCustomBorder.buildCustomBorder(),
                  focusedBorder: UnderlineCustomBorder.buildCustomBorder(),
                  isLocked: widget.isLocked,
                ),
                TextFieldCustomWidget(
                  label: "Descrição:",
                  hint: "Descreva o requisito 🙂",
                  controller: controllers.description,
                  enabledBorder: UnderlineCustomBorder.buildCustomBorder(),
                  focusedBorder: UnderlineCustomBorder.buildCustomBorder(),
                  isLocked: widget.isLocked,
                ),
                TextFieldCustomWidget(
                  label: "Momento do registro: ",
                  controller: controllers.registerMoment,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isLocked: true,
                ),
                GPSPositionCustomWidget(
                  label: "Localização:",
                  controller: controllers.gpsPosition,
                  gpsLocality: controllers.gpsPosition.text,
                ),
                DurationCustomWidget(
                  label: "Duração estimada:",
                  controller: controllers.estimatedTime,
                  isLocked: widget.isLocked,
                ),
                DurationCustomWidget(
                  label: "Duração realizada:",
                  controller: controllers.accomplishedTime,
                  isLocked: widget.isLocked,
                ),
                RatingCustomWidget(
                  icon: Icons.star,
                  color: Colors.yellowAccent,
                  controller: controllers.priority,
                  isLocked: widget.isLocked,
                ),
                DividerCustom.buildCustomDivider(),
                RatingCustomWidget(
                  icon: Icons.warning_amber,
                  color: Colors.red,
                  controller: controllers.dificulty,
                  isLocked: widget.isLocked,
                ),
                ImageCustomWidget(
                  imageController1: controllers.requisiteImage1,
                  imageController2: controllers.requisiteImage2,
                  isLocked: widget.isLocked,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _concludeDialog() async {
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
                                ElevatedButtonCustomWidget(
                                  label: "Não",
                                  () {
                                    setState(() {});
                                    pop();
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
                                ElevatedButtonCustomWidget(
                                  label: "Sim",
                                  () {
                                    _concludeRequisites();
                                    NavigatorUtil.pushTo(context, const ListProjectPane());
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
    for (int i = 0; i < _requisitesControllers.length; i++) {
      _requisites[i].name = _requisitesControllers[i].name.text;
      _requisites[i].description = _requisitesControllers[i].description.text;
      _requisites[i].dtRegister = _requisitesControllers[i].registerMoment.text;
      _requisites[i].estimatedDuration =
          _requisitesControllers[i].estimatedTime.text;
      _requisites[i].accomplishedDuration =
          _requisitesControllers[i].accomplishedTime.text;
      _requisites[i].priority =
          double.parse(_requisitesControllers[i].priority.text);
      _requisites[i].dificulty =
          double.parse(_requisitesControllers[i].dificulty.text);
      _requisites[i].gpsPosition = _requisitesControllers[i].gpsPosition.text;
      _requisites[i].requisiteImage1 =
          _requisitesControllers[i].requisiteImage1.text;
      _requisites[i].requisiteImage2 =
          _requisitesControllers[i].requisiteImage2.text;
    }

    for (var element in _requisites) {
      RequisiteRepository.updateRequisite(element);
    }
  }

  pop() {
    Navigator.of(context).pop();
  }

  void _loadRequisites() async {
    _requisites
        .addAll(await RequisiteRepository.getRequisites(widget.project.id!));

    for (var element in _requisites) {
      RequisiteControllers controller = RequisiteControllers();
      controller.name.text = element.name!;
      controller.description.text = element.description!;
      controller.registerMoment.text = element.dtRegister!;
      controller.gpsPosition.text = element.gpsPosition!;
      controller.estimatedTime.text = element.estimatedDuration!;
      controller.accomplishedTime.text = element.accomplishedDuration!;
      controller.priority.text = element.priority.toString();
      controller.dificulty.text = element.dificulty.toString();
      controller.requisiteImage1.text = element.requisiteImage1!;
      controller.requisiteImage2.text = element.requisiteImage2!;

      _requisitesControllers.add(controller);
    }

    setState(() {
      _isLoaded = true;
    });
  }
}
