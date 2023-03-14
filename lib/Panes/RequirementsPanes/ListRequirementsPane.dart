import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:it_requires_app/Models/Project.dart';
import 'package:it_requires_app/Models/Requisite.dart';

import '../../Repository/RequisiteRepository.dart';

class ListRequirementsPane extends StatefulWidget {
  const ListRequirementsPane({Key? key, required this.project})
      : super(key: key);

  final Project project;

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
                _textFieldWidget(
                    "Nome:", TextEditingController(text: requisite.name)),
                _textFieldWidget("Descrição:",
                    TextEditingController(text: requisite.description)),
                _registerMomentFieldWidget(
                    TextEditingController(text: requisite.dtRegister)),
                _durationFieldWidget("Duração estimada:",
                    TextEditingController(text: requisite.estimatedDuration)),
                _durationFieldWidget(
                    "Duração realizada:",
                    TextEditingController(
                        text: requisite.accomplishedDuration)),
                _ratingFieldWidget(
                    requisite.priority, Icons.star, Colors.yellowAccent),
                const Divider(
                  color: Colors.purpleAccent,
                  height: 10,
                  thickness: 2,
                  indent: 15,
                  endIndent: 25,
                ),
                _ratingFieldWidget(
                    requisite.dificulty, Icons.warning_amber, Colors.red),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _textFieldWidget(String label, TextEditingController? controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 25, 0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          enabledBorder: _underlineCustomBorder(),
          focusedBorder: _underlineCustomBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
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

  _registerMomentFieldWidget(TextEditingController? controller) {
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

  _durationFieldWidget(String label, TextEditingController? controller) {
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

  _ratingFieldWidget(double? controller, IconData icon, Color color) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
        child: RatingBar.builder(
          ignoreGestures: true,
          glow: true,
          glowColor: Colors.pinkAccent,
          glowRadius: 3,
          unratedColor: Colors.white,
          initialRating: controller!,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (context, _) => Icon(
            icon,
            color: color,
          ),
          onRatingUpdate: (rating) {},
        ),
      ),
    );
  }

  _underlineCustomBorder() {
    return const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
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
