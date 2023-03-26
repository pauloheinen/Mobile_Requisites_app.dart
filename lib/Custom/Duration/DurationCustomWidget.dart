import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:it_requires_app/Custom/Border/UnderlineBorder/UnderlineCustomBorder.dart';

class DurationCustomWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isLocked;

  const DurationCustomWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.isLocked,
  });

  @override
  State<DurationCustomWidget> createState() => _DurationState();
}

class _DurationState extends State<DurationCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 25, 0),
      child: TextField(
        controller: widget.controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: false),
        readOnly: true,
        decoration: InputDecoration(
          enabledBorder: UnderlineCustomBorder.buildCustomBorder(),
          focusedBorder: UnderlineCustomBorder.buildCustomBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "horas:minutos",
          hintStyle: const TextStyle(fontSize: 12),
          label: Text(
            widget.label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onTap: () async {
          if (widget.isLocked) {
            return;
          }

          Duration? pickedDuration = await showDurationPicker(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
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
              widget.controller.text = time;
            });
          }
        },
      ),
    );
  }
}
