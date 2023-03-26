import 'package:flutter/material.dart';

class DividerCustom {
  static buildCustomDivider() {
    return const Divider(
      color: Colors.purpleAccent,
      height: 10,
      thickness: 2,
      indent: 15,
      endIndent: 25,
    );
  }
}
