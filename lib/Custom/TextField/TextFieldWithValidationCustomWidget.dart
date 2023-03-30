import 'package:flutter/material.dart';
import 'package:it_requires_app/Custom/Border/OutlineInputBorder/OutlineCustomBorder.dart';

class TextFieldWithValidationCustomWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool shouldValidate;
  final bool? obscure;

  const TextFieldWithValidationCustomWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.shouldValidate,
    this.obscure,
  });

  @override
  State<TextFieldWithValidationCustomWidget> createState() =>
      _TextFieldWithValidationCustomWidgetState();
}

class _TextFieldWithValidationCustomWidgetState
    extends State<TextFieldWithValidationCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: TextFormField(
        validator: (value) {
          if (widget.shouldValidate == true &&
              (value == null ||
                  value.isEmpty ||
                  widget.controller.text.isEmpty)) {
            return 'O campo deve ser preenchido!';
          }
          return null;
        },
        controller: widget.controller,
        keyboardType: TextInputType.multiline,
        obscureText: widget.obscure == null ? false : widget.obscure!,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder:
          OutlineCustomBorder.buildCustomBorder(Colors.purpleAccent),
          focusedBorder:
          OutlineCustomBorder.buildCustomBorder(Colors.purpleAccent),
          focusedErrorBorder: OutlineCustomBorder.buildCustomBorder(Colors.red),
          errorBorder: OutlineCustomBorder.buildCustomBorder(Colors.red),
          label: Text(
            widget.label,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
