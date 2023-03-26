import 'package:flutter/material.dart';

class GPSPositionCustomWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String gpsLocality;

  const GPSPositionCustomWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.gpsLocality,
  });

  @override
  _GPSPositionState createState() => _GPSPositionState();
}

class _GPSPositionState extends State<GPSPositionCustomWidget> {
  @override
  Widget build(BuildContext context) {
    widget.controller.text = widget.gpsLocality;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 25, 0),
        child: TextField(
          controller: widget.controller,
          readOnly: true,
          decoration: const InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: Text(
              "Localização:",
              style: TextStyle(color: Colors.white, fontSize: 16),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
