import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:it_requires_app/Utils/Dates/DateUtil.dart';

class ProjectRequirementsPane extends StatefulWidget {
  const ProjectRequirementsPane({Key? key}) : super(key: key);

  @override
  State<ProjectRequirementsPane> createState() =>
      _ProjectRequirementsPaneState();
}

class _ProjectRequirementsPaneState extends State<ProjectRequirementsPane> {
  final List<RequisitesControllers> _requisitesControllers = [];

  @override
  void initState() {
    _requisitesControllers.add(RequisitesControllers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(6, 10, 6, 0),
          child: ListView.builder(
            itemCount: _requisitesControllers.length,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return _requisiteContainer(_requisitesControllers[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _requisiteContainer(RequisitesControllers controller) {
    controller.registerMoment.text = DateUtil.getActualMomentTimestamp();

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
              _durationFieldWidget("Tempo estimado:", controller.initialTime),
              _durationFieldWidget("Tempo final:", controller.finalTime),
              _ratingFieldWidget(
                  controller.priority, Icons.star, Colors.yellowAccent),
              const Divider(
                color: Colors.purpleAccent,
                height: 10,
                thickness: 2,
                indent: 15,
                endIndent: 25,
              ),
              _ratingFieldWidget(
                  controller.dificulty, Icons.warning_amber, Colors.red),
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
                  "Adicionar",
                ),
                onPressed: () {
                  setState(() =>
                      _requisitesControllers.add(RequisitesControllers()));
                },
              ),
            ),
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
                  setState(() => _requisitesControllers.remove(controller));
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

  _ratingFieldWidget(double controller, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
      child: RatingBar.builder(
        glow: true,
        glowColor: Colors.pinkAccent,
        glowRadius: 3,
        unratedColor: Colors.white,
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, _) => Icon(
          icon,
          color: color,
        ),
        onRatingUpdate: (rating) {
          controller = rating;
        },
      ),
    );
  }

  _underlineCustomBorder() {
    return const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
    );
  }
}

class RequisitesControllers {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  TextEditingController _registerMoment = TextEditingController();
  final TextEditingController _initialTime = TextEditingController();
  final TextEditingController _finalTime = TextEditingController();
  double priority = 3;
  double dificulty = 3;

  TextEditingController get finalTime => _finalTime;

  TextEditingController get initialTime => _initialTime;

  TextEditingController get registerMoment => _registerMoment;

  TextEditingController get description => _description;

  TextEditingController get name => _name;

  set registerMoment(TextEditingController value) {
    _registerMoment = value;
  }
}
