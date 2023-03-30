import 'package:flutter/material.dart';
import 'package:it_requires_app/Custom/Border/OutlineInputBorder/OutlineCustomBorder.dart';
import 'package:it_requires_app/Utils/Dates/DateUtil.dart';

class DatePickerCustomWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const DatePickerCustomWidget({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  State<DatePickerCustomWidget> createState() => _DatePickerCustomWidgetState();
}

class _DatePickerCustomWidgetState extends State<DatePickerCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: TextFormField(
        controller: widget.controller,
        style: const TextStyle(fontSize: 20),
        readOnly: true,
        decoration: InputDecoration(
          enabledBorder:
              OutlineCustomBorder.buildCustomBorder(Colors.purpleAccent),
          focusedBorder:
              OutlineCustomBorder.buildCustomBorder(Colors.purpleAccent),
          errorBorder: OutlineCustomBorder.buildCustomBorder(Colors.red),
          focusedErrorBorder: OutlineCustomBorder.buildCustomBorder(Colors.red),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          icon: const Icon(Icons.calendar_month_outlined, color: Colors.white),
          label: Text(
            widget.label,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100));
          if (pickedDate != null) {
            setState(
              () {
                widget.controller.text =
                    DateUtil.formatDateToDDMMMYYYY(pickedDate);
              },
            );
          }
        },
      ),
    );
  }
}
