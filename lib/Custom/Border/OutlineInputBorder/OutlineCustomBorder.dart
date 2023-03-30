import 'package:flutter/material.dart';

class OutlineCustomBorder {
  static buildCustomBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.elliptical(10.0, 10.0),
      ),
      borderSide: BorderSide(color: color, width: 2),
    );
  }
}
