import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:it_requires_app/Custom/Border/UnderlineBorder/UnderlineCustomBorder.dart';
import 'package:it_requires_app/Custom/Button/ElevatedButtonCustomWidget.dart';
import 'package:it_requires_app/Custom/Divider/DividerCustom.dart';
import 'package:it_requires_app/Custom/Duration/DurationCustomWidget.dart';
import 'package:it_requires_app/Custom/GPSPosition/GPSPositionCustomWidget.dart';
import 'package:it_requires_app/Custom/Image/ImageCustomWidget.dart';
import 'package:it_requires_app/Custom/Rating/RatingCustomWidget.dart';
import 'package:it_requires_app/Custom/TextField/TextFieldCustomWidget.dart';
import 'package:it_requires_app/Models/Requisite.dart';
import 'package:it_requires_app/Panes/MenuPane/MenuPane.dart';
import 'package:it_requires_app/Utils/Dates/DateUtil.dart';
import 'package:it_requires_app/Utils/Navigator/NavigatorUtil.dart';
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

  late LocationPermission _permission;

  String _gpsLocality = "Sem localização";

  @override
  void initState() {
    _getActualLocation();
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
              TextFieldCustomWidget(
                  label: "Nome:",
                  hint: null,
                  controller: controller.name,
                  enabledBorder: UnderlineCustomBorder.buildCustomBorder(),
                  focusedBorder: UnderlineCustomBorder.buildCustomBorder(),
                  isLocked: false),
              TextFieldCustomWidget(
                label: "Descrição:",
                hint: "Descreva o requisito 🙂",
                controller: controller.description,
                enabledBorder: UnderlineCustomBorder.buildCustomBorder(),
                focusedBorder: UnderlineCustomBorder.buildCustomBorder(),
                isLocked: false,
              ),
              TextFieldCustomWidget(
                label: "Momento do registro: ",
                controller: controller.registerMoment,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isLocked: true,
              ),
              GPSPositionCustomWidget(
                label: "Localização:",
                controller: controller.gpsPosition,
                gpsLocality: _gpsLocality,
              ),
              DurationCustomWidget(
                label: "Duração estimada:",
                controller: controller.estimatedTime,
                isLocked: false,
              ),
              DurationCustomWidget(
                label: "Duração realizada:",
                controller: controller.accomplishedTime,
                isLocked: false,
              ),
              RatingCustomWidget(
                icon: Icons.star,
                color: Colors.yellowAccent,
                controller: controller.priority,
                isLocked: false,
              ),
              DividerCustom.buildCustomDivider(),
              RatingCustomWidget(
                icon: Icons.warning_amber,
                color: Colors.red,
                controller: controller.dificulty,
                isLocked: false,
              ),
              ImageCustomWidget(
                imageController1: controller.requisiteImage1,
                imageController2: controller.requisiteImage2,
                isLocked: false,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButtonCustomWidget(
              label: "Remover",
              labelSize: 16,
              () {
                if (_requisitesControllers.length == 1) {
                  return;
                }
                setState(() => _removeRequirement(controller));
              },
            ),
            ElevatedButtonCustomWidget(
              label: "Adicionar",
              labelSize: 16,
              () {
                setState(() => _addRequirement(RequisiteControllers()));
              },
            ),
          ],
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButtonCustomWidget(
                          label: "Não",
                          () {
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButtonCustomWidget(
                          label: "Sim",
                          () {
                            _concludeRequisites();
                            _backToMenuPane();
                          },
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
      requisites.add(
        Requisite(
          name: element.name.text,
          description: element.description.text,
          dtRegister: element.registerMoment.text,
          estimatedDuration: element.estimatedTime.text,
          accomplishedDuration: element.accomplishedTime.text,
          priority: double.parse(element.priority.text),
          dificulty: double.parse(element.dificulty.text),
          refProject: id,
          gpsPosition: element.gpsPosition.text,
          requisiteImage1: element.requisiteImage1.text,
          requisiteImage2: element.requisiteImage2.text,
        ),
      );
    }

    for (var element in requisites) {
      RequisiteRepository.addRequisite(id, element.toJson());
    }
  }

  _getActualLocation() async {
    _permission = await Geolocator.requestPermission();

    if (_permission.name == "denied") {
      ToastUtil.warning("O acesso à localização deve ser habilitado!");
      // if the requested permission is denied
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    try {
      List<Placemark> locality =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      String street = locality[0].street!;
      String countryCode = locality[0].isoCountryCode!;
      String postalCode = locality[0].postalCode!;

      setState(() {
        _gpsLocality = "$street, $countryCode, $postalCode";
      });
    } on Exception {
      // we should probably ignore it since it is a network problem that may occur in emulators...
      // in this case, _GPSLocality will receive "Sem localização"
    }
  }

  _addRequirement(RequisiteControllers controller) {
    _requisitesControllers.add(controller);
  }

  _removeRequirement(RequisiteControllers controller) {
    _requisitesControllers.remove(controller);
  }

  void _backToMenuPane() {
    NavigatorUtil.pushTo(context, const MenuPane());
  }
}
