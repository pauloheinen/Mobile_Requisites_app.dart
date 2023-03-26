import 'package:flutter/material.dart';
import 'package:it_requires_app/Custom/Border/UnderlineBorder/UnderlineCustomBorder.dart';
import 'package:it_requires_app/Custom/Divider/DividerCustom.dart';
import 'package:it_requires_app/Custom/Duration/DurationCustomWidget.dart';
import 'package:it_requires_app/Custom/GPSPosition/GPSPositionCustomWidget.dart';
import 'package:it_requires_app/Custom/Image/ImageCustomWidget.dart';
import 'package:it_requires_app/Custom/Rating/RatingCustomWidget.dart';
import 'package:it_requires_app/Custom/TextField/TextFieldCustomWidget.dart';
import 'package:it_requires_app/Models/Project.dart';
import 'package:it_requires_app/Models/Requisite.dart';

import '../../Repository/RequisiteRepository.dart';

class ListRequirementsPane extends StatefulWidget {
  const ListRequirementsPane(
      {Key? key, required this.project, required this.isLocked})
      : super(key: key);

  final Project project;
  final bool isLocked;

  @override
  State<ListRequirementsPane> createState() => _ListRequirementsPaneState();
}

class _ListRequirementsPaneState extends State<ListRequirementsPane> {
  bool _isLoaded = false;

  final List<Requisite> _requisites = List.empty(growable: true);

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
                      itemCount: _requisites.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _requisiteContainer(_requisites[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _requisiteContainer(Requisite requisite) {
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
                  controller: TextEditingController(text: requisite.name),
                  enabledBorder: UnderlineCustomBorder.buildCustomBorder(),
                  focusedBorder: UnderlineCustomBorder.buildCustomBorder(),
                  isLocked: widget.isLocked,
                ),
                TextFieldCustomWidget(
                  label: "Descrição:",
                  hint: "Descreva o requisito 🙂",
                  controller:
                      TextEditingController(text: requisite.description),
                  enabledBorder: UnderlineCustomBorder.buildCustomBorder(),
                  focusedBorder: UnderlineCustomBorder.buildCustomBorder(),
                  isLocked: widget.isLocked,
                ),
                TextFieldCustomWidget(
                  label: "Momento do registro: ",
                  controller: TextEditingController(text: requisite.dtRegister),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isLocked: widget.isLocked,
                ),
                GPSPositionCustomWidget(
                  label: "Localização:",
                  controller:
                      TextEditingController(text: requisite.gpsPosition),
                  gpsLocality: requisite.gpsPosition!,
                ),
                DurationCustomWidget(
                  label: "Duração estimada:",
                  controller:
                      TextEditingController(text: requisite.estimatedDuration),
                  isLocked: widget.isLocked,
                ),
                DurationCustomWidget(
                  label: "Duração realizada:",
                  controller: TextEditingController(
                      text: requisite.accomplishedDuration),
                  isLocked: widget.isLocked,
                ),
                RatingCustomWidget(
                  icon: Icons.star,
                  color: Colors.yellowAccent,
                  controller: TextEditingController(
                      text: requisite.priority.toString()),
                  isLocked: widget.isLocked,
                ),
                DividerCustom.buildCustomDivider(),
                RatingCustomWidget(
                  icon: Icons.warning_amber,
                  color: Colors.red,
                  controller: TextEditingController(
                      text: requisite.dificulty.toString()),
                  isLocked: widget.isLocked,
                ),
                ImageCustomWidget(
                  imageController1:
                      TextEditingController(text: requisite.requisiteImage1),
                  imageController2:
                      TextEditingController(text: requisite.requisiteImage2),
                  isLocked: widget.isLocked,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _loadRequisites() async {
    _requisites
        .addAll(await RequisiteRepository.getRequisites(widget.project.id!));

    setState(() {
      _isLoaded = true;
    });
  }
}
