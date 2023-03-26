import 'package:flutter/material.dart';

class UnderlineCustomBorder {
  static buildCustomBorder() {
    return const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
    );
  }
}