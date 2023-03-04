import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/*
Para o cadastro dos requisitos, o aplicativo deve disponibilizar o cadastro da
descrição de cada requisito, o momento que foi registrado, o nível de importância
deste requisito para o solicitante, o nível de dificuldade de implementar este requisito,
o tempo (em horas) estimado para a construção e entrega deste requisito

  * textfield requisito
    textfield descrição requisito
    timestamp hora registro
    pontuação 1-5 prioridade
    pontuação dificuldade
    timestamp horas estimado
    timestamp realizado
  *
*/

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
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
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
              _timeFieldWidget("Tempo estimado:", controller.initialTime),
              _timeFieldWidget("Tempo final:", controller.finalTime),
              _ratingFieldWidget(
                  controller.priority, Icons.star, Colors.amberAccent),
              const Divider(
                color: Colors.white,
                height: 10,
                thickness: 1,
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
        maxLength: maxLength,
        keyboardType: TextInputType.multiline,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: _underlineCustomBorder(),
          focusedBorder: _underlineCustomBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hint,
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

  _timeFieldWidget(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 25, 0),
      child: TextField(
        keyboardType: const TextInputType.numberWithOptions(decimal: false),
        controller: controller,
        inputFormatters: <TextInputFormatter>[TimeTextInputFormatter()],
        decoration: InputDecoration(
          enabledBorder: _underlineCustomBorder(),
          focusedBorder: _underlineCustomBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "hh:mm",
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
      borderSide: BorderSide(color: Colors.white),
    );
  }
}

class TimeTextInputFormatter extends TextInputFormatter {
  var _exp;

  TimeTextInputFormatter() {
    _exp = RegExp(r'^[0-9:]+$');
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (!_exp.hasMatch(newValue.text)) return oldValue;

    TextSelection newSelection = newValue.selection;
    print(newValue.text);
    String toRender;
    String newText = newValue.text;

    toRender = '';
    if (newText.length < 5) {
      if (newText == '00:0') {
        toRender = '';
      } else {
        toRender = pack(complete(unpack(newText)));
      }
    } else if (newText.length == 6) {
      toRender = pack(limit(unpack(newText)));
    }

    newSelection = newValue.selection.copyWith(
      baseOffset: math.min(toRender.length, toRender.length),
      extentOffset: math.min(toRender.length, toRender.length),
    );

    return TextEditingValue(
      text: toRender,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }

  String pack(String value) {
    if (value.length != 4) return value;
    return '${value.substring(0, 2)}:${value.substring(2, 4)}';
  }

  String unpack(String value) {
    return value.replaceAll(':', '');
  }

  String complete(String value) {
    if (value.length >= 4) return value;
    final multiplier = 4 - value.length;
    return ('0' * multiplier) + value;
  }

  String limit(String value) {
    if (value.length <= 4) return value;
    return value.substring(value.length - 4, value.length);
  }
}

class RequisitesControllers {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _initialTime = TextEditingController();
  final TextEditingController _finalTime = TextEditingController();
  double priority = 3;
  double dificulty = 3;

  TextEditingController get finalTime => _finalTime;

  TextEditingController get initialTime => _initialTime;

  TextEditingController get description => _description;

  TextEditingController get name => _name;
}
